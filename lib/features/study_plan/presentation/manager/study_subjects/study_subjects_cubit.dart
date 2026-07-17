import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/create_study_subject_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/delete_study_subject_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_subjects_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_state.dart';

class StudySubjectsCubit extends Cubit<StudySubjectsState> {
  static const int subjectNameMaxLength = 50;

  final GetStudySubjectsUseCase getStudySubjectsUseCase;
  final CreateStudySubjectUseCase createStudySubjectUseCase;
  final DeleteStudySubjectUseCase deleteStudySubjectUseCase;

  StudySubjectsCubit({
    required this.getStudySubjectsUseCase,
    required this.createStudySubjectUseCase,
    required this.deleteStudySubjectUseCase,
  }) : super(const StudySubjectsState()) {
    debugPrint('============ StudySubjectsCubit INIT ============');
  }

  // =========================================================
  // GET SUBJECTS
  // =========================================================

  Future<void> getSubjects() async {
    debugPrint('============ StudySubjectsCubit.getSubjects ============');

    if (state.isLoading) {
      debugPrint('✗ getSubjects ignored: request already loading');
      debugPrint('=======================================================');
      return;
    }

    emit(
      state.copyWith(
        loadStatus: StudySubjectsLoadStatus.loading,
        clearError: true,
      ),
    );

    try {
      final result = await getStudySubjectsUseCase();

      result.fold(
        (failure) {
          debugPrint('✗ StudySubjectsCubit.getSubjects failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              loadStatus: StudySubjectsLoadStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ StudySubjectsCubit.getSubjects success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ subjects count: ${response.subjects.length}');

          for (final subject in response.subjects) {
            debugPrint('→ subject: id=${subject.id}, name=${subject.name}');
          }

          emit(
            state.copyWith(
              loadStatus: StudySubjectsLoadStatus.success,
              subjects: List<StudySubjectEntity>.unmodifiable(
                response.subjects,
              ),
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ StudySubjectsCubit.getSubjects unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          loadStatus: StudySubjectsLoadStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب المواد الدراسية',
        ),
      );
    } finally {
      debugPrint('=======================================================');
    }
  }

  // =========================================================
  // DRAFT NAME
  // =========================================================

  void changeDraftName(String value) {
    if (value.length > subjectNameMaxLength) {
      debugPrint('✗ changeDraftName ignored: max length exceeded');
      debugPrint('→ current length: ${value.length}');
      return;
    }

    emit(
      state.copyWith(
        draftName: value,
        createStatus: CreateStudySubjectStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // CREATE SUBJECT
  // =========================================================

  Future<void> createSubject() async {
    debugPrint('============ StudySubjectsCubit.createSubject ============');

    if (state.isCreateLoading) {
      debugPrint('✗ createSubject ignored: request already loading');
      debugPrint('=========================================================');
      return;
    }

    final normalizedName = _normalizeSubjectName(state.draftName);

    debugPrint('→ raw name: "${state.draftName}"');
    debugPrint('→ normalized name: "$normalizedName"');
    debugPrint('→ length: ${normalizedName.length}');

    if (normalizedName.isEmpty) {
      debugPrint('✗ createSubject validation: empty name');

      emit(
        state.copyWith(
          createStatus: CreateStudySubjectStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال اسم المادة أولًا',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    if (normalizedName.length > subjectNameMaxLength) {
      debugPrint('✗ createSubject validation: name too long');

      emit(
        state.copyWith(
          createStatus: CreateStudySubjectStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يجب ألا يتجاوز اسم المادة 50 حرفًا',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    if (_subjectAlreadyExists(normalizedName)) {
      debugPrint('✗ createSubject validation: duplicated subject');

      emit(
        state.copyWith(
          createStatus: CreateStudySubjectStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'هذه المادة مضافة مسبقًا',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    final params = CreateStudySubjectParams(name: normalizedName);

    debugPrint('→ params: $params');

    emit(
      state.copyWith(
        createStatus: CreateStudySubjectStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await createStudySubjectUseCase(params);

      await result.fold(
        (failure) async {
          debugPrint('✗ StudySubjectsCubit.createSubject failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              createStatus: CreateStudySubjectStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) async {
          debugPrint('✓ StudySubjectsCubit.createSubject success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ refreshing subjects after create');

          /*
           * الـAPI لا يعيد id المادة الجديدة،
           * لذلك يجب إعادة جلب القائمة.
           */
          final refreshedSubjects = await _fetchSubjectsAfterCreate();

          if (refreshedSubjects == null) {
            debugPrint('✗ subject created, but refresh failed');

            emit(
              state.copyWith(
                createStatus: CreateStudySubjectStatus.success,
                draftName: '',
                actionMessage: response.message,
                errorTitle: 'تنبيه',
                errorMessage: 'تم إنشاء المادة، لكن تعذر تحديث القائمة',
              ),
            );

            return;
          }

          debugPrint('✓ subjects refreshed after create');
          debugPrint('→ new subjects count: ${refreshedSubjects.length}');

          emit(
            state.copyWith(
              loadStatus: StudySubjectsLoadStatus.success,
              createStatus: CreateStudySubjectStatus.success,
              subjects: List<StudySubjectEntity>.unmodifiable(
                refreshedSubjects,
              ),
              draftName: '',
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ StudySubjectsCubit.createSubject unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          createStatus: CreateStudySubjectStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر إنشاء المادة الدراسية',
        ),
      );
    } finally {
      debugPrint('=========================================================');
    }
  }

  Future<List<StudySubjectEntity>?> _fetchSubjectsAfterCreate() async {
    debugPrint(
      '============ StudySubjectsCubit._fetchSubjectsAfterCreate ============',
    );

    try {
      final result = await getStudySubjectsUseCase();

      return result.fold(
        (failure) {
          debugPrint('✗ refresh after create failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          return null;
        },
        (response) {
          debugPrint('✓ refresh after create success');
          debugPrint('→ subjects count: ${response.subjects.length}');

          return response.subjects;
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ refresh after create unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      return null;
    } finally {
      debugPrint(
        '=====================================================================',
      );
    }
  }

  // =========================================================
  // DELETE SUBJECT
  // =========================================================

  Future<void> deleteSubject({required int subjectId}) async {
    debugPrint('============ StudySubjectsCubit.deleteSubject ============');
    debugPrint('→ subjectId: $subjectId');

    if (state.isDeleteLoading) {
      debugPrint('✗ deleteSubject ignored: another delete request is loading');
      debugPrint('=========================================================');
      return;
    }

    final subjectExists = state.subjects.any(
      (subject) => subject.id == subjectId,
    );

    if (!subjectExists) {
      debugPrint('✗ deleteSubject ignored: subject does not exist locally');
      debugPrint('=========================================================');
      return;
    }

    final params = DeleteStudySubjectParams(subjectId: subjectId);

    debugPrint('→ params: $params');

    emit(
      state.copyWith(
        deleteStatus: DeleteStudySubjectStatus.loading,
        deletingSubjectId: subjectId,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await deleteStudySubjectUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ StudySubjectsCubit.deleteSubject failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              deleteStatus: DeleteStudySubjectStatus.failure,
              clearDeletingSubjectId: true,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ StudySubjectsCubit.deleteSubject success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');

          final updatedSubjects = state.subjects
              .where((subject) => subject.id != subjectId)
              .toList();

          debugPrint('→ old subjects count: ${state.subjects.length}');
          debugPrint('→ new subjects count: ${updatedSubjects.length}');

          emit(
            state.copyWith(
              subjects: List<StudySubjectEntity>.unmodifiable(updatedSubjects),
              deleteStatus: DeleteStudySubjectStatus.success,
              clearDeletingSubjectId: true,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ StudySubjectsCubit.deleteSubject unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudySubjectStatus.failure,
          clearDeletingSubjectId: true,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر حذف المادة الدراسية',
        ),
      );
    } finally {
      debugPrint('=========================================================');
    }
  }

  // =========================================================
  // VALIDATION HELPERS
  // =========================================================

  bool _subjectAlreadyExists(String name) {
    final normalizedName = _normalizeSubjectName(name);

    return state.subjects.any((subject) {
      return _normalizeSubjectName(subject.name) == normalizedName;
    });
  }

  String _normalizeSubjectName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  // =========================================================
  // RESET ACTION STATES
  // =========================================================

  void resetCreateState() {
    debugPrint('============ StudySubjectsCubit.resetCreateState ============');

    emit(
      state.copyWith(
        createStatus: CreateStudySubjectStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void resetDeleteState() {
    debugPrint('============ StudySubjectsCubit.resetDeleteState ============');

    emit(
      state.copyWith(
        deleteStatus: DeleteStudySubjectStatus.initial,
        clearDeletingSubjectId: true,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  void clearDraftName() {
    debugPrint('============ StudySubjectsCubit.clearDraftName ============');

    emit(
      state.copyWith(
        draftName: '',
        createStatus: CreateStudySubjectStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }
}
