import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_plan_subjects_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_task_details_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/update_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/update_study_task_use_case.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';

class UpdateStudyTaskCubit extends Cubit<UpdateStudyTaskState> {
  final GetStudyTaskDetailsUseCase getStudyTaskDetailsUseCase;
  final GetStudyPlanSubjectsUseCase getStudyPlanSubjectsUseCase;
  final UpdateStudyTaskUseCase updateStudyTaskUseCase;

  UpdateStudyTaskCubit({
    required this.getStudyTaskDetailsUseCase,
    required this.getStudyPlanSubjectsUseCase,
    required this.updateStudyTaskUseCase,
  }) : super(const UpdateStudyTaskState()) {
    debugPrint('============ UpdateStudyTaskCubit INIT ============');
  }

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> initialize({required int planId, required int taskId}) async {
    debugPrint(
      '============ '
      'UpdateStudyTaskCubit.initialize '
      '============',
    );

    debugPrint('→ planId: $planId');
    debugPrint('→ taskId: $taskId');

    if (planId <= 0 || taskId <= 0) {
      debugPrint('✗ invalid plan or task id');

      emit(
        UpdateStudyTaskState(
          planId: planId,
          taskId: taskId,
          initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة الدراسية غير صالح',
        ),
      );

      return;
    }

    emit(
      UpdateStudyTaskState(
        planId: planId,
        taskId: taskId,
        initialDataStatus: UpdateStudyTaskInitialDataStatus.loading,
      ),
    );

    final detailsLoaded = await _loadTaskDetails();

    if (!detailsLoaded) {
      debugPrint(
        '✗ initialization stopped: '
        'task details failed',
      );

      return;
    }

    final subjectsLoaded = await _loadPlanSubjects();

    if (!subjectsLoaded) {
      debugPrint(
        '✗ initialization stopped: '
        'subjects failed',
      );

      return;
    }

    emit(
      state.copyWith(
        initialDataStatus: UpdateStudyTaskInitialDataStatus.success,
        isFormInitialized: true,
        clearError: true,
      ),
    );

    debugPrint('✓ update form initialized');
    debugPrint('→ hasChanges: ${state.hasChanges}');
    debugPrint('→ canSubmit: ${state.canSubmit}');
    debugPrint('===================================================');
  }

  // =========================================================
  // LOAD TASK DETAILS
  // =========================================================

