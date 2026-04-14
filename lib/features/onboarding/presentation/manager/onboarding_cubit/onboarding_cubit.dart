import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_step_type.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  // مهم جدًا:
  // خزّن القيم كـ codes ثابتة، وليس كنصوص UI المعروضة للمستخدم.
  // مثال:
  // school / university / masters / doctorate / graduated
  static const String schoolLevel = 'school';
  static const String universityLevel = 'university';
  static const String mastersLevel = 'masters';
  static const String doctorateLevel = 'doctorate';
  static const String graduatedLevel = 'graduated';

  void heardAboutChanged(String value) {
    emit(state.copyWith(heardAbout: value, clearErrorMessage: true));
    debugPrint('new heardAbout value is: ${state.heardAbout}');
  }

  void governorateChanged(String value) {
    emit(state.copyWith(governorate: value, clearErrorMessage: true));
    debugPrint('new governorate value is: ${state.governorate}');
  }

  void educationLevelChanged(String value) {
    final updatedSteps = _buildVisibleSteps(value);
    emit(
      state.copyWith(
        educationLevel: value,
        visibleSteps: updatedSteps,
        currentStepIndex: _safeStepIndex(
          currentIndex: state.currentStepIndex,
          visibleSteps: updatedSteps,
        ),
        currentUniversity: _shouldKeepCurrentUniversity(value)
            ? state.currentUniversity
            : null,
        schoolStage: _shouldKeepSchoolStage(value) ? state.schoolStage : null,
        graduatedUniversity: _shouldKeepGraduatedUniversity(value)
            ? state.graduatedUniversity
            : null,
        clearErrorMessage: true,
      ),
    );
    debugPrint('new education level value is: ${state.educationLevel}');
  }

  void currentUniversityChanged(String value) {
    emit(
      state.copyWith(
        currentUniversity: value,
        currentDepartmentAtUnivercity: null,
        currentStudyYearAtUnivercity: null,
        clearErrorMessage: true,
      ),
    );
    debugPrint(
      'new cuttent university level value is: ${state.currentUniversity}',
    );
  }

  void currentDepartmentAtUnivercityChanged(String value) {
    emit(
      state.copyWith(
        currentDepartmentAtUnivercity: value,
        currentStudyYearAtUnivercity: null,
        clearErrorMessage: true,
      ),
    );
    debugPrint(      'new currentDepartment level value is: ${state.currentDepartmentAtUnivercity}',
    );
  }

  void currentStudyYearAtUnivercityChanged(int value) {
    emit(
      state.copyWith(
        currentStudyYearAtUnivercity: value,
        clearErrorMessage: true,
      ),
    );
    debugPrint(
      'new cuttent university level value is: ${state.currentStudyYearAtUnivercity}',
    );
  }

  void schoolStageChanged(String value) {
    emit(state.copyWith(schoolStage: value, clearErrorMessage: true));
    debugPrint('new school stage value is: ${state.schoolStage}');
  }

  void graduatedUniversityChanged(String value) {
    emit(state.copyWith(graduatedUniversity: value, clearErrorMessage: true));
  }

  void toggleInterest(int interestId) {
    final currentIds = List<int>.from(state.selectedInterestIds);

    if (currentIds.contains(interestId)) {
      currentIds.remove(interestId);
    } else {
      if (currentIds.length >= 5) {
        emit(state.copyWith(errorMessage: 'يمكن اختيار 5 اهتمامات كحد أقصى'));
        return;
      }
      currentIds.add(interestId);
    }

    emit(
      state.copyWith(selectedInterestIds: currentIds, clearErrorMessage: true),
    );
  }

  Future<void> nextStep() async {
    if (!state.canGoNext || state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    try {
      await _submitCurrentStep();

      if (state.currentStep == OnboardingStepType.done || state.isLastStep) {
        emit(state.copyWith(isSubmitting: false, isCompleted: true));
        return;
      }

      emit(
        state.copyWith(
          isSubmitting: false,
          currentStepIndex: state.currentStepIndex + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'حدث خطأ أثناء حفظ بيانات الخطوة الحالية',
        ),
      );
    }
  }

  void previousStep() {
    if (state.isSubmitting || state.isFirstStep) return;

    emit(
      state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
        clearErrorMessage: true,
      ),
    );
  }

  void goToStep(int index) {
    if (index < 0 || index >= state.visibleSteps.length) return;

    emit(state.copyWith(currentStepIndex: index, clearErrorMessage: true));
  }

  List<OnboardingStepType> _buildVisibleSteps(String? educationLevel) {
    if (educationLevel == null || educationLevel.trim().isEmpty) {
      return const [
        OnboardingStepType.heardAbout,
        OnboardingStepType.educationLevel,
      ];
    }

    switch (educationLevel) {
      case schoolLevel:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
          OnboardingStepType.schoolStage,
          OnboardingStepType.interests,
          OnboardingStepType.done,
        ];

      case universityLevel:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
          OnboardingStepType.currentUniversity,
          OnboardingStepType.interests,
          OnboardingStepType.done,
        ];

      case mastersLevel:
      case doctorateLevel:
      case graduatedLevel:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
          OnboardingStepType.graduatedUniversity,
          OnboardingStepType.interests,
          OnboardingStepType.done,
        ];

      default:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
        ];
    }
  }

  int _safeStepIndex({
    required int currentIndex,
    required List<OnboardingStepType> visibleSteps,
  }) {
    if (visibleSteps.isEmpty) return 0;
    if (currentIndex < 0) return 0;
    if (currentIndex >= visibleSteps.length) return visibleSteps.length - 1;
    return currentIndex;
  }

  bool _shouldKeepCurrentUniversity(String educationLevel) {
    return educationLevel == universityLevel;
  }

  bool _shouldKeepSchoolStage(String educationLevel) {
    return educationLevel == schoolLevel;
  }

  bool _shouldKeepGraduatedUniversity(String educationLevel) {
    return educationLevel == mastersLevel ||
        educationLevel == doctorateLevel ||
        educationLevel == graduatedLevel;
  }

  Future<void> _submitCurrentStep() async {
    // هذه دالة مؤقتة حاليًا.
    // لاحقًا سنربطها مع API / UseCase حسب الخطوة الحالية.
    await Future<void>.delayed(Duration.zero);
  }
}
