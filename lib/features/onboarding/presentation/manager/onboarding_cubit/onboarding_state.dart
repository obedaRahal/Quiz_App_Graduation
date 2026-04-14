import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_step_type.dart';

class OnboardingState {
  final List<OnboardingStepType> visibleSteps;
  final int currentStepIndex;

  // at HeardAboutStep
  final String? heardAbout;

  final String? graduatedUniversity;

  // at EducationLevelStep
  final String? educationLevel;
  final String? governorate;

  // at CuurenUnivercity
  final String? currentUniversity;
  final String? currentDepartmentAtUnivercity;
  final int? currentStudyYearAtUnivercity;

  // at SchoolEdgrStep
  final String? schoolStage;

  final List<int> selectedInterestIds;

  final bool isLoading;
  final bool isSubmitting;
  final bool isCompleted;

  final String? errorMessage;

  const OnboardingState({
    this.visibleSteps = const [
      OnboardingStepType.heardAbout,
      OnboardingStepType.educationLevel,
    ],
    this.currentStepIndex = 0,
    this.heardAbout,
    this.educationLevel,
    this.currentUniversity,
    this.schoolStage,
    this.graduatedUniversity,
    this.governorate,
    this.currentDepartmentAtUnivercity,
    this.currentStudyYearAtUnivercity,
    this.selectedInterestIds = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.isCompleted = false,
    this.errorMessage,
  });

  OnboardingStepType get currentStep {
    if (visibleSteps.isEmpty) {
      return OnboardingStepType.heardAbout;
    }

    if (currentStepIndex < 0 || currentStepIndex >= visibleSteps.length) {
      return visibleSteps.first;
    }

    return visibleSteps[currentStepIndex];
  }

  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == visibleSteps.length - 1;

  bool get canGoNext {
    switch (currentStep) {
      case OnboardingStepType.heardAbout:
        return heardAbout != null && heardAbout!.trim().isNotEmpty;

      case OnboardingStepType.educationLevel:
        return governorate != null &&
            governorate!.trim().isNotEmpty &&
            educationLevel != null &&
            educationLevel!.trim().isNotEmpty;

      case OnboardingStepType.currentUniversity:
        return currentUniversity != null &&
            currentUniversity!.trim().isNotEmpty &&
            currentDepartmentAtUnivercity != null &&
            currentDepartmentAtUnivercity!.trim().isNotEmpty &&
            currentStudyYearAtUnivercity != null;

      case OnboardingStepType.schoolStage:
        return schoolStage != null && schoolStage!.trim().isNotEmpty;

      case OnboardingStepType.interests:
        return selectedInterestIds.isNotEmpty &&
            selectedInterestIds.length <= 5;

      case OnboardingStepType.graduatedUniversity:
        return graduatedUniversity != null &&
            graduatedUniversity!.trim().isNotEmpty;

      case OnboardingStepType.done:
        return true;
    }
  }

  OnboardingState copyWith({
    List<OnboardingStepType>? visibleSteps,
    int? currentStepIndex,
    String? heardAbout,
    String? educationLevel,
    String? currentUniversity,
    String? schoolStage,
    String? graduatedUniversity,
    String? governorate,
    String? currentDepartmentAtUnivercity,
    int? currentStudyYearAtUnivercity,
    List<int>? selectedInterestIds,
    bool? isLoading,
    bool? isSubmitting,
    bool? isCompleted,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OnboardingState(
      visibleSteps: visibleSteps ?? this.visibleSteps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      heardAbout: heardAbout ?? this.heardAbout,
      educationLevel: educationLevel ?? this.educationLevel,
      currentUniversity: currentUniversity ?? this.currentUniversity,
      schoolStage: schoolStage ?? this.schoolStage,
      governorate: governorate ?? this.governorate,
      currentDepartmentAtUnivercity: currentDepartmentAtUnivercity ?? this.currentDepartmentAtUnivercity,
      currentStudyYearAtUnivercity: currentStudyYearAtUnivercity ?? this.currentStudyYearAtUnivercity,
      graduatedUniversity: graduatedUniversity ?? this.graduatedUniversity,
      selectedInterestIds: selectedInterestIds ?? this.selectedInterestIds,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