  Future<bool> _loadTaskDetails() async {
    final planId = state.planId;
    final taskId = state.taskId;

    if (planId == null || planId <= 0 || taskId == null || taskId <= 0) {
      emit(
        state.copyWith(
          initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة الدراسية غير صالح',
        ),
      );

      return false;
    }

    try {
      final result = await getStudyTaskDetailsUseCase(
        GetStudyTaskDetailsParams(planId: planId, taskId: taskId),
      );

      return result.fold(
        (failure) {
          debugPrint('✗ task details failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );

          return false;
        },
        (response) {
          debugPrint('✓ task details success');

          _populateTaskDetails(response);

          return true;
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ task details unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب تفاصيل المهمة',
        ),
      );

      return false;
    }
  }

  // =========================================================
  // POPULATE DETAILS
  // =========================================================

  void _populateTaskDetails(StudyTaskDetailsEntity response) {
    final basicInfo = response.data.basicInfo;
    final timingInfo = response.data.timingInfo;

    final startDate = _parseApiDate(basicInfo.startDate);

    final endDate = _parseApiDate(basicInfo.endDate);

    if (startDate == null || endDate == null) {
      throw const FormatException('Invalid study task dates');
    }

    final normalizedStartTime = _normalizeApiTime(timingInfo.startTime);

    final repeatPattern = studyTaskRepeatPatternFromApi(
      timingInfo.repeatPattern,
    );

    /*
   * reminder موجود دائمًا في الاستجابة،
   * لكن offsetMinutes قد يكون null.
   */
    final reminderOffset = timingInfo.reminder.offsetMinutes;

    final currentSubtasks = response.data.subtasks
        .map(
          (subtask) => UpdateStudyTaskSubtaskState(
            id: subtask.id,
            title: subtask.title,
            isCompleted: subtask.isCompleted,
          ),
        )
        .toList(growable: false);

    /*
   * ننشئ نسخة مستقلة للقيم الأصلية،
   * حتى لا تشترك القائمتان في المراجع نفسها.
   */
    final initialSubtasks = currentSubtasks
        .map(
          (subtask) => UpdateStudyTaskSubtaskState(
            id: subtask.id,
            title: subtask.title,
            isCompleted: subtask.isCompleted,
          ),
        )
        .toList(growable: false);

    /*
   * عند عدم وجود مهام فرعية نعرض حقلًا فارغًا
   * في الواجهة فقط.
   *
   * أما initialSubtasks فتبقى فارغة لأنها تمثل
   * البيانات الحقيقية القادمة من الخادم.
   */
    final displayedSubtasks = currentSubtasks.isEmpty
        ? const [UpdateStudyTaskSubtaskState()]
        : currentSubtasks;

    final repeatWeekday = repeatPattern == StudyTaskRepeatPattern.none
        ? null
        : timingInfo.repeatWeekday;

    emit(
      state.copyWith(
        // =====================================================
        // CURRENT VALUES
        // =====================================================
        title: basicInfo.title,

        description: basicInfo.description,

        selectedStudyPlanSubjectId: basicInfo.subject.id,

        startDate: startDate,

        endDate: endDate,

        startTime: normalizedStartTime,

        durationMinutes: timingInfo.duration.minutes,

        priority: basicInfo.priority,

        subtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          displayedSubtasks,
        ),

        repeatPattern: repeatPattern,

        repeatWeekday: repeatWeekday,

        clearRepeatWeekday: repeatWeekday == null,

        reminderOffsetMinutes: reminderOffset,

        clearReminderOffsetMinutes: reminderOffset == null,

        // =====================================================
        // INITIAL VALUES
        // =====================================================
        initialTitle: basicInfo.title,

        initialDescription: basicInfo.description,

        initialSelectedStudyPlanSubjectId: basicInfo.subject.id,

        initialStartDate: startDate,

        initialEndDate: endDate,

        initialStartTime: normalizedStartTime,

        initialDurationMinutes: timingInfo.duration.minutes,

        initialPriority: basicInfo.priority,

        initialSubtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          initialSubtasks,
        ),

        initialRepeatPattern: repeatPattern,

        initialRepeatWeekday: repeatWeekday,

        clearInitialRepeatWeekday: repeatWeekday == null,

        initialReminderOffsetMinutes: reminderOffset,

        clearInitialReminderOffsetMinutes: reminderOffset == null,
      ),
    );

    debugPrint('✓ task details populated');

    debugPrint('→ task title: ${state.title}');

    debugPrint(
      '→ subject id: '
      '${state.selectedStudyPlanSubjectId}',
    );

    debugPrint(
      '→ repeat: '
      '${state.repeatPattern.apiValue}',
    );

    debugPrint(
      '→ repeat weekday: '
      '${state.repeatWeekday}',
    );

    debugPrint(
      '→ reminder offset: '
      '${state.reminderOffsetMinutes}',
    );

    debugPrint(
      '→ subtasks fields count: '
      '${state.subtaskFieldsCount}',
    );

