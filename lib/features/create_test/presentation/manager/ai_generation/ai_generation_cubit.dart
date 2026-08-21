import 'dart:async';

import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'package:quiz_app_grad/features/create_test/data/local/ai_generation_task_storage.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_ai_question_generation_status_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/start_ai_question_generation_use_case.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';

class AiGenerationCubit extends SafeCubit<AiGenerationState> {
  final StartAiQuestionGenerationUseCase startAiQuestionGenerationUseCase;
  final GetAiQuestionGenerationStatusUseCase
  getAiQuestionGenerationStatusUseCase;
  final AiGenerationTaskStorage storage;
  final Duration pollingDelay;

  static const pollingInterval = Duration(seconds: 5);
  static const maxConsecutivePollingErrors = 6;
  static const maxUnknownStatuses = 3;

  bool _isPolling = false;
  int _pollingSession = 0;
  int _operationSession = 0;
  CreateTestInitialArgs? _currentArgs;

  AiGenerationCubit({
    required this.startAiQuestionGenerationUseCase,
    required this.getAiQuestionGenerationStatusUseCase,
    required this.storage,
    this.pollingDelay = pollingInterval,
  }) : super(const AiGenerationState());

  CreateTestInitialArgs? get loadingArgs => state.loadingArgs ?? _currentArgs;

  Future<void> restorePendingGeneration() async {
    if (state.isUploading || state.hasTask) return;

    final task = storage.read();
    if (task == null) return;

    emit(
      AiGenerationState(
        phase: AiGenerationPhase.processing,
        task: task,
        requestedQuestionCount: task.questionCount,
      ),
    );

    await resumePolling();
  }

