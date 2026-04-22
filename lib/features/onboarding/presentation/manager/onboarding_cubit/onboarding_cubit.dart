import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_discovery_source_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_education_level_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_discovery_source_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_education_level_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_step_type.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interests_mock_data.dart';

import 'onboarding_state.dart';

class EducationLevelValues {
  static const String schoolLevel = 'مدرسة';
  static const String universityLevel = 'جامعة';
  static const String mastersLevel = 'ماجستير';
  static const String doctorateLevel = 'دكتوراه';
  static const String graduatedLevel = 'خريج';
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final SubmitDiscoverySourceUseCase submitDiscoverySourceUseCase;
  final SubmitEducationLevelUseCase submitEducationLevelUseCase;

  final String onboardingEmail;

  OnboardingCubit({
    required this.submitDiscoverySourceUseCase,
    required this.submitEducationLevelUseCase,
    required this.onboardingEmail,
  }) : super(const OnboardingState()) {
    debugPrint("============ OnboardingCubit INIT ============");
    debugPrint("→ onboardingEmail: $onboardingEmail");
  }

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

    final shouldKeepCurrentUniversity = _shouldKeepCurrentUniversity(value);
    final shouldKeepSchoolStage = _shouldKeepSchoolStage(value);
    final shouldKeepGraduatedUniversity = _shouldKeepGraduatedUniversity(value);

    emit(
      state.copyWith(
        educationLevel: value,
        visibleSteps: updatedSteps,
        currentStepIndex: _safeStepIndex(
          currentIndex: state.currentStepIndex,
          visibleSteps: updatedSteps,
        ),

        clearCurrentUniversity: !shouldKeepCurrentUniversity,
        clearCurrentDepartmentAtUniversity: !shouldKeepCurrentUniversity,
        clearCurrentStudyYearAtUniversity: !shouldKeepCurrentUniversity,

        clearSchoolStage: !shouldKeepSchoolStage,

        clearGraduatedUniversity: !shouldKeepGraduatedUniversity,
        clearGraduatedDepartment: !shouldKeepGraduatedUniversity,
        clearGraduationCertificateImagePath: !shouldKeepGraduatedUniversity,
        clearPersonalIdentityImagePath: !shouldKeepGraduatedUniversity,

        clearErrorMessage: true,
      ),
    );