    debugPrint(
      '→ normalized subtasks count: '
      '${state.subtasksCount}',
    );
  }

  // =========================================================
  // LOAD SUBJECTS
  // =========================================================

  Future<bool> _loadPlanSubjects() async {
    final planId = state.planId;

    if (planId == null || planId <= 0) {
      return false;
    }

    try {
      final result = await getStudyPlanSubjectsUseCase(planId: planId);

      return result.fold(
        (failure) {
          debugPrint('✗ subjects failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
              availableSubjects: const [],
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );

          return false;
        },
        (response) {
          final subjects = List<StudyPlanSubjectEntity>.unmodifiable(
            response.subjects,
          );

          final selectedSubjectId = state.selectedStudyPlanSubjectId;

          final selectedSubjectExists =
              selectedSubjectId != null &&
              subjects.any((subject) => subject.id == selectedSubjectId);

          if (!selectedSubjectExists) {
            emit(
              state.copyWith(
                initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
                availableSubjects: subjects,
                errorTitle: 'بيانات غير متوافقة',
                errorMessage: 'مادة المهمة غير موجودة ضمن مواد الخطة الحالية',
              ),
            );

            return false;
          }

          emit(state.copyWith(availableSubjects: subjects, clearError: true));

          debugPrint('✓ subjects success');
          debugPrint('→ subjects count: ${subjects.length}');

          return true;
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ subjects unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          initialDataStatus: UpdateStudyTaskInitialDataStatus.failure,
          availableSubjects: const [],
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب مواد الخطة الدراسية',
        ),
      );

      return false;
    }
  }

  Future<void> retryInitialize() async {
    final planId = state.planId;
    final taskId = state.taskId;

    if (planId == null || taskId == null) {
      return;
    }

    await initialize(planId: planId, taskId: taskId);
  }

  // =========================================================
  // HELPERS
  // =========================================================

  DateTime? _parseApiDate(String value) {
    final parsed = DateTime.tryParse(value.trim());

    if (parsed == null) {
      return null;
    }

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _normalizeApiTime(String value) {
    final normalized = value.trim();

    /*
     * في حال أعاد الخادم 08:30:00
     * نحوله إلى 08:30.
     */
    if (RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$').hasMatch(normalized)) {
      return normalized.substring(0, 5);
    }

    return normalized;
  }

  // =========================================================
  // FORM CHANGES
  // =========================================================

  void titleChanged(String value) {
    if (value == state.title) {
      return;
    }

    emit(
      state.copyWith(
        title: value,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void descriptionChanged(String value) {
    if (value == state.description) {
      return;
    }

    emit(
      state.copyWith(
        description: value,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void subjectChanged(int? subjectId) {
    if (subjectId == state.selectedStudyPlanSubjectId) {
      return;
    }

    if (subjectId == null) {
      emit(
        state.copyWith(
          clearSelectedStudyPlanSubjectId: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    if (!state.containsSubject(subjectId)) {
      debugPrint(
        '✗ subjectChanged ignored: '
        'subject $subjectId is not available',
      );

      return;
    }

    emit(
      state.copyWith(
        selectedStudyPlanSubjectId: subjectId,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void startDateChanged(DateTime? date) {
    if (date == null) {
      emit(
        state.copyWith(
          clearStartDate: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    final normalizedDate = UpdateStudyTaskState.normalizeDate(date);

    if (UpdateStudyTaskState.isSameDate(normalizedDate, state.startDate)) {
      return;
    }

    emit(
      state.copyWith(
        startDate: normalizedDate,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void endDateChanged(DateTime? date) {
    if (date == null) {
      emit(
        state.copyWith(
          clearEndDate: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    final normalizedDate = UpdateStudyTaskState.normalizeDate(date);

    if (UpdateStudyTaskState.isSameDate(normalizedDate, state.endDate)) {
      return;
    }

    emit(
      state.copyWith(
        endDate: normalizedDate,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void startTimeChanged(String value) {
    if (value == state.startTime) {
      return;
    }

    emit(
      state.copyWith(
        startTime: value,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void durationChanged(int? minutes) {
    if (minutes == state.durationMinutes) {
      return;
    }

    if (minutes == null) {
      emit(
        state.copyWith(
          clearDuration: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        durationMinutes: minutes,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void priorityChanged(StudyTaskPriority? priority) {
    if (priority == state.priority) {
      return;
    }

    if (priority == null) {
      emit(
        state.copyWith(
          clearPriority: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        priority: priority,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // REPEAT CHANGES
  // =========================================================

  void repeatPatternChanged(StudyTaskRepeatPattern pattern) {
    if (pattern == state.repeatPattern) {
      return;
    }

    emit(
      state.copyWith(
        repeatPattern: pattern,

        /*
       * سواء اختار بدون تكرار أو نمطًا جديدًا،
       * نعيد اليوم إلى null.
       */
        clearRepeatWeekday: true,

        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void repeatWeekdayChanged(int? weekday) {
    if (weekday == state.repeatWeekday) {
      return;
    }

    if (weekday == null) {
      emit(
        state.copyWith(
          clearRepeatWeekday: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    if (weekday < 0 || weekday > 6) {
      debugPrint(
        '✗ repeatWeekdayChanged ignored: '
        'invalid weekday $weekday',
      );

      return;
    }

    emit(
      state.copyWith(
        repeatWeekday: weekday,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // REMINDER CHANGE
  // =========================================================

  void reminderChanged(int? offsetMinutes) {
    if (offsetMinutes == state.reminderOffsetMinutes) {
      return;
    }

    if (offsetMinutes == null) {
      emit(
        state.copyWith(
          clearReminderOffsetMinutes: true,
          submitStatus: UpdateStudyTaskSubmitStatus.initial,
          clearActionMessage: true,
          clearError: true,
        ),
      );

      return;
    }

    if (!UpdateStudyTaskState.allowedReminderOffsetMinutes.contains(
      offsetMinutes,
    )) {
      debugPrint(
        '✗ reminderChanged ignored: '
        'invalid offset $offsetMinutes',
      );

      return;
    }

    emit(
      state.copyWith(
        reminderOffsetMinutes: offsetMinutes,
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // SUBTASKS
  // =========================================================

  void addSubtask() {
    if (!state.canAddSubtask) {
      debugPrint('✗ addSubtask ignored: maximum reached');

      emit(
        state.copyWith(
          errorTitle: 'الحد الأقصى',
          errorMessage:
              'لا يمكن إضافة أكثر من '
              '${UpdateStudyTaskState.maxSubtasksCount} '
              'مهمة فرعية',
        ),
      );

      return;
    }

    final updatedSubtasks = [
      ...state.subtasks,
      const UpdateStudyTaskSubtaskState(),
    ];

    emit(
      state.copyWith(
        subtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          updatedSubtasks,
        ),
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void removeSubtask(int index) {
    if (index < 0 || index >= state.subtasks.length) {
      debugPrint('✗ removeSubtask ignored: invalid index $index');

      return;
    }

    final updatedSubtasks = [...state.subtasks];

    updatedSubtasks.removeAt(index);

    /*
   * نترك حقلًا فارغًا في الواجهة عندما يتم حذف
   * جميع المهام الفرعية.
   *
   * normalizedSubtasks ستعتبره غير موجود،
   * وبذلك سيرسل الطلب:
   *
   * "subtasks": []
   */
    if (updatedSubtasks.isEmpty) {
      updatedSubtasks.add(const UpdateStudyTaskSubtaskState());
    }

    emit(
      state.copyWith(
        subtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          updatedSubtasks,
        ),
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void subtaskTitleChanged(int index, String value) {
    if (index < 0 || index >= state.subtasks.length) {
      debugPrint(
        '✗ subtaskTitleChanged ignored: '
        'invalid index $index',
      );

      return;
    }

    final currentSubtask = state.subtasks[index];

    if (currentSubtask.title == value) {
      return;
    }

    final updatedSubtasks = [...state.subtasks];

    updatedSubtasks[index] = currentSubtask.copyWith(title: value);

    emit(
      state.copyWith(
        subtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          updatedSubtasks,
        ),
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void subtaskCompletedChanged(int index, bool isCompleted) {
    if (index < 0 || index >= state.subtasks.length) {
      debugPrint(
        '✗ subtaskCompletedChanged ignored: '
        'invalid index $index',
      );

      return;
    }

    final currentSubtask = state.subtasks[index];

    if (currentSubtask.isCompleted == isCompleted) {
      return;
    }

    final updatedSubtasks = [...state.subtasks];

    updatedSubtasks[index] = currentSubtask.copyWith(isCompleted: isCompleted);

    emit(
      state.copyWith(
        subtasks: List<UpdateStudyTaskSubtaskState>.unmodifiable(
          updatedSubtasks,
        ),
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // BUILD UPDATE PARAMS
  // =========================================================

  UpdateStudyTaskParams? _buildUpdateParams() {
    final planId = state.planId;
    final taskId = state.taskId;

    final selectedSubjectId = state.selectedStudyPlanSubjectId;

    final startDate = state.startDate;
    final endDate = state.endDate;

    final duration = state.durationMinutes;
    final priority = state.priority;

    if (planId == null || planId <= 0 || taskId == null || taskId <= 0) {
      return null;
    }

    if (state.hasSubjectChanged && selectedSubjectId == null) {
      return null;
    }

    if (state.hasStartDateChanged && startDate == null) {
      return null;
    }

    if (state.hasEndDateChanged && endDate == null) {
      return null;
    }

    if (state.hasDurationChanged && duration == null) {
      return null;
    }

    if (state.hasPriorityChanged && priority == null) {
      return null;
    }

    final changedSubtasks = state.normalizedSubtasks
        .map(
          (subtask) => UpdateStudyTaskSubtaskParams(
            id: subtask.id,
            title: subtask.normalizedTitle,
            isCompleted: subtask.isCompleted,
          ),
        )
        .toList(growable: false);

    return UpdateStudyTaskParams(
      planId: planId,
      taskId: taskId,

      title: state.hasTitleChanged ? state.normalizedTitle : null,

      description: state.hasDescriptionChanged
          ? state.normalizedDescription
          : null,

      studyPlanSubjectId: state.hasSubjectChanged ? selectedSubjectId : null,

      startDate: state.hasStartDateChanged ? startDate : null,

      endDate: state.hasEndDateChanged ? endDate : null,

      startTime: state.hasStartTimeChanged ? state.normalizedStartTime : null,

      durationMinutes: state.hasDurationChanged ? duration : null,

      priority: state.hasPriorityChanged ? priority : null,

      includeSubtasks: state.haveSubtasksChanged,

      subtasks: state.haveSubtasksChanged ? changedSubtasks : const [],

      includeRepeat: state.hasRepeatChanged,

      repeatPattern: state.hasRepeatChanged ? state.repeatPattern : null,

      repeatWeekday: state.hasRepeatChanged && state.isRepeating
          ? state.repeatWeekday
          : null,

      includeReminderOffsetMinutes: state.hasReminderChanged,

      reminderOffsetMinutes: state.hasReminderChanged
          ? state.reminderOffsetMinutes
          : null,
    );
  }

  // =========================================================
  // UPDATE STUDY TASK
  // =========================================================

  Future<void> updateStudyTask() async {
    debugPrint(
      '============ '
      'UpdateStudyTaskCubit.updateStudyTask '
      '============',
    );

    debugPrint(
      '→ isFormInitialized: '
      '${state.isFormInitialized}',
    );

    debugPrint('→ hasChanges: ${state.hasChanges}');

    debugPrint('→ isFormValid: ${state.isFormValid}');

    debugPrint('→ canSubmit: ${state.canSubmit}');

    if (state.isSubmitLoading) {
      debugPrint('✗ update ignored: request already loading');

      return;
    }

    if (!state.isFormInitialized || !state.isInitialDataSuccess) {
      emit(
        state.copyWith(
          submitStatus: UpdateStudyTaskSubmitStatus.failure,
          errorTitle: 'يرجى الانتظار',
          errorMessage: 'لم يكتمل تحميل بيانات المهمة بعد',
        ),
      );

      return;
    }

    if (!state.hasChanges) {
      emit(
        state.copyWith(
          submitStatus: UpdateStudyTaskSubmitStatus.failure,
          errorTitle: 'لا توجد تعديلات',
          errorMessage: 'قم بتعديل حقل واحد على الأقل قبل الحفظ',
        ),
      );

      return;
    }

    if (!state.isFormValid) {
      emit(
        state.copyWith(
          submitStatus: UpdateStudyTaskSubmitStatus.failure,
          errorTitle: 'بيانات غير مكتملة',
          errorMessage: _getValidationMessage(),
        ),
      );

      return;
    }

    final params = _buildUpdateParams();

    if (params == null || !params.isValid) {
      debugPrint('✗ invalid update study task params');

      debugPrint('→ params: $params');
      debugPrint('→ body: ${params?.toBody()}');

      emit(
        state.copyWith(
          submitStatus: UpdateStudyTaskSubmitStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'تعذر تجهيز بيانات تعديل المهمة',
        ),
      );

      return;
    }

    debugPrint('→ params: $params');
    debugPrint('→ body: ${params.toBody()}');

    emit(
      state.copyWith(
        submitStatus: UpdateStudyTaskSubmitStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await updateStudyTaskUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ update study task failure');

          debugPrint('→ title: ${failure.title}');

          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              submitStatus: UpdateStudyTaskSubmitStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ update study task success');

          debugPrint('→ success: ${response.success}');

          debugPrint('→ title: ${response.title}');

          debugPrint('→ message: ${response.message}');

          debugPrint('→ statusCode: ${response.statusCode}');

          emit(
            state.copyWith(
              submitStatus: UpdateStudyTaskSubmitStatus.success,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ update study task unexpected error');

      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          submitStatus: UpdateStudyTaskSubmitStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر تعديل المهمة الدراسية',
        ),
      );
    } finally {
      debugPrint('===================================================');
    }
  }

  String _getValidationMessage() {
    if (!state.hasValidIds) {
      return 'معرّف الخطة أو المهمة غير صالح';
    }

    if (!state.hasValidTitle) {
      return 'يرجى إدخال عنوان صالح للمهمة';
    }

    if (!state.hasValidDescription) {
      return 'يرجى إدخال وصف صالح للمهمة';
    }

    if (!state.hasSelectedSubject) {
      return 'يرجى اختيار مادة دراسية';
    }

    if (!state.hasValidDates) {
      return 'يرجى التأكد من تاريخ بداية ونهاية المهمة';
    }

    if (!state.hasValidStartTime) {
      return 'يرجى إدخال وقت بداية صالح';
    }

    if (!state.hasValidDuration) {
      return 'مدة المهمة يجب أن تكون بين '
          '${UpdateStudyTaskState.minDurationMinutes} و'
          '${UpdateStudyTaskState.maxDurationMinutes} دقيقة';
    }

    if (!state.hasValidPriority) {
      return 'يرجى اختيار أولوية المهمة';
    }

    if (!state.haveValidSubtasks) {
      return 'يرجى التأكد من صحة المهام الفرعية';
    }

    if (!state.hasValidRepeatWeekday) {
      return 'يرجى اختيار يوم التكرار';
    }

    if (!state.hasValidReminder) {
      return 'قيمة التذكير غير صالحة';
    }

    return 'يرجى التأكد من البيانات المدخلة';
  }

  // =========================================================
  // RESET STATUS
  // =========================================================

  void clearActionMessage() {
    if (state.actionMessage == null) {
      return;
    }

    emit(state.copyWith(clearActionMessage: true));
  }

  void clearError() {
    if (state.errorTitle == null && state.errorMessage == null) {
      return;
    }

    emit(state.copyWith(clearError: true));
  }

  void resetSubmitStatus() {
    if (state.isSubmitInitial) {
      return;
    }

    emit(
      state.copyWith(
        submitStatus: UpdateStudyTaskSubmitStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }
}
