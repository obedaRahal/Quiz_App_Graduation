import 'package:file_picker/file_picker.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_existing_media_state.dart';

enum CreateTestCreationMode {
  manual,
  aiImages,
  aiFile,
  contentImages,
  contentFile,
}

class CreateTestInitialArgs {
  final CreateTestCreationMode mode;
  final List<PlatformFile> mediaFiles;

  final int? aiQuestionCount;
  final String? aiLevel;
  final String? aiLanguage;
  final String? aiProvider;

  final List<GeneratedAiQuestionEntity> generatedQuestions;
  final bool isEditMode;
  final int? editingTestId;

  final String? initialTitle;
  final String? initialDescription;
  final bool? initialIsPublished;
  final String? initialPrice;
  final String? initialLevel;
  final int? initialDurationSeconds;
  final int? initialSuccessLimit;
  final String? initialLanguage;
  final String? initialAcademicLevel;
  final List<int> initialScientificInterestIds;
  final List<String> initialScientificCategories;
  final List<CreateTestQuestionState> initialQuestions;
  final List<int> initialSelectedSampleQuestions;
  final List<CreateTestExistingMediaState> existingAiMedia;
  final bool shouldFetchEditQuestions;
  final List<int> initialPreviewQuestionIds;
  final bool isContentEditMode;
  final int? editingContentId;
  const CreateTestInitialArgs({
    this.mode = CreateTestCreationMode.manual,
    this.mediaFiles = const [],
    this.aiQuestionCount,
    this.aiLevel,
    this.aiLanguage,
    this.generatedQuestions = const [],
    this.aiProvider,
    this.isEditMode = false,
    this.editingTestId,
    this.initialTitle,
    this.initialDescription,
    this.initialIsPublished,
    this.initialPrice,
    this.initialLevel,
    this.initialDurationSeconds,
    this.initialSuccessLimit,
    this.initialLanguage,
    this.initialAcademicLevel,
    this.initialScientificInterestIds = const [],
    this.initialScientificCategories = const [],
    this.initialQuestions = const [],
    this.initialSelectedSampleQuestions = const [],
    this.existingAiMedia = const [],
    this.shouldFetchEditQuestions = false,
    this.initialPreviewQuestionIds = const [],
    this.isContentEditMode = false,
    this.editingContentId,
  });

  bool get isAiMode {
    return mode == CreateTestCreationMode.aiImages ||
        mode == CreateTestCreationMode.aiFile;
  }

  bool get isAiImages => mode == CreateTestCreationMode.aiImages;

  bool get isAiFile => mode == CreateTestCreationMode.aiFile;

  bool get isContentMode {
    return mode == CreateTestCreationMode.contentImages ||
        mode == CreateTestCreationMode.contentFile;
  }

  bool get isContentImages => mode == CreateTestCreationMode.contentImages;

  bool get isContentFile => mode == CreateTestCreationMode.contentFile;
bool get isContentEdit {
  return isContentEditMode &&
      (mode == CreateTestCreationMode.contentImages ||
       mode == CreateTestCreationMode.contentFile);
}
  CreateTestInitialArgs copyWith({
    CreateTestCreationMode? mode,
    List<PlatformFile>? mediaFiles,
    int? aiQuestionCount,
    String? aiLevel,
    String? aiLanguage,
    List<GeneratedAiQuestionEntity>? generatedQuestions,
    String? aiProvider,
    bool? isEditMode,
    int? editingTestId,
    String? initialTitle,
    String? initialDescription,
    bool? initialIsPublished,
    String? initialPrice,
    String? initialLevel,
    int? initialDurationSeconds,
    int? initialSuccessLimit,
    String? initialLanguage,
    String? initialAcademicLevel,
    List<int>? initialScientificInterestIds,
    List<String>? initialScientificCategories,
    List<CreateTestQuestionState>? initialQuestions,
    List<int>? initialSelectedSampleQuestions,
    List<CreateTestExistingMediaState>? existingAiMedia,
    bool? shouldFetchEditQuestions,
    List<int>? initialPreviewQuestionIds,
    bool? isContentEditMode,
    int? editingContentId,
  }) {
    return CreateTestInitialArgs(
      mode: mode ?? this.mode,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      aiQuestionCount: aiQuestionCount ?? this.aiQuestionCount,
      aiLevel: aiLevel ?? this.aiLevel,
      aiLanguage: aiLanguage ?? this.aiLanguage,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
      aiProvider: aiProvider ?? this.aiProvider,
      isEditMode: isEditMode ?? this.isEditMode,
      editingTestId: editingTestId ?? this.editingTestId,
      initialTitle: initialTitle ?? this.initialTitle,
      initialDescription: initialDescription ?? this.initialDescription,
      initialIsPublished: initialIsPublished ?? this.initialIsPublished,
      initialPrice: initialPrice ?? this.initialPrice,
      initialLevel: initialLevel ?? this.initialLevel,
      initialDurationSeconds:
          initialDurationSeconds ?? this.initialDurationSeconds,
      initialSuccessLimit: initialSuccessLimit ?? this.initialSuccessLimit,
      initialLanguage: initialLanguage ?? this.initialLanguage,
      initialAcademicLevel: initialAcademicLevel ?? this.initialAcademicLevel,
      initialScientificInterestIds:
          initialScientificInterestIds ?? this.initialScientificInterestIds,
      initialScientificCategories:
          initialScientificCategories ?? this.initialScientificCategories,
      initialQuestions: initialQuestions ?? this.initialQuestions,
      initialSelectedSampleQuestions:
          initialSelectedSampleQuestions ?? this.initialSelectedSampleQuestions,
      existingAiMedia: existingAiMedia ?? this.existingAiMedia,
      shouldFetchEditQuestions:
          shouldFetchEditQuestions ?? this.shouldFetchEditQuestions,
      initialPreviewQuestionIds:
          initialPreviewQuestionIds ?? this.initialPreviewQuestionIds,
      isContentEditMode: isContentEditMode ?? this.isContentEditMode,
      editingContentId: editingContentId ?? this.editingContentId,
    );
  }
}