    debugPrint('new education level value is: ${state.educationLevel}');
  }

  void currentUniversityChanged(String value) {
    emit(
      state.copyWith(
        currentUniversity: value,
        clearCurrentDepartmentAtUniversity: true,
        clearCurrentStudyYearAtUniversity: true,
        clearErrorMessage: true,
      ),
    );
    debugPrint('new current university value is: $value');
  }

  void currentDepartmentAtUniversityChanged(String value) {
    emit(
      state.copyWith(
        currentDepartmentAtUniversity: value,
        clearCurrentStudyYearAtUniversity: true,
        clearErrorMessage: true,
      ),
    );
    debugPrint('new current department value is: $value');
  }

  void currentStudyYearAtUniversityChanged(int value) {
    emit(
      state.copyWith(
        currentStudyYearAtUniversity: value,
        clearErrorMessage: true,
      ),
    );
    debugPrint('new current study year value is: $value');
  }

  void schoolStageChanged(String value) {
    emit(state.copyWith(schoolStage: value, clearErrorMessage: true));
    debugPrint('new school stage value is: ${state.schoolStage}');
  }

  void graduatedUniversityChanged(String value) {
    emit(
      state.copyWith(
        graduatedUniversity: value,
        graduatedDepartment: null,
        clearErrorMessage: true,
      ),
    );
    debugPrint(
      'new graduated university value is: ${state.graduatedUniversity}',
    );
  }

  void graduatedDepartmentChanged(String value) {
    emit(state.copyWith(graduatedDepartment: value, clearErrorMessage: true));
    debugPrint(
      'new graduated department value is: ${state.graduatedDepartment}',
    );
  }

  void graduationCertificateImageChanged(String value) {
    emit(
      state.copyWith(
        graduationCertificateImagePath: value,
        clearErrorMessage: true,
      ),
    );
    debugPrint(
      'new graduated certificate value is: ${state.graduationCertificateImagePath}',
    );
  }

  void personalIdentityImageChanged(String value) {
    emit(
      state.copyWith(personalIdentityImagePath: value, clearErrorMessage: true),
    );
    debugPrint(
      'new graduated Idintity value is: ${state.personalIdentityImagePath}',
    );
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

  void loadMockInterests() {
    emit(
      state.copyWith(
        interestGroups: mockInterestGroups,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> nextStep() async {
    debugPrint("============ OnboardingCubit.nextStep ============");
    debugPrint("→ currentStep: ${state.currentStep}");
    debugPrint("→ currentStepIndex: ${state.currentStepIndex}");

    if (!state.canGoNext) {
      debugPrint("✗ nextStep ignored: canGoNext = false");
      debugPrint("=================================================");
      return;
    }

    if (state.isSubmitting) {
      debugPrint("✗ nextStep ignored: already submitting");
      debugPrint("=================================================");
      return;
    }

    switch (state.currentStep) {
      case OnboardingStepType.heardAbout:
        await _submitDiscoverySourceStep();
        return;

      case OnboardingStepType.educationLevel:
        await _submitEducationLevelStep();
        return;

      case OnboardingStepType.done:
        debugPrint("✓ onboarding finished");
        emit(state.copyWith(isCompleted: true, clearErrorMessage: true));
        debugPrint("=================================================");
        return;

      default:
        _moveToNextStepLocally();
        return;
    }
  }

  Future<void> _submitDiscoverySourceStep() async {
    debugPrint(
      "============ OnboardingCubit._submitDiscoverySourceStep ============",
    );

    final selectedSource = state.heardAbout?.trim();

    if (selectedSource == null || selectedSource.isEmpty) {
      debugPrint("✗ discovery source is empty");
      emit(
        state.copyWith(
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار طريقة معرفتك بالتطبيق',
          isSubmitting: false,
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitDiscoverySourceUseCase(
      SubmitDiscoverySourceParams(
        email: onboardingEmail,
        discoverySource: selectedSource,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ submitDiscoverySource failure: ${failure.message}");

        emit(
          state.copyWith(
            isSubmitting: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ submitDiscoverySource success: ${response.title}");
        debugPrint("✓ saved discovery source: ${response.discoverySource}");

        emit(state.copyWith(isSubmitting: false, clearErrorMessage: true));

        _moveToNextStepLocally();
      },
    );

    debugPrint("=================================================");
  }

  Future<void> _submitEducationLevelStep() async {
    debugPrint(
      "============ OnboardingCubit._submitEducationLevelStep ============",
    );

    final selectedGovernorate = state.governorate?.trim();
    final selectedEducationLevel = state.educationLevel?.trim();

    if (selectedGovernorate == null || selectedGovernorate.isEmpty) {
      debugPrint("✗ governorate is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار المحافظة',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    if (selectedEducationLevel == null || selectedEducationLevel.isEmpty) {
      debugPrint("✗ education level is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار المستوى الدراسي',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitEducationLevelUseCase(
      SubmitEducationLevelParams(
        email: onboardingEmail,
        governorate: selectedGovernorate,
        educationLevel: selectedEducationLevel,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ submitEducationLevel failure title: ${failure.title}");
        debugPrint(
          "✗ submitEducationLevel failure message: ${failure.message}",
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ submitEducationLevel success: ${response.title}");
        debugPrint("✓ saved governorate: ${response.governorate}");
        debugPrint("✓ saved educationLevel: ${response.educationLevel}");

        emit(state.copyWith(isSubmitting: false, clearErrorMessage: true));

        _moveToNextStepLocally();
      },
    );

    debugPrint("=================================================");
  }

  

  void _moveToNextStepLocally() {
    debugPrint(
      "============ OnboardingCubit._moveToNextStepLocally ============",
    );

    if (state.currentStepIndex >= state.visibleSteps.length - 1) {
      debugPrint("✓ reached last visible step");
      emit(state.copyWith(isCompleted: true, clearErrorMessage: true));
      debugPrint("=================================================");
      return;
    }

    final newIndex = state.currentStepIndex + 1;

    emit(state.copyWith(currentStepIndex: newIndex, clearErrorMessage: true));

    debugPrint("→ moved to index: $newIndex");
    debugPrint("=================================================");
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
      case EducationLevelValues.schoolLevel:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
          OnboardingStepType.schoolStage,
          OnboardingStepType.interests,
          OnboardingStepType.done,
        ];

      case EducationLevelValues.universityLevel:
        return const [
          OnboardingStepType.heardAbout,
          OnboardingStepType.educationLevel,
          OnboardingStepType.currentUniversity,
          OnboardingStepType.interests,
          OnboardingStepType.done,
        ];

      case EducationLevelValues.mastersLevel:
      case EducationLevelValues.doctorateLevel:
      case EducationLevelValues.graduatedLevel:
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
    return educationLevel == EducationLevelValues.universityLevel;
  }

  bool _shouldKeepSchoolStage(String educationLevel) {
    return educationLevel == EducationLevelValues.schoolLevel;
  }

  bool _shouldKeepGraduatedUniversity(String educationLevel) {
    return educationLevel == EducationLevelValues.mastersLevel ||
        educationLevel == EducationLevelValues.doctorateLevel ||
        educationLevel == EducationLevelValues.graduatedLevel;
  }

  // Future<void> _submitCurrentStep() async {
  //   // هذه دالة مؤقتة حاليًا.
  //   // لاحقًا سنربطها مع API / UseCase حسب الخطوة الحالية.
  //   debugPrint("im at _submitCurrentStep to call API later");
  //   await Future<void>.delayed(Duration.zero);
  // }
}