  Future<void> startGeneration(CreateTestInitialArgs args) async {
    if (state.isBusy || state.isCompleted) return;

    final validationError = _validateArgs(args);
    if (validationError != null) {
      emit(
        AiGenerationState(
          phase: AiGenerationPhase.failed,
          mediaFiles: args.mediaFiles,
          requestedQuestionCount: args.aiQuestionCount ?? 0,
          errorMessage: validationError,
        ),
      );
      return;
    }

    final operationSession = ++_operationSession;
    _currentArgs = args;

    emit(
      AiGenerationState(
        phase: AiGenerationPhase.uploading,
        mediaFiles: args.mediaFiles,
        requestedQuestionCount: args.aiQuestionCount ?? 10,
      ),
    );

    try {
      final response = await startAiQuestionGenerationUseCase(
        params: AiQuestionGenerationParams(
          sourceType: args.isAiImages ? 'Images' : 'Pdf',
          questionCount: args.aiQuestionCount ?? 10,
          difficultyLevel: _mapLevel(args.aiLevel ?? 'سهل'),
          language: _mapLanguage(args.aiLanguage ?? 'عربية'),
          files: args.mediaFiles,
          onSendProgress: (sent, total) {
            if (operationSession != _operationSession) return;
            emit(state.copyWith(uploadedBytes: sent, totalUploadBytes: total));
          },
        ),
      );

      if (operationSession != _operationSession) return;

      if (response.generationRequestId <= 0) {
        emit(
          state.copyWith(
            phase: AiGenerationPhase.failed,
            errorMessage: 'لم يتم استلام رقم طلب التوليد من الخادم',
          ),
        );
        return;
      }

      final task = StoredAiGenerationTask(
        requestId: response.generationRequestId,
        sourceType: args.isAiImages ? 'Images' : 'Pdf',
        questionCount: args.aiQuestionCount ?? 10,
        level: args.aiLevel ?? 'سهل',
        language: args.aiLanguage ?? 'عربية',
        fileNames: args.mediaFiles.map((file) => file.name).toList(),
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          phase: AiGenerationPhase.processing,
          task: task,
          errorMessage: null,
          requestedQuestionCount: task.questionCount,
        ),
      );

      try {
        await storage.save(task);
        if (operationSession != _operationSession) {
          await storage.clear();
          return;
        }
      } catch (_) {
        if (operationSession != _operationSession) return;
        emit(
          state.copyWith(
            errorMessage:
                'تعذر حفظ المهمة محليًا، أبقِ التطبيق مفتوحًا حتى اكتمالها.',
          ),
        );
      }

      await resumePolling();
    } catch (error) {
      if (operationSession != _operationSession) return;
      emit(
        state.copyWith(
          phase: AiGenerationPhase.failed,
          errorMessage: _readableError(
            error,
            fallback: 'تعذر رفع الملفات وبدء عملية التوليد',
          ),
        ),
      );
    }
  }

  Future<void> resumePolling() async {
    final task = state.task;
    if (task == null || state.isCompleted || _isPolling) return;

    final session = ++_pollingSession;
    _isPolling = true;
    var consecutiveErrors = 0;
    var unknownStatuses = 0;

    if (state.phase == AiGenerationPhase.waitingForConnection ||
        state.phase == AiGenerationPhase.failed) {
      emit(
        state.copyWith(phase: AiGenerationPhase.processing, errorMessage: null),
      );
    }

    try {
      while (!isClosed && session == _pollingSession) {
        try {
          final response = await getAiQuestionGenerationStatusUseCase(
            generationRequestId: task.requestId,
          );
          if (isClosed || session != _pollingSession) return;

          final data = response.data;
          consecutiveErrors = 0;

          if (data.isCompleted) {
            if (data.questions.isEmpty) {
              emit(
                state.copyWith(
                  phase: AiGenerationPhase.failed,
                  errorMessage: 'اكتملت العملية لكن لم يتم إنشاء أي سؤال صالح',
                ),
              );
              return;
            }

            emit(
              state.copyWith(
                phase: AiGenerationPhase.completed,
                generatedQuestions: data.questions,
                provider: data.provider,
                errorMessage: null,
                actuallyGenerated: data.questionActuallyGenerated > 0
                    ? data.questionActuallyGenerated
                    : data.questions.length,
                requestedQuestionCount: data.requestedQuestionCount > 0
                    ? data.requestedQuestionCount
                    : task.questionCount,
              ),
            );
            return;
          }

          if (data.isFailed) {
            emit(
              state.copyWith(
                phase: AiGenerationPhase.failed,
                errorMessage: data.failure?.trim().isNotEmpty == true
                    ? data.failure
                    : 'فشلت عملية توليد الأسئلة',
              ),
            );
            return;
          }

          if (!data.isProcessing) {
            unknownStatuses++;
            if (unknownStatuses >= maxUnknownStatuses) {
              emit(
                state.copyWith(
                  phase: AiGenerationPhase.waitingForConnection,
                  errorMessage:
                      'وصلت حالة غير معروفة من الخادم. يمكنك إعادة التحقق لاحقًا.',
                ),
              );
              return;
            }
          } else {
            unknownStatuses = 0;
          }

          emit(
            state.copyWith(
              phase: AiGenerationPhase.processing,
              errorMessage: null,
              actuallyGenerated: data.questionActuallyGenerated,
              requestedQuestionCount: data.requestedQuestionCount > 0
                  ? data.requestedQuestionCount
                  : task.questionCount,
            ),
          );
        } catch (error) {
          consecutiveErrors++;
          if (isClosed || session != _pollingSession) return;

          emit(
            state.copyWith(
              phase: AiGenerationPhase.waitingForConnection,
              errorMessage:
                  'تعذر التحقق من حالة التوليد. سنحاول مجددًا عند توفر الاتصال.',
            ),
          );

          if (consecutiveErrors >= maxConsecutivePollingErrors) {
            return;
          }
        }

        await Future<void>.delayed(pollingDelay);
      }
    } finally {
      if (session == _pollingSession) {
        _isPolling = false;
      }
    }
  }

  Future<void> refresh() async {
    if (state.task == null || state.isUploading) return;
    _stopPolling();
    await resumePolling();
  }

  Future<void> clearTask() async {
    _operationSession++;
    _stopPolling();
    await storage.clear();
    _currentArgs = null;
    emit(const AiGenerationState());
  }

  void resetForSignedOutSession() {
    _operationSession++;
    _stopPolling();
    _currentArgs = null;
    emit(const AiGenerationState());
    unawaited(storage.clear());
  }

  void _stopPolling() {
    _pollingSession++;
    _isPolling = false;
  }

  String _mapLevel(String value) {
    return switch (value.trim()) {
      'سهل' => 'Easy',
      'متوسط' => 'Medium',
      'صعب' => 'Hard',
      _ => 'Easy',
    };
  }

  String? _validateArgs(CreateTestInitialArgs args) {
    if (!args.isAiMode) return 'طريقة توليد الأسئلة غير صالحة';
    if (args.mediaFiles.isEmpty) {
      return args.isAiImages
          ? 'يرجى إرفاق صورة واحدة على الأقل'
          : 'يرجى إرفاق ملف واحد';
    }
    if (args.isAiImages && args.mediaFiles.length > 3) {
      return 'يمكن إرفاق ثلاث صور فقط';
    }
    if (args.isAiFile && args.mediaFiles.length != 1) {
      return 'يرجى إرفاق ملف واحد فقط';
    }

    final questionCount = args.aiQuestionCount;
    if (questionCount == null || questionCount < 10 || questionCount > 40) {
      return 'عدد الأسئلة يجب أن يكون بين 10 و 40';
    }
    if (!const ['سهل', 'متوسط', 'صعب'].contains(args.aiLevel?.trim())) {
      return 'مستوى الأسئلة غير صالح';
    }
    if (!const ['عربية', 'إنكليزية'].contains(args.aiLanguage?.trim())) {
      return 'لغة الأسئلة غير صالحة';
    }

    return null;
  }

  String _mapLanguage(String value) {
    return switch (value.trim()) {
      'عربية' => 'Arabic',
      'إنكليزية' => 'English',
      _ => 'Arabic',
    };
  }

  String _readableError(Object error, {required String fallback}) {
    final message = error.toString().trim();
    return message.isEmpty ? fallback : message;
  }
}
