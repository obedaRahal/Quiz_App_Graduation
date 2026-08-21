import 'package:file_picker/file_picker.dart';
import 'package:quiz_app_grad/features/create_test/data/local/ai_generation_task_storage.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';

enum AiGenerationPhase {
  idle,
  uploading,
  processing,
  waitingForConnection,
  completed,
  failed,
}

class AiGenerationState {
  final AiGenerationPhase phase;
  final StoredAiGenerationTask? task;
  final List<PlatformFile> mediaFiles;
  final List<GeneratedAiQuestionEntity> generatedQuestions;
  final String provider;
  final String? errorMessage;
  final int uploadedBytes;
  final int totalUploadBytes;
  final int actuallyGenerated;
  final int requestedQuestionCount;

  const AiGenerationState({
    this.phase = AiGenerationPhase.idle,
    this.task,
    this.mediaFiles = const [],
    this.generatedQuestions = const [],
    this.provider = '',
    this.errorMessage,
    this.uploadedBytes = 0,
    this.totalUploadBytes = 0,
    this.actuallyGenerated = 0,
    this.requestedQuestionCount = 0,
  });

  bool get hasTask => task != null;

  bool get isUploading => phase == AiGenerationPhase.uploading;

  bool get isProcessing =>
      phase == AiGenerationPhase.processing ||
      phase == AiGenerationPhase.waitingForConnection;

  bool get isBusy => isUploading || isProcessing;

  bool get isCompleted => phase == AiGenerationPhase.completed;

  bool get isFailed => phase == AiGenerationPhase.failed;

  double? get uploadProgress {
    if (totalUploadBytes <= 0) return null;
    return (uploadedBytes / totalUploadBytes).clamp(0, 1);
  }

  double? get generationProgress {
    final requested = requestedQuestionCount > 0
        ? requestedQuestionCount
        : task?.questionCount ?? 0;
    if (requested <= 0 || actuallyGenerated <= 0) return null;
    return (actuallyGenerated / requested).clamp(0, 1);
  }

  CreateTestInitialArgs? get editorArgs {
    final currentTask = task;
    if (currentTask == null || generatedQuestions.isEmpty) return null;

    return CreateTestInitialArgs(
      mode: currentTask.isImages
          ? CreateTestCreationMode.aiImages
          : CreateTestCreationMode.aiFile,
      mediaFiles: mediaFiles,
      aiQuestionCount: currentTask.questionCount,
      aiLevel: currentTask.level,
      aiLanguage: currentTask.language,
      generatedQuestions: generatedQuestions,
      aiProvider: provider,
    );
  }

  CreateTestInitialArgs? get loadingArgs {
    final currentTask = task;
    if (currentTask == null) return null;

    return CreateTestInitialArgs(
      mode: currentTask.isImages
          ? CreateTestCreationMode.aiImages
          : CreateTestCreationMode.aiFile,
      mediaFiles: mediaFiles,
      aiQuestionCount: currentTask.questionCount,
      aiLevel: currentTask.level,
      aiLanguage: currentTask.language,
    );
  }

  AiGenerationState copyWith({
    AiGenerationPhase? phase,
    Object? task = _sentinel,
    List<PlatformFile>? mediaFiles,
    List<GeneratedAiQuestionEntity>? generatedQuestions,
    String? provider,
    Object? errorMessage = _sentinel,
    int? uploadedBytes,
    int? totalUploadBytes,
    int? actuallyGenerated,
    int? requestedQuestionCount,
  }) {
    return AiGenerationState(
      phase: phase ?? this.phase,
      task: task == _sentinel ? this.task : task as StoredAiGenerationTask?,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
      provider: provider ?? this.provider,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      uploadedBytes: uploadedBytes ?? this.uploadedBytes,
      totalUploadBytes: totalUploadBytes ?? this.totalUploadBytes,
      actuallyGenerated: actuallyGenerated ?? this.actuallyGenerated,
      requestedQuestionCount:
          requestedQuestionCount ?? this.requestedQuestionCount,
    );
  }
}

const Object _sentinel = Object();
