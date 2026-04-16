import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_step_type.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interests_models.dart';

class OnboardingState {
  final List<OnboardingStepType> visibleSteps;
  final int currentStepIndex;

  // at HeardAboutStep
  final String? heardAbout;

  // at EducationLevelStep
  final String? educationLevel;
  final String? governorate;

  // at CuurenUniversity
  final String? currentUniversity;
  final String? currentDepartmentAtUniversity;
  final int? currentStudyYearAtUniversity;

  // at SchoolEdgrStep
  final String? schoolStage;

  // at gratuated univisity
  final String? graduatedUniversity;
  final String? graduatedDepartment;
  final String? graduationCertificateImagePath;
  final String? personalIdentityImagePath;

  // at interests step
  final List<int> selectedInterestIds;
  final List<InterestGroupOption> interestGroups;

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
    this.currentDepartmentAtUniversity,
    this.currentStudyYearAtUniversity,
    this.graduatedDepartment,
    this.graduationCertificateImagePath,
    this.personalIdentityImagePath,
    this.selectedInterestIds = const [],
    this.interestGroups = const [],
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
            currentDepartmentAtUniversity != null &&
            currentDepartmentAtUniversity!.trim().isNotEmpty &&
            currentStudyYearAtUniversity != null;

      case OnboardingStepType.schoolStage:
        return schoolStage != null && schoolStage!.trim().isNotEmpty;

      case OnboardingStepType.interests:
        return selectedInterestIds.isNotEmpty &&
            selectedInterestIds.length <= 5;

      case OnboardingStepType.graduatedUniversity:
        return graduatedUniversity != null &&
            graduatedUniversity!.trim().isNotEmpty &&
            graduatedDepartment != null &&
            graduatedDepartment!.trim().isNotEmpty;

      case OnboardingStepType.done:
        return true;
    }
  }

  // CuurenUniversity copyWith({
  //   List<OnboardingStepType>? visibleSteps,
  //   int? currentStepIndex,
  //   String? heardAbout,
  //   String? educationLevel,
  //   String? currentUniversity,
  //   String? schoolStage,
  //   String? graduatedUniversity,
  //   String? governorate,
  //   String? currentDepartmentAtUniversity,
  //   int? currentStudyYearAtUniversity,
  //   List<int>? selectedInterestIds,
  //   List<InterestGroupOption>? interestGroups,
  //   String? graduatedDepartment,
  //   String? graduationCertificateImagePath,
  //   String? personalIdentityImagePath,
  //   bool? isLoading,
  //   bool? isSubmitting,
  //   bool? isCompleted,
  //   String? errorMessage,
  //   bool clearErrorMessage = false,
  // }) {
  //   return CuurenUniversity(
  //     visibleSteps: visibleSteps ?? this.visibleSteps,
  //     currentStepIndex: currentStepIndex ?? this.currentStepIndex,
  //     heardAbout: heardAbout ?? this.heardAbout,
  //     educationLevel: educationLevel ?? this.educationLevel,
  //     currentUniversity: currentUniversity ?? this.currentUniversity,
  //     schoolStage: schoolStage ?? this.schoolStage,
  //     governorate: governorate ?? this.governorate,
  //     currentDepartmentAtUniversity:
  //         currentDepartmentAtUniversity ?? this.currentDepartmentAtUniversity,
  //     currentStudyYearAtUniversity:
  //         currentStudyYearAtUniversity ?? this.currentStudyYearAtUniversity,
  //     graduatedUniversity: graduatedUniversity ?? this.graduatedUniversity,
  //     selectedInterestIds: selectedInterestIds ?? this.selectedInterestIds,
  //     interestGroups: interestGroups ?? this.interestGroups,
  //     graduatedDepartment: graduatedDepartment ?? this.graduatedDepartment,
  //     graduationCertificateImagePath:
  //         graduationCertificateImagePath ?? this.graduationCertificateImagePath,
  //     personalIdentityImagePath:
  //         personalIdentityImagePath ?? this.personalIdentityImagePath,
  //     isLoading: isLoading ?? this.isLoading,
  //     isSubmitting: isSubmitting ?? this.isSubmitting,
  //     isCompleted: isCompleted ?? this.isCompleted,
  //     errorMessage: clearErrorMessage
  //         ? null
  //         : (errorMessage ?? this.errorMessage),
  //   );
  // }

  OnboardingState copyWith({
    List<OnboardingStepType>? visibleSteps,
    int? currentStepIndex,
    String? heardAbout,
    String? educationLevel,
    String? currentUniversity,
    String? schoolStage,
    String? graduatedUniversity,
    String? governorate,
    String? currentDepartmentAtUniversity,
    int? currentStudyYearAtUniversity,
    List<int>? selectedInterestIds,
    List<InterestGroupOption>? interestGroups,
    String? graduatedDepartment,
    String? graduationCertificateImagePath,
    String? personalIdentityImagePath,
    bool? isLoading,
    bool? isSubmitting,
    bool? isCompleted,
    String? errorMessage,
    bool clearErrorMessage = false,

    bool clearCurrentUniversity = false,
    bool clearCurrentDepartmentAtUniversity = false,
    bool clearCurrentStudyYearAtUniversity = false,
    bool clearSchoolStage = false,
    bool clearGraduatedUniversity = false,
    bool clearGraduatedDepartment = false,
    bool clearGraduationCertificateImagePath = false,
    bool clearPersonalIdentityImagePath = false,
  }) {
    return OnboardingState(
      visibleSteps: visibleSteps ?? this.visibleSteps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      heardAbout: heardAbout ?? this.heardAbout,
      educationLevel: educationLevel ?? this.educationLevel,
      governorate: governorate ?? this.governorate,

      currentUniversity: clearCurrentUniversity
          ? null
          : (currentUniversity ?? this.currentUniversity),

      currentDepartmentAtUniversity: clearCurrentDepartmentAtUniversity
          ? null
          : (currentDepartmentAtUniversity ??
                this.currentDepartmentAtUniversity),

      currentStudyYearAtUniversity: clearCurrentStudyYearAtUniversity
          ? null
          : (currentStudyYearAtUniversity ?? this.currentStudyYearAtUniversity),

      schoolStage: clearSchoolStage ? null : (schoolStage ?? this.schoolStage),

      graduatedUniversity: clearGraduatedUniversity
          ? null
          : (graduatedUniversity ?? this.graduatedUniversity),

      graduatedDepartment: clearGraduatedDepartment
          ? null
          : (graduatedDepartment ?? this.graduatedDepartment),

      graduationCertificateImagePath: clearGraduationCertificateImagePath
          ? null
          : (graduationCertificateImagePath ??
                this.graduationCertificateImagePath),

      personalIdentityImagePath: clearPersonalIdentityImagePath
          ? null
          : (personalIdentityImagePath ?? this.personalIdentityImagePath),

      selectedInterestIds: selectedInterestIds ?? this.selectedInterestIds,
      interestGroups: interestGroups ?? this.interestGroups,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
