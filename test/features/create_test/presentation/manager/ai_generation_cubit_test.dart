import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/features/create_test/data/local/ai_generation_task_storage.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/start_ai_question_generation_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_ai_question_generation_status_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/start_ai_question_generation_use_case.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';

class MockStartAiQuestionGenerationUseCase extends Mock
    implements StartAiQuestionGenerationUseCase {}

class MockGetAiQuestionGenerationStatusUseCase extends Mock
    implements GetAiQuestionGenerationStatusUseCase {}

class FakeAiQuestionGenerationParams extends Fake
    implements AiQuestionGenerationParams {}

class MemoryAiGenerationTaskStorage implements AiGenerationTaskStorage {
  StoredAiGenerationTask? task;

  @override
  Future<void> clear() async {
    task = null;
  }

  @override
  StoredAiGenerationTask? read() => task;

  @override
  Future<void> save(StoredAiGenerationTask task) async {
    this.task = task;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAiQuestionGenerationParams());
  });

  late MockStartAiQuestionGenerationUseCase startGeneration;
  late MockGetAiQuestionGenerationStatusUseCase getStatus;
  late MemoryAiGenerationTaskStorage storage;
  late AiGenerationCubit cubit;

  setUp(() {
    startGeneration = MockStartAiQuestionGenerationUseCase();
    getStatus = MockGetAiQuestionGenerationStatusUseCase();
    storage = MemoryAiGenerationTaskStorage();
    cubit = AiGenerationCubit(
      startAiQuestionGenerationUseCase: startGeneration,
      getAiQuestionGenerationStatusUseCase: getStatus,
      storage: storage,
      pollingDelay: Duration.zero,
    );
  });

  tearDown(() => cubit.close());

  test('saves the request id and exposes completed questions', () async {
    when(() => startGeneration(params: any(named: 'params'))).thenAnswer((
      invocation,
    ) async {
      final params =
          invocation.namedArguments[#params] as AiQuestionGenerationParams;
      params.onSendProgress?.call(50, 100);
      return _startResponse(41);
    });
    when(
      () => getStatus(generationRequestId: 41),
    ).thenAnswer((_) async => _completedStatus(41));

    await cubit.startGeneration(_args());

    expect(storage.task?.requestId, 41);
    expect(cubit.state.phase, AiGenerationPhase.completed);
    expect(cubit.state.uploadProgress, 0.5);
    expect(cubit.state.generatedQuestions, hasLength(1));
    expect(cubit.state.editorArgs?.generatedQuestions, hasLength(1));
  });

  test('restores a saved request and fetches its result', () async {
    storage.task = _storedTask(72);
    when(
      () => getStatus(generationRequestId: 72),
    ).thenAnswer((_) async => _completedStatus(72));

    await cubit.restorePendingGeneration();

    expect(cubit.state.task?.requestId, 72);
    expect(cubit.state.isCompleted, isTrue);
    expect(cubit.state.editorArgs, isNotNull);
  });

  test('keeps the task recoverable after repeated polling errors', () async {
    storage.task = _storedTask(93);
    when(
      () => getStatus(generationRequestId: 93),
    ).thenThrow(StateError('offline'));

    await cubit.restorePendingGeneration();

    expect(cubit.state.phase, AiGenerationPhase.waitingForConnection);
    expect(cubit.state.isFailed, isFalse);
    expect(cubit.state.task?.requestId, 93);
    expect(storage.task?.requestId, 93);
    verify(
      () => getStatus(generationRequestId: 93),
    ).called(AiGenerationCubit.maxConsecutivePollingErrors);
  });

  test('stored task serializes all data needed to resume the editor', () {
    final original = _storedTask(105);

    final restored = StoredAiGenerationTask.fromJson(original.toJson());

    expect(restored.requestId, original.requestId);
    expect(restored.sourceType, original.sourceType);
    expect(restored.questionCount, original.questionCount);
    expect(restored.level, original.level);
    expect(restored.language, original.language);
    expect(restored.fileNames, original.fileNames);
    expect(restored.createdAt.toUtc(), original.createdAt.toUtc());
  });
}

CreateTestInitialArgs _args() {
  return CreateTestInitialArgs(
    mode: CreateTestCreationMode.aiFile,
    mediaFiles: [PlatformFile(name: 'lesson.pdf', size: 10)],
    aiQuestionCount: 10,
    aiLevel: 'سهل',
    aiLanguage: 'عربية',
  );
}

StoredAiGenerationTask _storedTask(int requestId) {
  return StoredAiGenerationTask(
    requestId: requestId,
    sourceType: 'Pdf',
    questionCount: 10,
    level: 'سهل',
    language: 'عربية',
    fileNames: const ['lesson.pdf'],
    createdAt: DateTime.utc(2026, 8, 20, 12),
  );
}

StartAiQuestionGenerationResponseEntity _startResponse(int requestId) {
  return StartAiQuestionGenerationResponseEntity(
    success: true,
    title: 'تم',
    generationRequestId: requestId,
    status: 'pending',
    reused: false,
    statusCode: 202,
  );
}

AiQuestionGenerationStatusResponseEntity _completedStatus(int requestId) {
  return AiQuestionGenerationStatusResponseEntity(
    success: true,
    title: 'تم',
    statusCode: 200,
    data: AiQuestionGenerationStatusEntity(
      id: requestId,
      status: 'completed',
      sourceType: 'Pdf',
      requestedQuestionCount: 10,
      questionActuallyGenerated: 1,
      difficultyLevel: 'Easy',
      language: 'Arabic',
      provider: 'test-provider',
      questions: const [
        GeneratedAiQuestionEntity(
          questionText: 'ما الإجابة الصحيحة؟',
          hintText: 'تلميح',
          options: [
            GeneratedAiQuestionOptionEntity(
              optionText: 'الأولى',
              isCorrect: true,
            ),
            GeneratedAiQuestionOptionEntity(
              optionText: 'الثانية',
              isCorrect: false,
            ),
          ],
        ),
      ],
    ),
  );
}
