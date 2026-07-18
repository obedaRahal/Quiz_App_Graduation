import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/create_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_subjects_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/update_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/update_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_state.dart';

class CreateUpdateStudyPlanCubit extends Cubit<CreateUpdateStudyPlanState> {
  final GetStudySubjectsUseCase getStudySubjectsUseCase;
  final CreateStudyPlanUseCase createStudyPlanUseCase;

  final UpdateStudyPlanUseCase updateStudyPlanUseCase;
  final GetStudyPlanDetailsOverviewUseCase getStudyPlanDetailsOverviewUseCase;
  CreateUpdateStudyPlanCubit({
    required this.getStudySubjectsUseCase,
    required this.createStudyPlanUseCase,

    required this.updateStudyPlanUseCase,
    required this.getStudyPlanDetailsOverviewUseCase,
  }) : super(const CreateUpdateStudyPlanState()) {
    debugPrint('============ CreateUpdateStudyPlanCubit INIT ============');
  }

  // =========================================================
  // INITIALIZE CREATE
  // =========================================================

  Future<void> initializeCreate() async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.initializeCreate ============',
    );

    emit(
      const CreateUpdateStudyPlanState(
        mode: StudyPlanFormMode.create,
        isDefault: false,
      ),
    );

    debugPrint('→ mode: create');
    debugPrint('→ isDefault: true');
    debugPrint('→ loading available subjects');

    await getAvailableSubjects();

    debugPrint(
      '=====================================================================',
    );
  }

  ///////////// initialize  update
  Future<void> initializeUpdate(StudyPlanSummaryEntity plan) async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.initializeUpdate ============',
    );
    debugPrint('→ planId: ${plan.id}');
    debugPrint('→ title: ${plan.title}');
    debugPrint('→ emoji: ${plan.emoji}');

    debugPrint('→ startDate display: ${plan.startDate}');
    debugPrint('→ endDate display: ${plan.endDate}');

    debugPrint('→ startDateLabel raw: ${plan.startDateLabel}');
    debugPrint('→ endDateLabel raw: ${plan.endDateLabel}');

    debugPrint('→ dailyStudyHours: ${plan.dailyStudyHours}');
    debugPrint('→ isDefault: ${plan.isDefault}');

    if (plan.id <= 0) {
      debugPrint('✗ initializeUpdate invalid plan id');

      emit(
        CreateUpdateStudyPlanState(
          mode: StudyPlanFormMode.update,
          planId: plan.id,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      return;
    }

    final parsedStartDate = _parseApiDate(plan.startDateLabel);

    final parsedEndDate = _parseApiDate(plan.endDateLabel);

    debugPrint('→ parsedStartDate: $parsedStartDate');
    debugPrint('→ parsedEndDate: $parsedEndDate');

    if (parsedStartDate == null || parsedEndDate == null) {
      debugPrint('✗ initializeUpdate invalid plan dates');
      debugPrint('→ startDateLabel: ${plan.startDateLabel}');
      debugPrint('→ endDateLabel: ${plan.endDateLabel}');

      emit(
        CreateUpdateStudyPlanState(
          mode: StudyPlanFormMode.update,
          planId: plan.id,
          title: plan.title,
          emoji: plan.emoji,
          dailyStudyHours: plan.dailyStudyHours,
          isDefault: plan.isDefault,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'تعذر قراءة تواريخ الخطة الدراسية',
          isFormInitialized: false,
        ),
      );

      return;
    }

    emit(
      CreateUpdateStudyPlanState(
        mode: StudyPlanFormMode.update,
        planId: plan.id,
        title: plan.title,
        emoji: plan.emoji,
        startDate: parsedStartDate,
        endDate: parsedEndDate,
        dailyStudyHours: plan.dailyStudyHours,
        isDefault: plan.isDefault,
        isFormInitialized: false,
      ),
    );

    debugPrint('✓ basic update values emitted');
    debugPrint('→ state.title: ${state.title}');
    debugPrint('→ state.emoji: ${state.emoji}');
    debugPrint('→ state.startDate: ${state.startDate}');
    debugPrint('→ state.endDate: ${state.endDate}');
    debugPrint('→ state.dailyStudyHours: ${state.dailyStudyHours}');
    debugPrint('→ state.isDefault: ${state.isDefault}');

    await getAvailableSubjects();

    debugPrint(
      '→ subjects request completed with status: ${state.subjectsStatus}',
    );

    if (!state.isSubjectsSuccess) {
      debugPrint(
        '✗ initializeUpdate stopped: available subjects request failed',
      );
      return;
    }

    await _loadOverviewForUpdate(plan.id);
  }

  DateTime? _parseApiDate(String value) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      debugPrint('✗ _parseApiDate received empty value');
      return null;
    }

    final parsedDate = DateTime.tryParse(normalized);

    if (parsedDate == null) {
      debugPrint('✗ _parseApiDate failed');
      debugPrint('→ raw value: $value');
      return null;
    }

    final localDate = parsedDate.isUtc ? parsedDate.toLocal() : parsedDate;

    final normalizedDate = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    debugPrint('✓ _parseApiDate');
    debugPrint('→ raw: $value');
    debugPrint('→ parsed: $parsedDate');
    debugPrint('→ local: $localDate');
    debugPrint('→ normalized: $normalizedDate');

    return normalizedDate;
  }

  Future<void> _loadOverviewForUpdate(int planId) async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit._loadOverviewForUpdate ============',
    );
    debugPrint('→ planId: $planId');

    final params = GetStudyPlanDetailsOverviewParams(planId: planId);

    try {
      final result = await getStudyPlanDetailsOverviewUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ overview loading failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              errorTitle: failure.title,
              errorMessage: failure.message,
              isFormInitialized: false,
            ),
          );
        },
        (response) {
          debugPrint('✓ overview loaded');

          final overviewSubjectIds = response.subjects.items
              .map((subject) => subject.id)
              .toSet();

          final availableSubjectIds = state.availableSubjects
              .map((subject) => subject.id)
              .toSet();

          final validSelectedIds = overviewSubjectIds
              .where(availableSubjectIds.contains)
              .take(CreateUpdateStudyPlanState.maxSelectedSubjects)
              .toSet();

          debugPrint('→ overview subject ids: $overviewSubjectIds');
          debugPrint('→ available subject ids: $availableSubjectIds');
          debugPrint('→ valid selected ids: $validSelectedIds');

          _completeUpdateInitialization(selectedSubjectIds: validSelectedIds);
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ overview unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب تفاصيل الخطة الدراسية',
          isFormInitialized: false,
        ),
      );
    } finally {
      debugPrint(
        '============================================================================',
      );
    }
  }

  void _completeUpdateInitialization({required Set<int> selectedSubjectIds}) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit._completeUpdateInitialization ============',
    );

    final originalSelectedIds = Set<int>.unmodifiable(selectedSubjectIds);

    emit(
      state.copyWith(
        selectedSubjectIds: originalSelectedIds,

        initialTitle: state.title,
        initialEmoji: state.emoji,
        initialStartDate: state.startDate,
        initialEndDate: state.endDate,
        initialSelectedSubjectIds: originalSelectedIds,
        initialDailyStudyHours: state.dailyStudyHours,
        initialIsDefault: state.isDefault,

        isFormInitialized: true,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    debugPrint('✓ update form initialized');
    debugPrint('→ initialTitle: ${state.initialTitle}');
    debugPrint('→ initialEmoji: ${state.initialEmoji}');
    debugPrint('→ initialStartDate: ${state.initialStartDate}');
    debugPrint('→ initialEndDate: ${state.initialEndDate}');
    debugPrint(
      '→ initialSelectedSubjectIds: '
      '${state.initialSelectedSubjectIds}',
    );
    debugPrint(
      '→ initialDailyStudyHours: '
      '${state.initialDailyStudyHours}',
    );
    debugPrint('→ initialIsDefault: ${state.initialIsDefault}');
    debugPrint('→ hasChanges: ${state.hasChanges}');
  }

  // =========================================================
  // GET AVAILABLE SUBJECTS
  // =========================================================

  Future<void> getAvailableSubjects() async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.getAvailableSubjects ============',
    );

    if (state.isSubjectsLoading) {
      debugPrint('✗ getAvailableSubjects ignored: request already loading');
      debugPrint(
        '=========================================================================',
      );
      return;
    }

    emit(
      state.copyWith(
        subjectsStatus: CreateUpdateStudyPlanSubjectsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final result = await getStudySubjectsUseCase();

      result.fold(
        (failure) {
          debugPrint('✗ getAvailableSubjects failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              subjectsStatus: CreateUpdateStudyPlanSubjectsStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ getAvailableSubjects success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ subjects count: ${response.subjects.length}');

          for (final subject in response.subjects) {
            debugPrint('→ subject: id=${subject.id}, name=${subject.name}');
          }

          final availableIds = response.subjects
              .map((subject) => subject.id)
              .toSet();

          final validSelectedIds = state.selectedSubjectIds
              .where(availableIds.contains)
              .take(CreateUpdateStudyPlanState.maxSelectedSubjects)
              .toSet();

          emit(
            state.copyWith(
              subjectsStatus: CreateUpdateStudyPlanSubjectsStatus.success,
              availableSubjects: List<StudySubjectEntity>.unmodifiable(
                response.subjects,
              ),
              selectedSubjectIds: validSelectedIds,
              clearError: true,
            ),
          );

          debugPrint('→ valid selected ids: $validSelectedIds');
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ getAvailableSubjects unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          subjectsStatus: CreateUpdateStudyPlanSubjectsStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب المواد الدراسية',
        ),
      );
    } finally {
      debugPrint(
        '=========================================================================',
      );
    }
  }

  // =========================================================
  // TITLE
  // =========================================================

  void changeTitle(String value) {
    if (value.length > CreateUpdateStudyPlanState.titleMaxLength) {
      debugPrint('✗ changeTitle ignored: maximum length exceeded');
      debugPrint('→ length: ${value.length}');
      return;
    }

    emit(
      state.copyWith(
        title: value,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // EMOJI
  // =========================================================

  void changeEmoji(String value) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeEmoji ============',
    );
    debugPrint('→ emoji: $value');

    emit(
      state.copyWith(
        emoji: value,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // DATES
  // =========================================================

  void changeStartDate(DateTime value) {
    final normalizedDate = DateTime(value.year, value.month, value.day);

    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeStartDate ============',
    );
    debugPrint('→ startDate: $normalizedDate');

    DateTime? resolvedEndDate = state.endDate;

    if (resolvedEndDate != null && resolvedEndDate.isBefore(normalizedDate)) {
      debugPrint('→ current endDate is before new startDate, clearing endDate');

      resolvedEndDate = null;
    }

    emit(
      state.copyWith(
        startDate: normalizedDate,
        endDate: resolvedEndDate,
        clearEndDate: resolvedEndDate == null,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeEndDate(DateTime value) {
    final normalizedDate = DateTime(value.year, value.month, value.day);

    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeEndDate ============',
    );
    debugPrint('→ endDate: $normalizedDate');

    if (state.startDate != null && normalizedDate.isBefore(state.startDate!)) {
      debugPrint('✗ endDate validation: date is before startDate');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يجب أن يكون تاريخ نهاية الخطة بعد تاريخ البداية',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        endDate: normalizedDate,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearStartDate() {
    emit(
      state.copyWith(
        clearStartDate: true,
        clearEndDate: true,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void clearEndDate() {
    emit(
      state.copyWith(
        clearEndDate: true,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // SELECTED SUBJECTS
  // =========================================================

  void changeSelectedSubjects(Iterable<int> subjectIds) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeSelectedSubjects ============',
    );
    debugPrint('→ received subject ids: ${subjectIds.toList()}');

    final availableIds = state.availableSubjects
        .map((subject) => subject.id)
        .toSet();

    final validIds = <int>{};

    for (final id in subjectIds) {
      if (!availableIds.contains(id)) {
        debugPrint('→ ignored unavailable subject id: $id');
        continue;
      }

      if (validIds.length >= CreateUpdateStudyPlanState.maxSelectedSubjects) {
        break;
      }

      validIds.add(id);
    }

    debugPrint('→ valid selected ids: $validIds');
    debugPrint('→ selected count: ${validIds.length}');

    emit(
      state.copyWith(
        selectedSubjectIds: validIds,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    debugPrint(
      '============================================================================',
    );
  }

  void toggleSubject(int subjectId) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.toggleSubject ============',
    );
    debugPrint('→ subjectId: $subjectId');

    final subjectExists = state.availableSubjects.any(
      (subject) => subject.id == subjectId,
    );

    if (!subjectExists) {
      debugPrint('✗ toggleSubject ignored: subject is not available');
      debugPrint(
        '=================================================================',
      );
      return;
    }

    final updatedIds = {...state.selectedSubjectIds};

    if (updatedIds.contains(subjectId)) {
      updatedIds.remove(subjectId);

      debugPrint('✓ subject deselected');
    } else {
      if (updatedIds.length >= CreateUpdateStudyPlanState.maxSelectedSubjects) {
        debugPrint('✗ maximum subjects limit reached');

        emit(
          state.copyWith(
            errorTitle: 'تنبيه',
            errorMessage: 'يمكنك اختيار 10 مواد على الأكثر',
          ),
        );

        debugPrint(
          '=================================================================',
        );
        return;
      }

      updatedIds.add(subjectId);

      debugPrint('✓ subject selected');
    }

    debugPrint('→ selected count: ${updatedIds.length}');
    debugPrint('→ selected ids: $updatedIds');

    emit(
      state.copyWith(
        selectedSubjectIds: updatedIds,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearError: true,
      ),
    );

    debugPrint(
      '=================================================================',
    );
  }

  void clearSelectedSubjects() {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.clearSelectedSubjects ============',
    );

    emit(
      state.copyWith(
        selectedSubjectIds: const {},
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // DAILY STUDY TIME
  // =========================================================

  void changeDailyStudyHours(int hours) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeDailyStudyHours ============',
    );
    debugPrint('→ hours: $hours');

    if (hours < 1 || hours > 10) {
      debugPrint('✗ invalid daily study hours: value must be between 1 and 10');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage:
              'يجب أن تكون ساعات الدراسة اليومية من ساعة إلى 10 ساعات',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        dailyStudyHours: hours,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    debugPrint('✓ daily study hours updated: $hours');
    debugPrint(
      '=========================================================================',
    );
  }

  // =========================================================
  // DEFAULT PLAN
  // =========================================================

  void changeDefaultStatus(bool value) {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.changeDefaultStatus ============',
    );
    debugPrint('→ isDefault: $value');

    emit(
      state.copyWith(
        isDefault: value,
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // VALIDATION
  // =========================================================

  bool validateBeforeSubmit() {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.validateBeforeSubmit ============',
    );

    if (state.isUpdateMode && !state.isFormInitialized) {
      debugPrint('✗ update form is not initialized');

      emit(
        state.copyWith(
          errorTitle: 'يرجى الانتظار',
          errorMessage: 'لم يكتمل تحميل بيانات الخطة بعد',
        ),
      );

      return false;
    }

    if (!state.hasValidTitle) {
      debugPrint('✗ invalid title');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال عنوان الخطة الدراسية',
        ),
      );

      return false;
    }

    if (!state.hasValidEmoji) {
      debugPrint('✗ invalid emoji');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار رمز تعبيري للخطة',
        ),
      );

      return false;
    }

    if (state.startDate == null) {
      debugPrint('✗ start date is null');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار تاريخ بداية الخطة',
        ),
      );

      return false;
    }

    if (state.endDate == null) {
      debugPrint('✗ end date is null');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار تاريخ نهاية الخطة',
        ),
      );

      return false;
    }

    if (!state.hasValidDates) {
      debugPrint('✗ invalid dates range');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'تاريخ نهاية الخطة غير صالح',
        ),
      );

      return false;
    }

    if (!state.hasSelectedSubjects) {
      debugPrint('✗ no selected subjects');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار مادة واحدة على الأقل',
        ),
      );

      return false;
    }

    if (!state.hasValidDailyStudyTime) {
      debugPrint('✗ invalid daily study time');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى تحديد وقت الدراسة اليومي',
        ),
      );

      return false;
    }

    debugPrint('✓ study plan form is valid');
    debugPrint('→ title: ${state.title.trim()}');
    debugPrint('→ emoji: ${state.emoji}');
    debugPrint('→ startDate: ${state.startDate}');
    debugPrint('→ endDate: ${state.endDate}');
    debugPrint('→ subjectIds: ${state.selectedSubjectIdsList}');
    debugPrint('→ dailyStudyHours: ${state.dailyStudyHours}');
    debugPrint('→ isDefault: ${state.isDefault}');
    debugPrint(
      '=======================================================================',
    );

    return true;
  }

  // =========================================================
  // RESET
  // =========================================================

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  void resetSubmitState() {
    emit(
      state.copyWith(
        submitStatus: CreateUpdateStudyPlanSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  ///////////////////// create API ////////////
  Future<void> createStudyPlan() async {
    if (!state.isCreateMode) {
      debugPrint('✗ createStudyPlan ignored: state is not create mode');
      return;
    }

    debugPrint(
      '============ CreateUpdateStudyPlanCubit.createStudyPlan ============',
    );

    if (state.isSubmitLoading) {
      debugPrint('X createStudyPlan ignored: request already loading');
      debugPrint(
        '==================================================================',
      );
      return;
    }

    final isValid = validateBeforeSubmit();

    debugPrint('→ isValid: $isValid');

    if (!isValid) {
      debugPrint('X createStudyPlan stopped: form validation failed');
      debugPrint(
        '==================================================================',
      );
      return;
    }

    final params = CreateStudyPlanParams(
      title: state.title.trim(),
      emoji: state.emoji.trim(),
      startDate: state.startDate!,
      endDate: state.endDate!,
      subjectIds: state.selectedSubjectIdsList,
      dailyStudyHours: state.dailyStudyHours,
      isDefault: state.isDefault,
    );

    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toBody()}');

    emit(
      state.copyWith(
        submitStatus: CreateUpdateStudyPlanSubmitStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await createStudyPlanUseCase(params);

      result.fold(
        (failure) {
          debugPrint('X CreateUpdateStudyPlanCubit.createStudyPlan failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              submitStatus: CreateUpdateStudyPlanSubmitStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('√ CreateUpdateStudyPlanCubit.createStudyPlan success');
          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ statusCode: ${response.statusCode}');

          emit(
            state.copyWith(
              submitStatus: CreateUpdateStudyPlanSubmitStatus.success,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        'X CreateUpdateStudyPlanCubit.createStudyPlan unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          submitStatus: CreateUpdateStudyPlanSubmitStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر إنشاء الخطة الدراسية',
        ),
      );
    } finally {
      debugPrint(
        '==================================================================',
      );
    }
  }

  /////////////// update ////////////////////
  /////////////// update ////////////////////
  /////////////// update ////////////////////
  /////////////// update ////////////////////
  /////////////// update ////////////////////
  Future<void> submitStudyPlan() async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.submitStudyPlan ============',
    );
    debugPrint('→ mode: ${state.mode}');
    debugPrint('→ planId: ${state.planId}');
    debugPrint('→ isFormInitialized: ${state.isFormInitialized}');
    debugPrint('→ hasChanges: ${state.hasChanges}');
    debugPrint('→ canSubmit: ${state.canSubmit}');

    if (state.isSubmitLoading) {
      debugPrint('✗ submit ignored: request already loading');
      debugPrint(
        '===================================================================',
      );
      return;
    }

    if (state.isUpdateMode) {
      await updateStudyPlan();
      return;
    }

    await createStudyPlan();
  }

  Future<void> updateStudyPlan() async {
    debugPrint(
      '============ CreateUpdateStudyPlanCubit.updateStudyPlan ============',
    );

    if (state.isSubmitLoading) {
      debugPrint('✗ update ignored: request already loading');
      debugPrint(
        '==================================================================',
      );
      return;
    }

    if (!state.isUpdateMode) {
      debugPrint('✗ update ignored: state is not update mode');
      debugPrint(
        '==================================================================',
      );
      return;
    }

    if (!state.isFormInitialized) {
      debugPrint('✗ update ignored: form is not initialized');

      emit(
        state.copyWith(
          errorTitle: 'يرجى الانتظار',
          errorMessage: 'لم يكتمل تحميل بيانات الخطة بعد',
        ),
      );

      return;
    }

    if (!state.hasChanges) {
      debugPrint('✗ update ignored: no changes detected');

      emit(
        state.copyWith(
          errorTitle: 'لا توجد تعديلات',
          errorMessage: 'قم بتعديل حقل واحد على الأقل قبل الحفظ',
        ),
      );

      return;
    }

    final planId = state.planId;

    if (planId == null || planId <= 0) {
      debugPrint('✗ update failed: invalid planId');

      emit(
        state.copyWith(
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      return;
    }

    final isValid = validateBeforeSubmit();

    debugPrint('→ isValid: $isValid');

    if (!isValid) {
      debugPrint('✗ update stopped: form validation failed');
      debugPrint(
        '==================================================================',
      );
      return;
    }

    final params = UpdateStudyPlanParams(
      planId: planId,

      title: state.title.trim() != state.initialTitle.trim()
          ? state.title.trim()
          : null,

      emoji: state.emoji.trim() != state.initialEmoji.trim()
          ? state.emoji.trim()
          : null,

      startDate: !state.isSameDate(state.startDate, state.initialStartDate)
          ? state.startDate
          : null,

      endDate: !state.isSameDate(state.endDate, state.initialEndDate)
          ? state.endDate
          : null,

      subjectIds:
          !state.isSameIdSet(
            state.selectedSubjectIds,
            state.initialSelectedSubjectIds,
          )
          ? state.selectedSubjectIdsList
          : null,

      dailyStudyHours: state.dailyStudyHours != state.initialDailyStudyHours
          ? state.dailyStudyHours
          : null,

      isDefault: state.isDefault != state.initialIsDefault
          ? state.isDefault
          : null,
    );

    debugPrint('→ params: $params');
    // debugPrint('→ body: ${params.toBody()}');
    final body = params.toBody();
    debugPrint('→ changed fields body: $body');
    if (body.isEmpty) {
      debugPrint('✗ update stopped: body is empty');

      emit(
        state.copyWith(
          errorTitle: 'لا توجد تعديلات',
          errorMessage: 'قم بتعديل حقل واحد على الأقل قبل الحفظ',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        submitStatus: CreateUpdateStudyPlanSubmitStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await updateStudyPlanUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ updateStudyPlan failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              submitStatus: CreateUpdateStudyPlanSubmitStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ updateStudyPlan success');
          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ statusCode: ${response.statusCode}');

          emit(
            state.copyWith(
              submitStatus: CreateUpdateStudyPlanSubmitStatus.success,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ updateStudyPlan unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          submitStatus: CreateUpdateStudyPlanSubmitStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر تعديل الخطة الدراسية',
        ),
      );
    } finally {
      debugPrint(
        '==================================================================',
      );
    }
  }
}
