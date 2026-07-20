import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/create_study_task_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_plan_subjects_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

class CreateStudyTaskCubit extends Cubit<CreateStudyTaskState> {
  final GetStudyPlanSubjectsUseCase getStudyPlanSubjectsUseCase;

  final CreateStudyTaskUseCase createStudyTaskUseCase;

  CreateStudyTaskCubit({
    required this.getStudyPlanSubjectsUseCase,
    required this.createStudyTaskUseCase,
  }) : super(const CreateStudyTaskState()) {
    debugPrint('============ CreateStudyTaskCubit INIT ============');
  }

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> initialize({required int planId}) async {
    debugPrint('============ CreateStudyTaskCubit.initialize ============');
    debugPrint('→ planId: $planId');

    if (planId <= 0) {
      debugPrint('✗ invalid plan id');

      emit(
        CreateStudyTaskState(
          planId: planId,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      debugPrint('=========================================================');

      return;
    }

    emit(
      CreateStudyTaskState(
        planId: planId,
        subtasks: const [''],
        repeatPattern: StudyTaskRepeatPattern.none,
      ),
    );

    debugPrint('✓ create study task state initialized');
    debugPrint('→ loading subjects related to plan');

    await getStudyPlanSubjects();

    debugPrint('=========================================================');
  }

  // =========================================================
  // GET STUDY PLAN SUBJECTS
  // =========================================================

  Future<void> getStudyPlanSubjects() async {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.getStudyPlanSubjects '
      '============',
    );
    debugPrint('→ planId: ${state.planId}');

    if (state.isSubjectsLoading) {
      debugPrint('✗ request ignored: subjects are already loading');
      debugPrint('===========================================================');

      return;
    }

    if (!state.hasValidPlanId) {
      debugPrint('✗ invalid plan id');

      emit(
        state.copyWith(
          subjectsStatus: CreateStudyTaskSubjectsStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      debugPrint('===========================================================');

      return;
    }

    emit(
      state.copyWith(
        subjectsStatus: CreateStudyTaskSubjectsStatus.loading,
        availableSubjects: const [],
        clearSelectedStudyPlanSubjectId: true,
        clearError: true,
      ),
    );

    try {
      final result = await getStudyPlanSubjectsUseCase(planId: state.planId);

      result.fold(
        (failure) {
          debugPrint('✗ getStudyPlanSubjects failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              subjectsStatus: CreateStudyTaskSubjectsStatus.failure,
              availableSubjects: const [],
              clearSelectedStudyPlanSubjectId: true,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ getStudyPlanSubjects success');
          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ subjects count: ${response.subjects.length}');
          debugPrint('→ statusCode: ${response.statusCode}');

          final subjects = List<StudyPlanSubjectEntity>.unmodifiable(
            response.subjects,
          );

          for (final subject in subjects) {
            debugPrint(
              '→ subject: '
              'id=${subject.id}, '
              'name=${subject.name}',
            );
          }

          emit(
            state.copyWith(
              subjectsStatus: CreateStudyTaskSubjectsStatus.success,
              availableSubjects: subjects,
              clearSelectedStudyPlanSubjectId: true,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ getStudyPlanSubjects unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          subjectsStatus: CreateStudyTaskSubjectsStatus.failure,
          availableSubjects: const [],
          clearSelectedStudyPlanSubjectId: true,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب مواد الخطة الدراسية',
        ),
      );
    } finally {
      debugPrint('===========================================================');
    }
  }

  Future<void> retryGetStudyPlanSubjects() async {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.retryGetStudyPlanSubjects '
      '============',
    );

    await getStudyPlanSubjects();
  }

  // =========================================================
  // SELECT SUBJECT
  // =========================================================

  void changeSelectedSubject(int studyPlanSubjectId) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeSelectedSubject '
      '============',
    );
    debugPrint('→ studyPlanSubjectId: $studyPlanSubjectId');

    final subjectExists = state.availableSubjects.any(
      (subject) => subject.id == studyPlanSubjectId,
    );

    if (!subjectExists) {
      debugPrint(
        '✗ subject selection ignored: '
        'subject does not belong to this plan',
      );
      debugPrint('===========================================================');

      return;
    }

    emit(
      state.copyWith(
        selectedStudyPlanSubjectId: studyPlanSubjectId,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    debugPrint('✓ selected subject updated');
    debugPrint('→ selected subject: ${state.selectedSubject}');
    debugPrint('===========================================================');
  }

  void clearSelectedSubject() {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.clearSelectedSubject '
      '============',
    );

    emit(
      state.copyWith(
        clearSelectedStudyPlanSubjectId: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // TITLE AND DESCRIPTION
  // =========================================================

  void changeTitle(String value) {
    if (value.length > CreateStudyTaskState.titleMaxLength) {
      debugPrint('✗ title change ignored: maximum length exceeded');

      return;
    }

    emit(
      state.copyWith(
        title: value,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeDescription(String value) {
    if (value.length > CreateStudyTaskState.descriptionMaxLength) {
      debugPrint(
        '✗ description change ignored: '
        'maximum length exceeded',
      );

      return;
    }

    emit(
      state.copyWith(
        description: value,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // DATES
  // =========================================================

  void changeStartDate(DateTime value) {
    final normalizedDate = _normalizeDate(value);
    final today = _normalizeDate(DateTime.now());

    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeStartDate '
      '============',
    );
    debugPrint('→ startDate: $normalizedDate');

    if (normalizedDate.isBefore(today)) {
      debugPrint('✗ start date is before today');

      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage:
              'تاريخ بداية المهمة يجب أن يكون اليوم أو تاريخًا مستقبليًا',
        ),
      );

      return;
    }

    final currentEndDate = state.endDate;

    if (currentEndDate != null) {
      final normalizedEndDate = _normalizeDate(currentEndDate);

      final shouldClearEndDate =
          normalizedEndDate.isBefore(normalizedDate) ||
          !_isDateRangeWithinLimit(
            startDate: normalizedDate,
            endDate: normalizedEndDate,
          );

      if (shouldClearEndDate) {
        emit(
          state.copyWith(
            startDate: normalizedDate,
            clearEndDate: true,
            submitStatus: CreateStudyTaskSubmitStatus.initial,
            clearActionMessage: true,
            clearError: true,
          ),
        );

        debugPrint(
          '→ endDate cleared because it is incompatible '
          'with the new startDate',
        );

        return;
      }
    }

    emit(
      state.copyWith(
        startDate: normalizedDate,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
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
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeEndDate(DateTime value) {
    final normalizedDate = _normalizeDate(value);

    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeEndDate '
      '============',
    );
    debugPrint('→ endDate: $normalizedDate');

    final startDate = state.startDate;

    if (startDate == null) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار تاريخ بداية المهمة أولًا',
        ),
      );

      debugPrint('✗ start date is null');

      return;
    }

    final normalizedStartDate = _normalizeDate(startDate);

    if (normalizedDate.isBefore(normalizedStartDate)) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يجب ألا يسبق تاريخ النهاية تاريخ البداية',
        ),
      );

      debugPrint('✗ end date is before start date');

      return;
    }

    if (!_isDateRangeWithinLimit(
      startDate: normalizedStartDate,
      endDate: normalizedDate,
    )) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'لا يمكن أن تمتد المهمة لأكثر من 7 أيام',
        ),
      );

      debugPrint('✗ task range exceeds seven days');

      return;
    }

    emit(
      state.copyWith(
        endDate: normalizedDate,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearEndDate() {
    emit(
      state.copyWith(
        clearEndDate: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // START TIME
  // =========================================================

  void changeStartTime(String value) {
    final normalizedValue = value.trim();

    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeStartTime '
      '============',
    );
    debugPrint('→ value: $normalizedValue');

    emit(
      state.copyWith(
        startTime: normalizedValue,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeStartTimeFromParts({required int hour, required int minute}) {
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      debugPrint('✗ invalid time parts');

      return;
    }

    final formattedHour = hour.toString().padLeft(2, '0');

    final formattedMinute = minute.toString().padLeft(2, '0');

    changeStartTime('$formattedHour:$formattedMinute');
  }

  void clearStartTime() {
    emit(
      state.copyWith(
        startTime: '',
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // DURATION
  // =========================================================

  void changeDurationMinutes(int minutes) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeDurationMinutes '
      '============',
    );
    debugPrint('→ minutes: $minutes');

    if (minutes < CreateStudyTaskState.minDurationMinutes ||
        minutes > CreateStudyTaskState.maxDurationMinutes) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'مدة المهمة يجب أن تكون بين 10 دقائق و12 ساعة',
        ),
      );

      debugPrint('✗ invalid duration');

      return;
    }

    emit(
      state.copyWith(
        durationMinutes: minutes,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearDuration() {
    emit(
      state.copyWith(
        clearDuration: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // PRIORITY
  // =========================================================

  void changePriority(StudyTaskPriority value) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changePriority '
      '============',
    );
    debugPrint('→ priority: ${value.apiValue}');

    emit(
      state.copyWith(
        priority: value,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearPriority() {
    emit(
      state.copyWith(
        clearPriority: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // REPEAT
  // =========================================================

  void changeRepeatPattern(StudyTaskRepeatPattern value) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeRepeatPattern '
      '============',
    );
    debugPrint('→ repeatPattern: ${value.apiValue}');

    emit(
      state.copyWith(
        repeatPattern: value,
        clearRepeatWeekday: value == StudyTaskRepeatPattern.none,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeRepeatWeekday(int weekday) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeRepeatWeekday '
      '============',
    );
    debugPrint('→ weekday: $weekday');

    if (!state.isRepeating) {
      debugPrint('✗ weekday ignored: task is not repeating');

      return;
    }

    if (weekday < 0 || weekday > 6) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يوم التكرار المحدد غير صالح',
        ),
      );

      debugPrint('✗ invalid repeat weekday');

      return;
    }

    emit(
      state.copyWith(
        repeatWeekday: weekday,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearRepeatWeekday() {
    emit(
      state.copyWith(
        clearRepeatWeekday: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // REMINDER
  // =========================================================

  void changeReminderOffsetMinutes(int? minutes) {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.changeReminderOffsetMinutes '
      '============',
    );
    debugPrint('→ minutes: $minutes');

    if (minutes != null &&
        !CreateStudyTaskState.allowedReminderOffsetMinutes.contains(minutes)) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'وقت التذكير المحدد غير صالح',
        ),
      );

      debugPrint('✗ invalid reminder offset');

      return;
    }

    emit(
      state.copyWith(
        reminderOffsetMinutes: minutes,
        clearReminder: minutes == null,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearReminder() {
    emit(
      state.copyWith(
        clearReminder: true,
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // SUBTASKS
  // =========================================================

  void addSubtask() {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.addSubtask '
      '============',
    );

    if (!state.canAddSubtask) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'يمكنك إضافة 20 مهمة فرعية كحد أقصى',
        ),
      );

      return;
    }

    final updatedSubtasks = List<String>.from(state.subtasks)..add('');

    emit(
      state.copyWith(
        subtasks: List<String>.unmodifiable(updatedSubtasks),
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void changeSubtaskTitle({required int index, required String value}) {
    if (index < 0 || index >= state.subtasks.length) {
      debugPrint('✗ invalid subtask index');

      return;
    }

    if (value.length > CreateStudyTaskState.subtaskTitleMaxLength) {
      emit(
        state.copyWith(
          errorTitle: 'تنبيه',
          errorMessage: 'عنوان المهمة الفرعية طويل جدًا',
        ),
      );

      return;
    }

    final updatedSubtasks = List<String>.from(state.subtasks);

    updatedSubtasks[index] = value;

    emit(
      state.copyWith(
        subtasks: List<String>.unmodifiable(updatedSubtasks),
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void removeSubtask(int index) {
    if (index < 0 || index >= state.subtasks.length) {
      debugPrint('✗ invalid subtask index');

      return;
    }

    if (!state.canRemoveSubtask) {
      emit(
        state.copyWith(
          subtasks: const [''],
          submitStatus: CreateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    final updatedSubtasks = List<String>.from(state.subtasks)..removeAt(index);

    emit(
      state.copyWith(
        subtasks: List<String>.unmodifiable(updatedSubtasks),
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void clearSubtasks() {
    emit(
      state.copyWith(
        subtasks: const [''],
        submitStatus: CreateStudyTaskSubmitStatus.initial,
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
      '============ '
      'CreateStudyTaskCubit.validateBeforeSubmit '
      '============',
    );

    if (!state.hasValidPlanId) {
      return _emitValidationError('معرّف الخطة الدراسية غير صالح');
    }

    if (!state.hasValidTitle) {
      return _emitValidationError('يرجى إدخال عنوان صحيح للمهمة');
    }

    if (!state.hasValidDescription) {
      return _emitValidationError('يرجى إدخال وصف صحيح للمهمة');
    }

    if (state.isSubjectsInitial || state.isSubjectsLoading) {
      return _emitValidationError('يرجى الانتظار حتى يتم تحميل مواد الخطة');
    }

    if (state.isSubjectsFailure) {
      return _emitValidationError(
        'تعذر تحميل مواد الخطة، يرجى المحاولة مجددًا',
      );
    }

    if (!state.isSubjectsSuccess) {
      return _emitValidationError('لم تكتمل عملية تحميل مواد الخطة');
    }

    if (!state.hasAvailableSubjects) {
      return _emitValidationError('لا توجد مواد مرتبطة بهذه الخطة');
    }

    if (!state.hasSelectedSubject) {
      return _emitValidationError('يرجى اختيار مادة من مواد الخطة');
    }

    if (!state.hasStartDate) {
      return _emitValidationError('يرجى اختيار تاريخ بداية المهمة');
    }

    if (!state.isStartDateTodayOrFuture) {
      return _emitValidationError(
        'تاريخ بداية المهمة يجب أن يكون اليوم أو تاريخًا مستقبليًا',
      );
    }

    if (!state.hasEndDate) {
      return _emitValidationError('يرجى اختيار تاريخ نهاية المهمة');
    }

    if (!state.isEndDateAfterOrEqualStartDate) {
      return _emitValidationError('يجب ألا يسبق تاريخ النهاية تاريخ البداية');
    }

    if (!state.isTaskRangeWithinLimit) {
      return _emitValidationError('لا يمكن أن تمتد المهمة لأكثر من 7 أيام');
    }

    if (!state.hasValidStartTime) {
      return _emitValidationError('يرجى اختيار وقت بداية صحيح للمهمة');
    }

    if (!state.hasValidDuration) {
      return _emitValidationError(
        'مدة المهمة يجب أن تكون بين 10 دقائق و12 ساعة',
      );
    }

    if (!state.hasValidPriority) {
      return _emitValidationError('يرجى تحديد أولوية المهمة');
    }

    if (!state.hasValidSubtasksCount) {
      return _emitValidationError('يمكنك إضافة 20 مهمة فرعية كحد أقصى');
    }

    if (!state.haveValidSubtaskLengths) {
      return _emitValidationError('أحد عناوين المهام الفرعية طويل جدًا');
    }

    if (!state.hasValidRepeatWeekday) {
      return _emitValidationError('يرجى اختيار يوم تكرار صحيح للمهمة');
    }

    if (!state.hasValidReminder) {
      return _emitValidationError('وقت التذكير المحدد غير صالح');
    }

    debugPrint('✓ form validation success');
    debugPrint('→ taskRangeDays: ${state.taskRangeDays}');
    debugPrint('→ subtasksCount: ${state.subtasksCount}');
    debugPrint('===========================================================');

    return true;
  }

  bool _emitValidationError(String message) {
    debugPrint('✗ validation failure');
    debugPrint('→ message: $message');

    emit(
      state.copyWith(
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        errorTitle: 'تنبيه',
        errorMessage: message,
      ),
    );

    return false;
  }

  // =========================================================
  // CREATE TASK
  // =========================================================

  Future<void> createStudyTask() async {
    debugPrint(
      '============ '
      'CreateStudyTaskCubit.createStudyTask '
      '============',
    );

    if (state.isSubmitLoading) {
      debugPrint('✗ request ignored: submit already loading');

      return;
    }

    if (!validateBeforeSubmit()) {
      debugPrint('✗ create task stopped because validation failed');

      return;
    }

    final params = CreateStudyTaskParams(
      planId: state.planId,
      title: state.normalizedTitle,
      description: state.normalizedDescription,
      studyPlanSubjectId: state.selectedStudyPlanSubjectId!,
      startDate: state.normalizedStartDate!,
      endDate: state.normalizedEndDate!,
      startTime: state.normalizedStartTime,
      durationMinutes: state.durationMinutes!,
      priority: state.priority!,
      subtasks: state.subtaskParams,
      repeatPattern: state.repeatPattern,
      repeatWeekday: state.isRepeating ? state.repeatWeekday : null,
      reminderOffsetMinutes: state.reminderOffsetMinutes,
    );

    if (!params.isValid) {
      debugPrint('✗ generated params are invalid');
      debugPrint('→ params: $params');

      emit(
        state.copyWith(
          submitStatus: CreateStudyTaskSubmitStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'تعذر تجهيز بيانات المهمة، يرجى مراجعة الحقول المدخلة',
        ),
      );

      return;
    }

    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toBody()}');

    emit(
      state.copyWith(
        submitStatus: CreateStudyTaskSubmitStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await createStudyTaskUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ createStudyTask failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              submitStatus: CreateStudyTaskSubmitStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ createStudyTask success');
          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ statusCode: ${response.statusCode}');

          emit(
            state.copyWith(
              submitStatus: CreateStudyTaskSubmitStatus.success,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ createStudyTask unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          submitStatus: CreateStudyTaskSubmitStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر إنشاء المهمة الدراسية',
        ),
      );
    } finally {
      debugPrint('===========================================================');
    }
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
        submitStatus: CreateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  DateTime _normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _isDateRangeWithinLimit({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (endDate.isBefore(startDate)) {
      return false;
    }

    final rangeDays = endDate.difference(startDate).inDays + 1;

    return rangeDays >= 1 && rangeDays <= CreateStudyTaskState.maxTaskRangeDays;
  }
}
