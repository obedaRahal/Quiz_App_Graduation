import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/create_manual_test_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_ai_question_generation_status_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_scientific_classifications_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/start_ai_question_generation_use_case.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestCubit extends Cubit<CreateTestState> {
  final GetScientificClassificationsUseCase getScientificClassificationsUseCase;
  final CreateManualTestUseCase createManualTestUseCase;
  final StartAiQuestionGenerationUseCase startAiQuestionGenerationUseCase;
  final GetAiQuestionGenerationStatusUseCase
  getAiQuestionGenerationStatusUseCase;

  CreateTestCubit({
    required this.getScientificClassificationsUseCase,
    required this.createManualTestUseCase,
    required this.startAiQuestionGenerationUseCase,
    required this.getAiQuestionGenerationStatusUseCase,
  }) : super(const CreateTestState());

  static const int titleMaxLength = 150;
  static const int descriptionMaxLength = 250;

  static const List<String> levels = ['سهل', 'متوسط', 'صعب'];

  static const List<int> successLimits = [20, 30, 40, 50, 60, 70, 80];

  static const List<String> languages = ['عربية', 'إنكليزية', 'مختلطة'];
  static const int minQuestionsCount = 5;
  static const int maxQuestionsCount = 100;
  static const int minOptionsCount = 2;
  static const int maxOptionsCount = 5;

  static const int questionMaxLength = 500;
  static const int optionMaxLength = 150;
  static const int explanationMaxLength = 1000;
  static const int maxScientificCategoriesCount = 3;

  static const Map<String, List<CreateTestScientificCategoryUiModel>>
  scientificCategoriesGroups = {
    'اهتمامات علمية أساسية': [
      CreateTestScientificCategoryUiModel(title: 'علوم أساسية', icon: '🔬'),
      CreateTestScientificCategoryUiModel(title: 'الرياضيات', icon: '▦'),
      CreateTestScientificCategoryUiModel(title: 'التفكير المنطقي', icon: '⚖'),
      CreateTestScientificCategoryUiModel(title: 'الفيزياء', icon: '⌂'),
      CreateTestScientificCategoryUiModel(title: 'الكيمياء', icon: '◈'),
      CreateTestScientificCategoryUiModel(
        title: 'الأحياء وعلوم الحياة',
        icon: '♣',
      ),
    ],
    'التكنولوجيا والحاسوب': [
      CreateTestScientificCategoryUiModel(title: 'علوم الحاسوب', icon: '▭'),
      CreateTestScientificCategoryUiModel(title: 'البرمجة', icon: '⌨'),
      CreateTestScientificCategoryUiModel(title: 'تحليل البيانات', icon: '▤'),
      CreateTestScientificCategoryUiModel(title: 'هندسة البرمجيات', icon: '⌘'),
      CreateTestScientificCategoryUiModel(title: 'الذكاء الاصطناعي', icon: '✺'),
    ],
    'الهندسة والتقنيات': [
      CreateTestScientificCategoryUiModel(
        title: 'الهندسة المعلوماتية',
        icon: '⌁',
      ),
      CreateTestScientificCategoryUiModel(title: 'الهندسة المدنية', icon: '◉'),
    ],
  };
  static const int aiMinQuestionCount = 10;
  static const int aiMaxQuestionCount = 40;
  static const int aiPollingIntervalSeconds = 5;
  void changeTitle(String value) {
    final limited = value.length > titleMaxLength
        ? value.substring(0, titleMaxLength)
        : value;

    emit(state.copyWith(title: limited));
  }

  void changeDescription(String value) {
    final limited = value.length > descriptionMaxLength
        ? value.substring(0, descriptionMaxLength)
        : value;

    emit(state.copyWith(description: limited));
  }

  void changeLevel(String value) {
    emit(state.copyWith(level: value));
  }

  void changeLanguage(String value) {
    emit(state.copyWith(language: value));
  }

  void changeSuccessLimit(int? value) {
    emit(state.copyWith(successLimit: value));
  }

  void clearSuccessLimit() {
    emit(state.copyWith(successLimit: null));
  }

  static const int minDurationSeconds = 600; // 10:00
  static const int maxDurationSeconds = 10800; // 180:00

  void prepareDurationPicker() {
    emit(
      state.copyWith(
        pendingDurationSeconds: state.durationSeconds ?? minDurationSeconds,
      ),
    );
  }

  void changePendingDuration({required int minutes, required int seconds}) {
    final normalizedSeconds = seconds.clamp(0, 59);
    final totalSeconds = (minutes * 60) + normalizedSeconds;

    emit(
      state.copyWith(
        pendingDurationSeconds: totalSeconds.clamp(
          minDurationSeconds,
          maxDurationSeconds,
        ),
      ),
    );
  }

  void confirmDuration() {
    emit(state.copyWith(durationSeconds: state.pendingDurationSeconds));
  }

  void clearDuration() {
    emit(state.copyWith(durationSeconds: null));
  }

  void changePublishStatus(bool value) {
    emit(
      state.copyWith(
        isPublished: value,
        price: value ? state.price : '',
        selectedSampleQuestions: value
            ? state.selectedSampleQuestions
            : const [],
      ),
    );
  }

  void changePrice(String value) {
    emit(state.copyWith(price: value));
  }

  void changeAcademicLevel(String value) {
    emit(state.copyWith(selectedAcademicLevel: value));
  }

  void resetQuestionDraft() {
    emit(
      state.copyWith(
        draftQuestionText: '',
        draftOptions: const [
          CreateTestQuestionOptionState(),
          CreateTestQuestionOptionState(),
        ],
        draftCorrectOptionIndex: null,
        draftExplanation: '',
        editingQuestionIndex: null,
      ),
    );
  }

  void startEditingQuestion(int index) {
    if (index < 0 || index >= state.questions.length) return;

    final question = state.questions[index];

    emit(
      state.copyWith(
        draftQuestionText: question.questionText,
        draftOptions: question.options
            .map((option) => CreateTestQuestionOptionState(text: option))
            .toList(),
        draftCorrectOptionIndex: question.correctOptionIndex,
        draftExplanation: question.explanation,
        editingQuestionIndex: index,
      ),
    );
  }

  void changeDraftQuestionText(String value) {
    final limited = value.length > questionMaxLength
        ? value.substring(0, questionMaxLength)
        : value;

    emit(state.copyWith(draftQuestionText: limited));
  }

  void changeDraftOptionText({required int index, required String value}) {
    if (index < 0 || index >= state.draftOptions.length) return;

    final limited = value.length > optionMaxLength
        ? value.substring(0, optionMaxLength)
        : value;

    final updatedOptions = [...state.draftOptions];
    updatedOptions[index] = updatedOptions[index].copyWith(text: limited);

    final shouldClearCorrect =
        state.draftCorrectOptionIndex == index && limited.trim().isEmpty;

    emit(
      state.copyWith(
        draftOptions: updatedOptions,
        draftCorrectOptionIndex: shouldClearCorrect
            ? null
            : state.draftCorrectOptionIndex,
      ),
    );
  }

  void addDraftOption() {
    if (state.draftOptions.length >= maxOptionsCount) return;

    emit(
      state.copyWith(
        draftOptions: [
          ...state.draftOptions,
          const CreateTestQuestionOptionState(),
        ],
      ),
    );
  }

  void removeDraftOption(int index) {
    if (state.draftOptions.length <= minOptionsCount) return;
    if (index < 0 || index >= state.draftOptions.length) return;

    final updatedOptions = [...state.draftOptions]..removeAt(index);

    int? updatedCorrectIndex = state.draftCorrectOptionIndex;

    if (updatedCorrectIndex == index) {
      updatedCorrectIndex = null;
    } else if (updatedCorrectIndex != null && updatedCorrectIndex > index) {
      updatedCorrectIndex--;
    }

    emit(
      state.copyWith(
        draftOptions: updatedOptions,
        draftCorrectOptionIndex: updatedCorrectIndex,
      ),
    );
  }

  void selectDraftCorrectOption(int index) {
    if (index < 0 || index >= state.draftOptions.length) return;
    if (state.draftOptions[index].text.trim().isEmpty) return;

    emit(state.copyWith(draftCorrectOptionIndex: index));
  }

  void changeDraftExplanation(String value) {
    final limited = value.length > explanationMaxLength
        ? value.substring(0, explanationMaxLength)
        : value;

    emit(state.copyWith(draftExplanation: limited));
  }

  void createDraftQuestion() {
    if (!state.canCreateDraftQuestion) return;

    final options = state.draftOptions
        .map((option) => option.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final correctIndex = state.draftCorrectOptionIndex!;

    final question = CreateTestQuestionState(
      questionText: state.draftQuestionText.trim(),
      options: options,
      correctOptionIndex: correctIndex,
      explanation: state.draftExplanation.trim(),
    );

    final editingIndex = state.editingQuestionIndex;

    if (editingIndex != null) {
      // تعديل سؤال موجود
      if (editingIndex < 0 || editingIndex >= state.questions.length) return;

      final updatedQuestions = [...state.questions];
      updatedQuestions[editingIndex] = question;

      emit(
        state.copyWith(
          questions: updatedQuestions,
          draftQuestionText: '',
          draftOptions: const [
            CreateTestQuestionOptionState(),
            CreateTestQuestionOptionState(),
          ],
          draftCorrectOptionIndex: null,
          draftExplanation: '',
          editingQuestionIndex: null,
          selectedSampleQuestions: [], // <--- أضف هذا لتصفير العينة عند تعديل
        ),
      );
      return;
    }

    // إنشاء سؤال جديد
    if (state.questions.length >= maxQuestionsCount) return;

    emit(
      state.copyWith(
        questions: [...state.questions, question],
        draftQuestionText: '',
        draftOptions: const [
          CreateTestQuestionOptionState(),
          CreateTestQuestionOptionState(),
        ],
        draftCorrectOptionIndex: null,
        draftExplanation: '',
        editingQuestionIndex: null,
        selectedSampleQuestions: [], // <--- أضف هذا لتصفير العينة عند الإضافة
      ),
    );
  }

  void removeQuestion(int index) {
    if (index < 0 || index >= state.questions.length) return;

    final updatedQuestions = [...state.questions]..removeAt(index);

    final updatedSampleQuestions = state.selectedSampleQuestions
        .where((sampleIndex) => sampleIndex != index)
        .map((sampleIndex) {
          if (sampleIndex > index) return sampleIndex - 1;
          return sampleIndex;
        })
        .where(
          (sampleIndex) =>
              sampleIndex >= 0 && sampleIndex < updatedQuestions.length,
        )
        .toList();

    final allowedCount = _calculateAllowedSampleQuestionsCount(
      updatedQuestions.length,
    );

    emit(
      state.copyWith(
        questions: updatedQuestions,
        selectedSampleQuestions: updatedSampleQuestions
            .take(allowedCount)
            .toList(),
      ),
    );
  }

  Future<void> fetchScientificClassifications({
    bool forceRefresh = false,
  }) async {
    if (state.isScientificClassificationsLoading) return;

    if (!forceRefresh && state.scientificClassificationGroups.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(
        isScientificClassificationsLoading: true,
        scientificClassificationsError: null,
      ),
    );

    try {
      final response = await getScientificClassificationsUseCase();

      emit(
        state.copyWith(
          isScientificClassificationsLoading: false,
          scientificClassificationsError: null,
          scientificClassificationGroups: response.groups,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isScientificClassificationsLoading: false,
          scientificClassificationsError: e.toString(),
        ),
      );
    }
  }

  void prepareScientificCategoriesPicker() {
    emit(
      state.copyWith(
        pendingScientificInterestIds: [...state.selectedScientificInterestIds],
      ),
    );
  }

  void togglePendingScientificInterest(int interestId) {
    final selected = [...state.pendingScientificInterestIds];

    if (selected.contains(interestId)) {
      selected.remove(interestId);
    } else {
      if (selected.length >= maxScientificCategoriesCount) return;
      selected.add(interestId);
    }

    emit(state.copyWith(pendingScientificInterestIds: selected));
  }

  void confirmScientificCategories() {
    final selectedIds = [...state.pendingScientificInterestIds]..sort();

    final selectedNames = _getScientificInterestNamesByIds(selectedIds);

    emit(
      state.copyWith(
        selectedScientificInterestIds: selectedIds,
        selectedScientificCategories: selectedNames,
        pendingScientificInterestIds: selectedIds,
      ),
    );
  }

  List<String> _getScientificInterestNamesByIds(List<int> ids) {
    final names = <String>[];

    for (final group in state.scientificClassificationGroups) {
      for (final interest in group.interests) {
        if (ids.contains(interest.id)) {
          names.add(interest.name);
        }
      }
    }

    return names;
  }

  ScientificInterestEntity? getScientificInterestById(int id) {
    for (final group in state.scientificClassificationGroups) {
      for (final interest in group.interests) {
        if (interest.id == id) return interest;
      }
    }

    return null;
  }

  void setSelectedSampleQuestions(List<int> selected) {
    final totalQuestions = state.questions.length;

    if (totalQuestions < minQuestionsCount) {
      emit(state.copyWith(selectedSampleQuestions: const []));
      return;
    }

    final allowedCount = _calculateAllowedSampleQuestionsCount(totalQuestions);

    final normalizedSelected =
        selected
            .where((index) => index >= 0 && index < totalQuestions)
            .toSet()
            .take(allowedCount)
            .toList()
          ..sort();

    emit(state.copyWith(selectedSampleQuestions: normalizedSelected));
  }

  int _calculateAllowedSampleQuestionsCount(int totalQuestions) {
    if (totalQuestions < minQuestionsCount) return 0;

    final count = (totalQuestions * 0.10).ceil();

    if (count < 1) return 1;
    if (count > totalQuestions) return totalQuestions;

    return count;
  }

  Future<void> submitCreateManualTest() async {
    if (state.isCreateManualTestLoading) return;

    final validationError = _validateCreateManualTestBeforeSubmit();

    if (validationError != null) {
      emit(
        state.copyWith(
          createManualTestError: validationError,
          createManualTestResponse: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreateManualTestLoading: true,
        createManualTestError: null,
        createManualTestResponse: null,
      ),
    );

    try {
      final params = _buildCreateManualTestParams();

      final response = await createManualTestUseCase(params: params);

      emit(
        state.copyWith(
          isCreateManualTestLoading: false,
          createManualTestError: null,
          createManualTestResponse: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isCreateManualTestLoading: false,
          createManualTestError: e.toString(),
        ),
      );
    }
  }

  String? _validateCreateManualTestBeforeSubmit() {
    if (state.title.trim().isEmpty) {
      return 'يرجى إدخال عنوان الاختبار';
    }

    if (state.description.trim().isEmpty) {
      return 'يرجى إدخال وصف الاختبار';
    }

    if (!levels.contains(state.level)) {
      return 'مستوى الصعوبة غير صالح';
    }

    final normalizedLanguage = _mapLanguageToBackend(state.language);
    if (!['العربية', 'الإنكليزية', 'مختلطة'].contains(normalizedLanguage)) {
      return 'لغة الاختبار غير صالحة';
    }
    const allowedAcademicLevels = [
      'معلومات عامة',
      'ماجستير',
      'دكتوراه',
      'سنة اولى جامعة',
      'سنة ثانية جامعة',
      'سنة ثالثة جامعة',
      'سنة رابعة جامعة',
      'سنة خامسة جامعة',
      'سنة سادسة جامعة',
      'سنة اولى معهد',
      'سنة ثانية معهد',
      'سنة ثالثة معهد',
      'الصف الأول',
      'الصف الثاني',
      'الصف الثالث',
      'الصف الرابع',
      'الصف الخامس',
      'الصف السادس',
      'الصف السابع',
      'الصف الثامن',
      'الصف التاسع',
      'الصف العاشر',
      'الصف الحادي عشر',
      'البكلوريا',
    ];

    if (!allowedAcademicLevels.contains(state.selectedAcademicLevel.trim())) {
      return 'المستوى الدراسي المختار غير صالح';
    }

    if (state.selectedScientificInterestIds.isEmpty) {
      return 'يرجى اختيار تصنيف علمي واحد على الأقل';
    }

    if (state.selectedScientificInterestIds.length >
        maxScientificCategoriesCount) {
      return 'يمكن اختيار ثلاثة تصنيفات علمية فقط';
    }

    if (state.questions.length < minQuestionsCount) {
      return 'أقل عدد أسئلة مسموح هو $minQuestionsCount';
    }

    if (state.questions.length > maxQuestionsCount) {
      return 'أكبر عدد أسئلة مسموح هو $maxQuestionsCount';
    }

    if (state.durationSeconds != null) {
      if (state.durationSeconds! < minDurationSeconds ||
          state.durationSeconds! > maxDurationSeconds) {
        return 'مدة الاختبار يجب أن تكون بين 10 دقائق و3 ساعات';
      }
    }

    if (state.successLimit != null &&
        !successLimits.contains(state.successLimit)) {
      return 'حد النجاح غير صالح';
    }

    for (
      int questionIndex = 0;
      questionIndex < state.questions.length;
      questionIndex++
    ) {
      final question = state.questions[questionIndex];

      if (question.questionText.trim().isEmpty) {
        return 'السؤال رقم ${questionIndex + 1} لا يحتوي على نص';
      }

      final validOptions = question.options
          .where((option) => option.trim().isNotEmpty)
          .toList();

      if (validOptions.length < minOptionsCount) {
        return 'السؤال رقم ${questionIndex + 1} يجب أن يحتوي على خيارين على الأقل';
      }

      if (validOptions.length > maxOptionsCount) {
        return 'السؤال رقم ${questionIndex + 1} لا يمكن أن يحتوي على أكثر من خمسة خيارات';
      }

      if (question.correctOptionIndex < 0 ||
          question.correctOptionIndex >= question.options.length ||
          question.options[question.correctOptionIndex].trim().isEmpty) {
        return 'يرجى تحديد إجابة صحيحة للسؤال رقم ${questionIndex + 1}';
      }
    }

    if (state.isPublished && !state.hasValidSampleQuestions) {
      return 'يرجى اختيار عينة الأسئلة المطلوبة';
    }

    final testType = state.isPublished ? 'عام' : 'خاص';
    if (!['عام', 'خاص'].contains(testType)) {
      return 'نوع الاختبار غير صالح';
    }

    final parsedPrice = _parseOptionalPrice();
    if (state.isPublished &&
        state.price.trim().isNotEmpty &&
        parsedPrice == null) {
      return 'يرجى إدخال سعر صالح';
    }

    return null;
  }

  CreateManualTestParams _buildCreateManualTestParams() {
    final testType = state.isPublished ? 'عام' : 'خاص';

    return CreateManualTestParams(
      title: state.title.trim(),
      description: state.description.trim(),
      testType: testType,
      difficultyLevel: state.level.trim(),
      durationSeconds: state.durationSeconds,
      passMarkPercentage: state.successLimit,
      language: _mapLanguageToBackend(state.language),
      price: state.isPublished ? _parseOptionalPrice() : null,
      targetLevel: state.selectedAcademicLevel.trim(),
      interestIds: state.selectedScientificInterestIds,
      questions: List.generate(state.questions.length, (index) {
        final question = state.questions[index];

        return CreateManualTestQuestionParams(
          questionText: question.questionText.trim(),
          hintText: question.explanation.trim().isEmpty
              ? null
              : question.explanation.trim(),
          isPreview:
              state.isPublished &&
              state.selectedSampleQuestions.contains(index),
          options: List.generate(question.options.length, (optionIndex) {
            return CreateManualTestOptionParams(
              optionText: question.options[optionIndex].trim(),
              isCorrect: optionIndex == question.correctOptionIndex,
            );
          }).where((option) => option.optionText.isNotEmpty).toList(),
        );
      }),
    );
  }

  String _mapLanguageToBackend(String language) {
    return switch (language.trim()) {
      'عربية' => 'العربية',
      'إنكليزية' => 'الإنكليزية',
      'مختلطة' => 'مختلطة',
      _ => language.trim(),
    };
  }

  num? _parseOptionalPrice() {
    final rawPrice = state.price.trim();

    if (rawPrice.isEmpty) return null;

    return num.tryParse(rawPrice);
  }

  void clearCreateManualTestResult() {
    emit(
      state.copyWith(
        createManualTestError: null,
        createManualTestResponse: null,
      ),
    );
  }

  void initializeFromArgs(CreateTestInitialArgs? args) {
    if (args == null) return;

    final generatedQuestions = args.generatedQuestions
        .map(_mapGeneratedAiQuestionToState)
        .where((question) {
          return question.questionText.trim().isNotEmpty &&
              question.options.length >= minOptionsCount &&
              question.correctOptionIndex >= 0 &&
              question.correctOptionIndex < question.options.length;
        })
        .toList();

    emit(
      state.copyWith(
        creationMode: args.mode,
        aiMediaFiles: args.mediaFiles,
        aiRequestedQuestionCount: args.aiQuestionCount,
        level: args.aiLevel ?? state.level,
        language: args.aiLanguage ?? state.language,
        questions: generatedQuestions.isEmpty
            ? state.questions
            : generatedQuestions,
        selectedSampleQuestions: const [],
        aiProvider: args.aiProvider ?? '',
      ),
    );
  }

  Future<void> startAiQuestionGenerationAndPoll(
    CreateTestInitialArgs args,
  ) async {
    if (state.isAiQuestionGenerationLoading) return;

    final validationError = _validateAiGenerationArgs(args);

    if (validationError != null) {
      emit(
        state.copyWith(
          isAiQuestionGenerationLoading: false,
          aiQuestionGenerationError: validationError,
          isAiQuestionGenerationCompleted: false,
          aiGeneratedQuestions: const [],
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        creationMode: args.mode,
        aiMediaFiles: args.mediaFiles,
        aiRequestedQuestionCount: args.aiQuestionCount,
        level: args.aiLevel ?? state.level,
        language: args.aiLanguage ?? state.language,
        isAiQuestionGenerationLoading: true,
        aiQuestionGenerationError: null,
        aiGenerationRequestId: null,
        isAiQuestionGenerationCompleted: false,
        aiGeneratedQuestions: const [],
      ),
    );

    try {
      final params = AiQuestionGenerationParams(
        sourceType: args.isAiImages ? 'Images' : 'Pdf',
        questionCount: args.aiQuestionCount ?? aiMinQuestionCount,
        difficultyLevel: _mapAiLevelToBackend(args.aiLevel ?? 'سهل'),
        language: _mapAiLanguageToBackend(args.aiLanguage ?? 'عربية'),
        files: args.mediaFiles,
      );

      final startResponse = await startAiQuestionGenerationUseCase(
        params: params,
      );

      final requestId = startResponse.generationRequestId;

      if (requestId <= 0) {
        emit(
          state.copyWith(
            isAiQuestionGenerationLoading: false,
            aiQuestionGenerationError:
                'لم يتم استلام رقم طلب التوليد من الخادم',
            isAiQuestionGenerationCompleted: false,
          ),
        );
        return;
      }

      emit(
  state.copyWith(
    aiGenerationRequestId: requestId,
  ),
);

await Future.delayed(
  const Duration(seconds: aiPollingIntervalSeconds),
);

await _pollAiQuestionGenerationStatus(requestId);
    } catch (e) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isAiQuestionGenerationLoading: false,
          aiQuestionGenerationError: e.toString(),
          isAiQuestionGenerationCompleted: false,
        ),
      );
    }
  }

Future<void> _pollAiQuestionGenerationStatus(int requestId) async {
  int attempt = 0;

  while (!isClosed) {
    attempt++;

    try {
      final response = await getAiQuestionGenerationStatusUseCase(
        generationRequestId: requestId,
      );

      if (isClosed) return;

      final data = response.data;

      print('AI POLLING ATTEMPT: $attempt');
      print('requestId: $requestId');
      print('status: ${data.status}');
      print('failure: ${data.failure}');
      print('questions count: ${data.questions.length}');

      if (data.isCompleted) {
        if (data.questions.isEmpty) {
          emit(
            state.copyWith(
              isAiQuestionGenerationLoading: false,
              aiQuestionGenerationError:
                  'تمت عملية التوليد لكن لم يتم إنشاء أي سؤال',
              isAiQuestionGenerationCompleted: false,
              aiGeneratedQuestions: const [],
              
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            isAiQuestionGenerationLoading: false,
            aiQuestionGenerationError: null,
            isAiQuestionGenerationCompleted: true,
            aiGeneratedQuestions: data.questions,
            aiProvider: data.provider,
          ),
        );
        return;
      }

      if (data.isFailed) {
        emit(
          state.copyWith(
            isAiQuestionGenerationLoading: false,
            aiQuestionGenerationError:
                data.failure?.trim().isNotEmpty == true
                    ? data.failure
                    : 'فشلت عملية توليد الأسئلة',
            isAiQuestionGenerationCompleted: false,
            aiGeneratedQuestions: const [],
          ),
        );
        return;
      }

      await Future.delayed(
        const Duration(seconds: aiPollingIntervalSeconds),
      );
    } catch (e) {
      print('AI POLLING ERROR attempt $attempt: $e');

      if (isClosed) return;

      await Future.delayed(
        const Duration(seconds: aiPollingIntervalSeconds),
      );
    }
  }
}
  String? _validateAiGenerationArgs(CreateTestInitialArgs args) {
    if (!args.isAiMode) {
      return 'طريقة توليد الأسئلة غير صالحة';
    }

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

    if (questionCount == null ||
        questionCount < aiMinQuestionCount ||
        questionCount > aiMaxQuestionCount) {
      return 'عدد الأسئلة يجب أن يكون بين $aiMinQuestionCount و $aiMaxQuestionCount';
    }

    final level = args.aiLevel?.trim() ?? '';

    if (!levels.contains(level)) {
      return 'مستوى الأسئلة غير صالح';
    }

    final language = args.aiLanguage?.trim() ?? '';

    if (!['عربية', 'إنكليزية'].contains(language)) {
      return 'لغة الأسئلة غير صالحة';
    }

    return null;
  }

  String _mapAiLevelToBackend(String value) {
    return switch (value.trim()) {
      'سهل' => 'Easy',
      'متوسط' => 'Medium',
      'صعب' => 'Hard',
      _ => 'Easy',
    };
  }

  String _mapAiLanguageToBackend(String value) {
    return switch (value.trim()) {
      'عربية' => 'Arabic',
      'إنكليزية' => 'English',
      _ => 'Arabic',
    };
  }

  CreateTestQuestionState _mapGeneratedAiQuestionToState(
    GeneratedAiQuestionEntity generatedQuestion,
  ) {
    final validOptions = generatedQuestion.options
        .where((option) => option.optionText.trim().isNotEmpty)
        .toList();

    if (validOptions.isEmpty) {
      return CreateTestQuestionState(
        questionText: generatedQuestion.questionText.trim(),
        options: const [],
        correctOptionIndex: 0,
        explanation: generatedQuestion.hintText?.trim() ?? '',
      );
    }

    final correctOption = validOptions
        .where((option) => option.isCorrect)
        .firstOrNull;

    final limitedOptions = <GeneratedAiQuestionOptionEntity>[];

    if (correctOption != null) {
      limitedOptions.add(correctOption);
    }

    for (final option in validOptions) {
      if (limitedOptions.length >= maxOptionsCount) break;

      if (correctOption != null &&
          option.optionText.trim() == correctOption.optionText.trim()) {
        continue;
      }

      limitedOptions.add(option);
    }

    final correctIndex = limitedOptions.indexWhere(
      (option) => option.isCorrect,
    );

    return CreateTestQuestionState(
      questionText: generatedQuestion.questionText.trim(),
      options: limitedOptions
          .map((option) => option.optionText.trim())
          .toList(),
      correctOptionIndex: correctIndex < 0 ? 0 : correctIndex,
      explanation: generatedQuestion.hintText?.trim() ?? '',
    );
  }

  void clearAiQuestionGenerationResult() {
    emit(
      state.copyWith(
        isAiQuestionGenerationLoading: false,
        aiQuestionGenerationError: null,
        aiGenerationRequestId: null,
        isAiQuestionGenerationCompleted: false,
        aiGeneratedQuestions: const [],
      ),
    );
  }
}

class CreateTestScientificCategoryUiModel {
  final String title;
  final String icon;

  const CreateTestScientificCategoryUiModel({
    required this.title,
    required this.icon,
  });
}
