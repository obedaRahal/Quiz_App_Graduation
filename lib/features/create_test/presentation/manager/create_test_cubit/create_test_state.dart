import 'package:file_picker/file_picker.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_existing_media_state.dart';

class CreateTestQuestionOptionState {
  final int? id;
  final String text;

  const CreateTestQuestionOptionState({this.id, this.text = ''});

  CreateTestQuestionOptionState copyWith({
    Object? id = _sentinel,
    String? text,
  }) {
    return CreateTestQuestionOptionState(
      id: id == _sentinel ? this.id : id as int?,
      text: text ?? this.text,
    );
  }
}

class CreateTestQuestionState {
  final int? id;
  final String questionText;
  final List<String> options;
  final List<int?> optionIds;
  final int correctOptionIndex;
  final String explanation;

  const CreateTestQuestionState({
    this.id,
    required this.questionText,
    required this.options,
    this.optionIds = const [],
    required this.correctOptionIndex,
    this.explanation = '',
  });

  List<int?> get normalizedOptionIds {
    if (optionIds.length == options.length) return optionIds;

    return List<int?>.generate(
      options.length,
      (index) => index < optionIds.length ? optionIds[index] : null,
    );
  }

  CreateTestQuestionState copyWith({
    Object? id = _sentinel,
    String? questionText,
    List<String>? options,
    List<int?>? optionIds,
    int? correctOptionIndex,
    String? explanation,
  }) {
    return CreateTestQuestionState(
      id: id == _sentinel ? this.id : id as int?,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      optionIds: optionIds ?? this.optionIds,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
    );
  }
}

class CreateTestState {
  final String title;
  final String description;
  final List<String> pendingScientificCategories;
  final String level;
  final int? durationSeconds;
  final int? successLimit;
  final String language;

  final bool isPublished;
  final String price;

  final int pendingDurationSeconds;

  final List<String> selectedScientificCategories;
  final String selectedAcademicLevel;

  final List<CreateTestQuestionState> questions;
  final List<CreateTestExistingMediaState> existingAiMedia;
  final String aiProvider;

  final String draftQuestionText;
  final List<CreateTestQuestionOptionState> draftOptions;
  final int? draftCorrectOptionIndex;
  final String draftExplanation;
  final int? editingQuestionIndex;
  final List<int> selectedSampleQuestions;
  final bool isScientificClassificationsLoading;
  final String? scientificClassificationsError;
  final List<ScientificClassificationGroupEntity>
  scientificClassificationGroups;

  final List<int> selectedScientificInterestIds;
  final List<int> pendingScientificInterestIds;

  final bool isCreateManualTestLoading;
  final String? createManualTestError;
  final CreateManualTestResponseEntity? createManualTestResponse;
  final CreateTestCreationMode creationMode;
  final List<PlatformFile> aiMediaFiles;
  final int? aiRequestedQuestionCount;
  final bool isAiQuestionGenerationLoading;
  final String? aiQuestionGenerationError;
  final int? aiGenerationRequestId;
  final bool isAiQuestionGenerationCompleted;
  final List<GeneratedAiQuestionEntity> aiGeneratedQuestions;
  final bool isEditMode;
  final int? editingTestId;
  final bool wasInitiallyPublished;
  final bool isEditableQuestionsLoading;
  final String? editableQuestionsError;
  final List<int> initialPreviewQuestionIds;
  final bool isUpdateTestLoading;
  final String? updateTestError;
  final UpdateTestResponseEntity? updateTestResponse;
  const CreateTestState({
    this.title = '',
    this.description = '',
    this.level = 'سهل',
    this.durationSeconds,
    this.successLimit,
    this.language = 'عربية',
    this.isPublished = true,
    this.price = '',
    this.pendingDurationSeconds = 600,
    this.selectedScientificCategories = const [],
    this.pendingScientificCategories = const [],
    this.selectedAcademicLevel = '',
    this.questions = const [],
    this.existingAiMedia = const [],
    this.aiProvider = '',
    this.draftQuestionText = '',
    this.draftOptions = const [
      CreateTestQuestionOptionState(),
      CreateTestQuestionOptionState(),
    ],
    this.draftCorrectOptionIndex,
    this.draftExplanation = '',
    this.editingQuestionIndex,
    this.selectedSampleQuestions = const [],
    this.isScientificClassificationsLoading = false,
    this.scientificClassificationsError,
    this.scientificClassificationGroups = const [],
    this.selectedScientificInterestIds = const [],
    this.pendingScientificInterestIds = const [],
    this.isCreateManualTestLoading = false,
    this.createManualTestError,
    this.createManualTestResponse,
    this.creationMode = CreateTestCreationMode.manual,
    this.aiMediaFiles = const [],
    this.aiRequestedQuestionCount,
    this.isAiQuestionGenerationLoading = false,
    this.aiQuestionGenerationError,
    this.aiGenerationRequestId,
    this.isAiQuestionGenerationCompleted = false,
    this.aiGeneratedQuestions = const [],
    this.isEditMode = false,
    this.editingTestId,
    this.wasInitiallyPublished = false,
    this.isEditableQuestionsLoading = false,
    this.editableQuestionsError,
    this.initialPreviewQuestionIds = const [],
    this.isUpdateTestLoading = false,
    this.updateTestError,
    this.updateTestResponse,
  });

