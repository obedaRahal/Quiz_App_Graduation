import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_interest_group.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_progress_preview_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_progress_preview_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/get_onboarding_progress_preview_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_current_university_profile_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_discovery_source_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_education_level_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_graduate_academic_profile_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_school_stage_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/params/submit_user_interests_params.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_current_university_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_discovery_source_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_education_level_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_graduate_academic_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_school_stage_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_user_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_step_type.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interests_mock_data.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interests_models.dart';

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
  final SubmitSchoolStageUseCase submitSchoolStageUseCase;
  final SubmitCurrentUniversityProfileUseCase
  submitCurrentUniversityProfileUseCase;
  final SubmitGraduateAcademicProfileUseCase
  submitGraduateAcademicProfileUseCase;
  final GetOnboardingInterestsUseCase getOnboardingInterestsUseCase;
  final SubmitUserInterestsUseCase submitUserInterestsUseCase;

  // onboarding progress preview
  final GetOnboardingProgressPreviewUseCase getOnboardingProgressPreviewUseCase;
  final int? initialLastCompletedStep;
  final String onboardingEmail;

  OnboardingCubit({
    required this.submitDiscoverySourceUseCase,
    required this.submitEducationLevelUseCase,
    required this.submitSchoolStageUseCase,
    required this.submitCurrentUniversityProfileUseCase,
    required this.submitGraduateAcademicProfileUseCase,
    required this.getOnboardingInterestsUseCase,
    required this.submitUserInterestsUseCase,
    required this.getOnboardingProgressPreviewUseCase,
    required this.onboardingEmail,
    this.initialLastCompletedStep,
  }) : super(const OnboardingState()) {
    debugPrint("============ OnboardingCubit INIT ============");
    debugPrint("→ onboardingEmail: $onboardingEmail");
    debugPrint("→ initialLastCompletedStep: $initialLastCompletedStep");
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
        //emit(state.copyWith(errorMessage: 'يمكن اختيار 5 اهتمامات كحد أقصى' ,));
        //return;
        currentIds.removeAt(0);
      }
      currentIds.add(interestId);
    }

    emit(
      state.copyWith(selectedInterestIds: currentIds, clearErrorMessage: true),
    );
    debugPrint('new list of interest is: ${state.selectedInterestIds}');
  }

  Future<void> loadInterests() async {
    debugPrint("============ OnboardingCubit.loadInterests ============");

    if (state.isLoading) {
      debugPrint("✗ loadInterests ignored: already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        hasAttemptedLoadingInterests: true,
        clearErrorMessage: true,
      ),
    );

    final result = await getOnboardingInterestsUseCase();

    result.fold(
      (failure) {
        debugPrint("✗ loadInterests failure title: ${failure.title}");
        debugPrint("✗ loadInterests failure message: ${failure.message}");

        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ loadInterests success: ${response.title}");
        debugPrint("✓ groups count: ${response.groups.length}");

        emit(
          state.copyWith(
            isLoading: false,
            interestGroups: _mapInterestGroupsToPresentation(response.groups),
            clearErrorMessage: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  List<InterestGroupOption> _mapInterestGroupsToPresentation(
    List<OnboardingInterestGroup> groups,
  ) {
    return groups.map((group) {
      return InterestGroupOption(
        id: 0,
        title: group.title,
        items: group.interests.map((interest) {
          return InterestOption(id: interest.id, name: interest.name);
        }).toList(),
      );
    }).toList();
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

      case OnboardingStepType.schoolStage:
        await _submitSchoolStageStep();
        return;

      case OnboardingStepType.graduatedUniversity:
        await _submitGraduateAcademicProfileStep();
        return;

      case OnboardingStepType.currentUniversity:
        await _submitCurrentUniversityProfileStep();
        return;

      case OnboardingStepType.interests:
        await _submitUserInterestsStep();
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

  Future<void> _submitSchoolStageStep() async {
    debugPrint(
      "============ OnboardingCubit._submitSchoolStageStep ============",
    );

    final selectedSchoolStage = state.schoolStage?.trim();

    if (selectedSchoolStage == null || selectedSchoolStage.isEmpty) {
      debugPrint("✗ school stage is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار المرحلة الدراسية',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitSchoolStageUseCase(
      SubmitSchoolStageParams(
        email: onboardingEmail,
        schoolStage: selectedSchoolStage,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ submitSchoolStage failure title: ${failure.title}");
        debugPrint("✗ submitSchoolStage failure message: ${failure.message}");

        emit(
          state.copyWith(
            isSubmitting: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ submitSchoolStage success: ${response.title}");
        debugPrint("✓ saved schoolStage: ${response.schoolStage}");

        emit(state.copyWith(isSubmitting: false, clearErrorMessage: true));

        _moveToNextStepLocally();
      },
    );

    debugPrint("=================================================");
  }

  Future<void> _submitCurrentUniversityProfileStep() async {
    debugPrint(
      "============ OnboardingCubit._submitCurrentUniversityProfileStep ============",
    );

    final selectedUniversityName = state.currentUniversity?.trim();
    final selectedDepartmentName = state.currentDepartmentAtUniversity?.trim();
    final selectedUniversityYear = state.currentStudyYearAtUniversity;

    if (selectedUniversityName == null || selectedUniversityName.isEmpty) {
      debugPrint("✗ current university is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار الجامعة',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    if (selectedDepartmentName == null || selectedDepartmentName.isEmpty) {
      debugPrint("✗ current department is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار القسم',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    if (selectedUniversityYear == null) {
      debugPrint("✗ current university year is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار السنة الدراسية',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitCurrentUniversityProfileUseCase(
      SubmitCurrentUniversityProfileParams(
        email: onboardingEmail,
        universityName: selectedUniversityName,
        department: selectedDepartmentName,
        universityYear: selectedUniversityYear,
      ),
    );

    result.fold(
      (failure) {
        debugPrint(
          "✗ submitCurrentUniversityProfile failure title: ${failure.title}",
        );
        debugPrint(
          "✗ submitCurrentUniversityProfile failure message: ${failure.message}",
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
        debugPrint(
          "✓ submitCurrentUniversityProfile success: ${response.title}",
        );
        debugPrint("✓ saved universityName: ${response.universityName}");
        debugPrint("✓ saved department: ${response.department}");
        debugPrint("✓ saved universityYear: ${response.universityYear}");

        emit(state.copyWith(isSubmitting: false, clearErrorMessage: true));

        _moveToNextStepLocally();
      },
    );

    debugPrint("=================================================");
  }

  Future<void> _submitGraduateAcademicProfileStep() async {
    debugPrint(
      "============ OnboardingCubit._submitGraduateAcademicProfileStep ============",
    );

    final selectedUniversityName = state.graduatedUniversity?.trim();
    final selectedDepartmentName = state.graduatedDepartment?.trim();
    final certificateImagePath = state.graduationCertificateImagePath?.trim();
    final identityImagePath = state.personalIdentityImagePath?.trim();

    if (selectedUniversityName == null || selectedUniversityName.isEmpty) {
      debugPrint("✗ graduated university is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار الجامعة',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    if (selectedDepartmentName == null || selectedDepartmentName.isEmpty) {
      debugPrint("✗ graduated department is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار القسم',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitGraduateAcademicProfileUseCase(
      SubmitGraduateAcademicProfileParams(
        email: onboardingEmail,
        universityName: selectedUniversityName,
        department: selectedDepartmentName,
        certificateImagePath:
            (certificateImagePath != null && certificateImagePath.isNotEmpty)
            ? certificateImagePath
            : null,
        identityImagePath:
            (identityImagePath != null && identityImagePath.isNotEmpty)
            ? identityImagePath
            : null,
      ),
    );

    result.fold(
      (failure) {
        debugPrint(
          "✗ submitGraduateAcademicProfile failure title: ${failure.title}",
        );
        debugPrint(
          "✗ submitGraduateAcademicProfile failure message: ${failure.message}",
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
        debugPrint(
          "✓ submitGraduateAcademicProfile success: ${response.title}",
        );
        debugPrint("✓ saved universityName: ${response.universityName}");
        debugPrint("✓ saved department: ${response.department}");

        emit(state.copyWith(isSubmitting: false, clearErrorMessage: true));

        _moveToNextStepLocally();
      },
    );

    debugPrint("=================================================");
  }

  Future<void> _submitUserInterestsStep() async {
    debugPrint(
      "============ OnboardingCubit._submitUserInterestsStep ============",
    );

    final selectedIds = List<int>.from(state.selectedInterestIds);

    if (selectedIds.isEmpty) {
      debugPrint("✗ interests list is empty");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يرجى اختيار اهتمام واحد على الأقل',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    if (selectedIds.length > 5) {
      debugPrint("✗ interests list exceeds max count");
      emit(
        state.copyWith(
          isSubmitting: false,
          errorTitle: 'خطأ تحقق !',
          errorMessage: 'يمكن اختيار 5 اهتمامات كحد أقصى',
        ),
      );
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    final result = await submitUserInterestsUseCase(
      SubmitUserInterestsParams(
        email: onboardingEmail,
        interestIds: selectedIds,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ submitUserInterests failure title: ${failure.title}");
        debugPrint("✗ submitUserInterests failure message: ${failure.message}");

        emit(
          state.copyWith(
            isSubmitting: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ submitUserInterests success: ${response.title}");
        debugPrint("✓ saved interestIds: ${response.interestIds}");
        debugPrint("✓ saved interestsCount: ${response.interestsCount}");

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

  ////////////////////////
  ////////////////////////
  ////////////////////////
  ////////////////////////
  ////////////////////////
  // on boarding preview progress
  Future<void> initializeProgressPreviewIfNeeded({
  required int lastCompletedStep,
}) async {
  debugPrint(
    "============ OnboardingCubit.initializeProgressPreviewIfNeeded ============",
  );
  debugPrint("→ lastCompletedStep: $lastCompletedStep");

  if (state.hasInitializedProgressPreview || state.isLoading) {
    debugPrint("✗ progress preview already initialized or loading");
    debugPrint("=================================================");
    return;
  }

  emit(
    state.copyWith(
      isLoading: true,
      hasInitializedProgressPreview: true,
      clearErrorMessage: true,
    ),
  );

  final result = await getOnboardingProgressPreviewUseCase(
    GetOnboardingProgressPreviewParams(
      email: onboardingEmail,
    ),
  );

  result.fold(
    (failure) {
      debugPrint(
        "✗ initializeProgressPreview failure title: ${failure.title}",
      );
      debugPrint(
        "✗ initializeProgressPreview failure message: ${failure.message}",
      );

      emit(
        state.copyWith(
          isLoading: false,
          errorTitle: failure.title,
          errorMessage: failure.message,
        ),
      );
    },
    (response) {
      _applyProgressPreviewResume(
        response: response,
        lastCompletedStep: lastCompletedStep,
      );
    },
  );

  debugPrint("=================================================");
}

void _applyProgressPreviewResume({
  required OnboardingProgressPreviewResponse response,
  required int lastCompletedStep,
}) {
  debugPrint(
    "============ OnboardingCubit._applyProgressPreviewResume ============",
  );

  final previewDiscoverySource = response.discoverySource?.trim();
  final previewEducationLevel = response.educationLevel?.trim();

  final updatedVisibleSteps = _buildVisibleSteps(previewEducationLevel);

  final targetStep = _resolveResumeTargetStep(
    lastCompletedStep: lastCompletedStep,
    educationLevel: previewEducationLevel,
  );

  final targetIndex = updatedVisibleSteps.indexOf(targetStep);
  final safeTargetIndex = targetIndex == -1 ? 0 : targetIndex;

  emit(
    state.copyWith(
      heardAbout: previewDiscoverySource,
      educationLevel: previewEducationLevel,
      visibleSteps: updatedVisibleSteps,
      currentStepIndex: safeTargetIndex,
      isLoading: false,
      clearErrorMessage: true,
    ),
  );

  debugPrint("→ preview discoverySource: $previewDiscoverySource");
  debugPrint("→ preview educationLevel: $previewEducationLevel");
  debugPrint("→ resume targetStep: $targetStep");
  debugPrint("→ resume targetIndex: $safeTargetIndex");
  debugPrint("=================================================");
}

OnboardingStepType _resolveResumeTargetStep({
  required int lastCompletedStep,
  required String? educationLevel,
}) {
  switch (lastCompletedStep) {
    case 0:
      return OnboardingStepType.heardAbout;

    case 1:
      return OnboardingStepType.educationLevel;

    case 2:
      return _resolveStepAfterEducationLevel(educationLevel);

    case 3:
    case 4:
      return OnboardingStepType.interests;

    default:
      return OnboardingStepType.heardAbout;
  }
}

OnboardingStepType _resolveStepAfterEducationLevel(String? educationLevel) {
  switch (educationLevel) {
    case EducationLevelValues.schoolLevel:
      return OnboardingStepType.schoolStage;

    case EducationLevelValues.universityLevel:
      return OnboardingStepType.currentUniversity;

    case EducationLevelValues.mastersLevel:
    case EducationLevelValues.doctorateLevel:
    case EducationLevelValues.graduatedLevel:
      return OnboardingStepType.graduatedUniversity;

    default:
      return OnboardingStepType.educationLevel;
  }
}
}