  CreateTestState copyWith({
    String? title,
    String? description,
    String? level,
    Object? durationSeconds = _sentinel,
    Object? successLimit = _sentinel,
    String? language,
    bool? isPublished,
    String? price,
    int? pendingDurationSeconds,
    List<String>? selectedScientificCategories,
    String? selectedAcademicLevel,
    List<CreateTestQuestionState>? questions,
    List<CreateTestExistingMediaState>? existingAiMedia,

    String? draftQuestionText,
    List<CreateTestQuestionOptionState>? draftOptions,
    Object? draftCorrectOptionIndex = _sentinel,
    String? draftExplanation,
    List<String>? pendingScientificCategories,
    Object? editingQuestionIndex = _sentinel,
    List<int>? selectedSampleQuestions,
    bool? isScientificClassificationsLoading,
    Object? scientificClassificationsError = _sentinel,
    List<ScientificClassificationGroupEntity>? scientificClassificationGroups,
    List<int>? selectedScientificInterestIds,
    List<int>? pendingScientificInterestIds,
    bool? isCreateManualTestLoading,
    Object? createManualTestError = _sentinel,
    Object? createManualTestResponse = _sentinel,
    CreateTestCreationMode? creationMode,
    List<PlatformFile>? aiMediaFiles,
    Object? aiRequestedQuestionCount = _sentinel,
    bool? isAiQuestionGenerationLoading,
    Object? aiQuestionGenerationError = _sentinel,
    Object? aiGenerationRequestId = _sentinel,
    bool? isAiQuestionGenerationCompleted,
    List<GeneratedAiQuestionEntity>? aiGeneratedQuestions,
    String? aiProvider,
    bool? isEditMode,
    Object? editingTestId = _sentinel,
    bool? wasInitiallyPublished,
    bool? isEditableQuestionsLoading,
    Object? editableQuestionsError = _sentinel,
    List<int>? initialPreviewQuestionIds,
    bool? isUpdateTestLoading,
    Object? updateTestError = _sentinel,
    Object? updateTestResponse = _sentinel,
  }) {
    return CreateTestState(
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      durationSeconds: durationSeconds == _sentinel
          ? this.durationSeconds
          : durationSeconds as int?,
      successLimit: successLimit == _sentinel
          ? this.successLimit
          : successLimit as int?,
      language: language ?? this.language,
      isPublished: isPublished ?? this.isPublished,
      price: price ?? this.price,
      pendingDurationSeconds:
          pendingDurationSeconds ?? this.pendingDurationSeconds,
      selectedScientificCategories:
          selectedScientificCategories ?? this.selectedScientificCategories,
      selectedAcademicLevel:
          selectedAcademicLevel ?? this.selectedAcademicLevel,
      questions: questions ?? this.questions,
      existingAiMedia: existingAiMedia ?? this.existingAiMedia,

      draftQuestionText: draftQuestionText ?? this.draftQuestionText,
      draftOptions: draftOptions ?? this.draftOptions,
      draftCorrectOptionIndex: draftCorrectOptionIndex == _sentinel
          ? this.draftCorrectOptionIndex
          : draftCorrectOptionIndex as int?,
      draftExplanation: draftExplanation ?? this.draftExplanation,
      pendingScientificCategories:
          pendingScientificCategories ?? this.pendingScientificCategories,
      editingQuestionIndex: editingQuestionIndex == _sentinel
          ? this.editingQuestionIndex
          : editingQuestionIndex as int?,
      selectedSampleQuestions:
          selectedSampleQuestions ?? this.selectedSampleQuestions,
      isScientificClassificationsLoading:
          isScientificClassificationsLoading ??
          this.isScientificClassificationsLoading,

      scientificClassificationsError:
          scientificClassificationsError == _sentinel
          ? this.scientificClassificationsError
          : scientificClassificationsError as String?,

      scientificClassificationGroups:
          scientificClassificationGroups ?? this.scientificClassificationGroups,
      selectedScientificInterestIds:
          selectedScientificInterestIds ?? this.selectedScientificInterestIds,

      pendingScientificInterestIds:
          pendingScientificInterestIds ?? this.pendingScientificInterestIds,

      isCreateManualTestLoading:
          isCreateManualTestLoading ?? this.isCreateManualTestLoading,

      createManualTestError: createManualTestError == _sentinel
          ? this.createManualTestError
          : createManualTestError as String?,

      createManualTestResponse: createManualTestResponse == _sentinel
          ? this.createManualTestResponse
          : createManualTestResponse as CreateManualTestResponseEntity?,
      creationMode: creationMode ?? this.creationMode,
      aiMediaFiles: aiMediaFiles ?? this.aiMediaFiles,
      aiRequestedQuestionCount: aiRequestedQuestionCount == _sentinel
          ? this.aiRequestedQuestionCount
          : aiRequestedQuestionCount as int?,
      isAiQuestionGenerationLoading:
          isAiQuestionGenerationLoading ?? this.isAiQuestionGenerationLoading,

      aiQuestionGenerationError: aiQuestionGenerationError == _sentinel
          ? this.aiQuestionGenerationError
          : aiQuestionGenerationError as String?,

      aiGenerationRequestId: aiGenerationRequestId == _sentinel
          ? this.aiGenerationRequestId
          : aiGenerationRequestId as int?,

      isAiQuestionGenerationCompleted:
          isAiQuestionGenerationCompleted ??
          this.isAiQuestionGenerationCompleted,

      aiGeneratedQuestions: aiGeneratedQuestions ?? this.aiGeneratedQuestions,
      aiProvider: aiProvider ?? this.aiProvider,
      isEditMode: isEditMode ?? this.isEditMode,
      editingTestId: editingTestId == _sentinel
          ? this.editingTestId
          : editingTestId as int?,
      wasInitiallyPublished:
          wasInitiallyPublished ?? this.wasInitiallyPublished,
      isEditableQuestionsLoading:
          isEditableQuestionsLoading ?? this.isEditableQuestionsLoading,

      editableQuestionsError: editableQuestionsError == _sentinel
          ? this.editableQuestionsError
          : editableQuestionsError as String?,

      initialPreviewQuestionIds:
          initialPreviewQuestionIds ?? this.initialPreviewQuestionIds,
      isUpdateTestLoading: isUpdateTestLoading ?? this.isUpdateTestLoading,

      updateTestError: updateTestError == _sentinel
          ? this.updateTestError
          : updateTestError as String?,

      updateTestResponse: updateTestResponse == _sentinel
          ? this.updateTestResponse
          : updateTestResponse as UpdateTestResponseEntity?,
    );
  }

  bool get canCreateDraftQuestion {
    final hasQuestion = draftQuestionText.trim().isNotEmpty;

    final validOptions = draftOptions
        .where((option) => option.text.trim().isNotEmpty)
        .toList();

    final hasEnoughOptions = validOptions.length >= 2;

    final hasCorrectAnswer =
        draftCorrectOptionIndex != null &&
        draftCorrectOptionIndex! >= 0 &&
        draftCorrectOptionIndex! < draftOptions.length &&
        draftOptions[draftCorrectOptionIndex!].text.trim().isNotEmpty;

    return hasQuestion && hasEnoughOptions && hasCorrectAnswer;
  }

  int get requiredSampleQuestionsCount {
    if (!isPublished || questions.length < 5) return 0;

    final count = (questions.length * 0.10).ceil();

    if (count < 1) return 1;
    if (count > questions.length) return questions.length;

    return count;
  }

  bool get hasValidSampleQuestions {
    if (!isPublished) return true;
    if (questions.length < 5) return false;

    return selectedSampleQuestions.length == requiredSampleQuestionsCount;
  }

  bool get canSubmit {
    final hasBasicRequiredFields =
        title.trim().isNotEmpty &&
        description.trim().isNotEmpty &&
        level.trim().isNotEmpty &&
        language.trim().isNotEmpty &&
        selectedAcademicLevel.trim().isNotEmpty &&
        selectedScientificInterestIds.isNotEmpty &&
        questions.length >= 5 &&
        questions.length <= 100;

    if (!hasBasicRequiredFields) return false;
    if (isCreateManualTestLoading || isUpdateTestLoading) return false;

    if (!isPublished) {
      return true;
    }

    return hasValidSampleQuestions;
  }

  String get headerTitle {
    if (isEditMode) return 'تعديل اختبار';

    return switch (creationMode) {
      CreateTestCreationMode.manual => 'الطريقة اليدوية',
      CreateTestCreationMode.aiImages => 'الطريقة الآلية (صور)',
      CreateTestCreationMode.aiFile => 'الطريقة الآلية (ملف)',
    };
  }

  bool get isAiMode {
    return creationMode == CreateTestCreationMode.aiImages ||
        creationMode == CreateTestCreationMode.aiFile;
  }

  bool get isAiImages {
    return creationMode == CreateTestCreationMode.aiImages;
  }

  bool get isAiFile {
    return creationMode == CreateTestCreationMode.aiFile;
  }
}

const Object _sentinel = Object();
