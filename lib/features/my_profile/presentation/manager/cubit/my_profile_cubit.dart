import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_academic_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_scientific_interests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_academic_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_personal_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_scientific_interests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/get_my_profile_personal_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/get_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/acadimic_info/my_profile_academic_info_bottom_sheet.dart';
import 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final GetMyProfilePersonalInfoUseCase getMyProfilePersonalInfoUseCase;
  final EditMyProfilePersonalInfoUseCase editMyProfilePersonalInfoUseCase;
  final EditMyProfileAcademicInfoUseCase editMyProfileAcademicInfoUseCase;
  final EditMyProfileScientificInterestsUseCase
  editMyProfileScientificInterestsUseCase;

  MyProfileCubit({
    required this.getMyProfilePersonalInfoUseCase,
    required this.editMyProfilePersonalInfoUseCase,
    required this.editMyProfileAcademicInfoUseCase,
    required this.editMyProfileScientificInterestsUseCase,
  }) : super(const MyProfileState()) {
    debugPrint("============ MyProfileCubit INIT ============");
  }

  Future<void> getMyProfileMock() async {
    debugPrint("============ MyProfileCubit.getMyProfileMock ============");

    emit(
      state.copyWith(
        fetchStatus: FetchMyProfileStatus.loading,
        clearError: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 700));

    const profile = MyProfileEntity(
      userId: 1,
      name: 'محمد هشام منصور',
      email: '360mohamad360@gmail.com',
      phone: '+963 934 000 000',
      governorate: 'دمشق',
      gender: 'ذكر',
      birthDate: '2001-05-20',
      avatarUrl: '',
      coverUrl: '',
      isAcademicallyVerified: true,
      testsCount: '2K',
      followersCount: '500',
      followingCount: '14',
      academicInformation: MyProfileAcademicInformationEntity(
        educationLevel: 'جامعة',
        universityName: 'جامعة دمشق',
        department: 'الهندسة المعلوماتية',
        universityYear: 'السنة الخامسة',
        schoolStage: null,
      ),
      scientificInterests: [
        MyProfileScientificInterestEntity(id: 1, name: 'علوم الحاسوب'),
        MyProfileScientificInterestEntity(id: 2, name: 'برمجة'),
        MyProfileScientificInterestEntity(id: 3, name: 'الذكاء الاصطناعي'),
        MyProfileScientificInterestEntity(
          id: 4,
          name: 'هندسة البيانات والتحكم',
        ),
      ],
    );
    emit(
      state.copyWith(
        fetchStatus: FetchMyProfileStatus.success,
        profile: profile,
        editableProfile: profile,
        clearError: true,
      ),
    );

    debugPrint("✓ my profile mock loaded");
    debugPrint("=================================================");
  }

  void changeSelectedTab(MyProfileTab tab) {
    debugPrint("============ MyProfileCubit.changeSelectedTab ============");
    debugPrint("→ selected tab: $tab");

    emit(state.copyWith(selectedTab: tab));

    debugPrint("=================================================");
  }

  void updateName(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(name: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updatePhone(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(phone: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updateGovernorate(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(governorate: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updateGender(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(gender: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updateBirthDate(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(birthDate: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updateAvatarUrl(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(avatarUrl: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  void updateCoverUrl(String value) {
    final current = state.editableProfile;
    if (current == null) return;

    emit(
      state.copyWith(
        editableProfile: current.copyWith(coverUrl: value),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  // Future<void> saveChangesMock() async {
  //   debugPrint("============ MyProfileCubit.saveChangesMock ============");
  //   if (!state.hasChanges) {
  //     debugPrint("✗ no changes to save");
  //     debugPrint("=================================================");
  //     return;
  //   }
  //   final edited = state.editableProfile;
  //   if (edited == null) return;
  //   emit(
  //     state.copyWith(
  //       updateStatus: UpdateMyProfileStatus.loading,
  //       clearError: true,
  //     ),
  //   );
  //   await Future.delayed(const Duration(milliseconds: 800));
  //   emit(
  //     state.copyWith(
  //       updateStatus: UpdateMyProfileStatus.success,
  //       profile: edited,
  //       editableProfile: edited,
  //       clearError: true,
  //     ),
  //   );
  //   debugPrint("✓ profile changes saved locally");
  //   debugPrint("=================================================");
  // }

  void resetUpdateState() {
    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.initial,
        clearError: true,
      ),
    );
  }

  // void updateAcademicInformation(
  //   MyProfileAcademicInformationEntity academicInformation,
  // ) {
  //   final current = state.editableProfile;
  //   if (current == null) return;

  //   emit(
  //     state.copyWith(
  //       editableProfile: current.copyWith(
  //         academicInformation: academicInformation,
  //       ),
  //       updateStatus: UpdateMyProfileStatus.initial,
  //     ),
  //   );
  // }

  void updateScientificInterests(List<InterestItemEntity> interests) {
    final current = state.editableProfile;
    if (current == null) return;

    final mappedInterests = interests.map((item) {
      return MyProfileScientificInterestEntity(id: item.id, name: item.name);
    }).toList();

    emit(
      state.copyWith(
        editableProfile: current.copyWith(scientificInterests: mappedInterests),
        updateStatus: UpdateMyProfileStatus.initial,
      ),
    );
  }

  ////////////////////// APIs /////////////////////
  ////////////////////// APIs /////////////////////
  ////////////////////// APIs /////////////////////
  Future<void> getMyProfilePersonalInfo({required int userId}) async {
    debugPrint(
      "============ MyProfileCubit.getMyProfilePersonalInfo ============",
    );
    debugPrint("→ params: {userId: $userId}");

    emit(
      state.copyWith(
        fetchStatus: FetchMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await getMyProfilePersonalInfoUseCase(
      GetMyProfilePersonalInfoParams(userId: userId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ getMyProfilePersonalInfo failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            fetchStatus: FetchMyProfileStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ getMyProfilePersonalInfo success");

        emit(
          state.copyWith(
            fetchStatus: FetchMyProfileStatus.success,
            profile: response,
            editableProfile: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> savePersonalInfoChanges() async {
    debugPrint(
      "============ MyProfileCubit.savePersonalInfoChanges ============",
    );

    final original = state.profile;
    final edited = state.editableProfile;

    if (original == null || edited == null) {
      debugPrint("✗ profile or editableProfile is null");
      debugPrint("=================================================");
      return;
    }

    final changedFields = _buildChangedBasicInfoFields(
      original: original,
      edited: edited,
    );

    if (changedFields.isEmpty) {
      debugPrint("✗ no changed basic info fields");
      debugPrint("=================================================");
      return;
    }

    final validationMessage = _validateBasicInfoFields(changedFields);

    if (validationMessage != null) {
      emit(
        state.copyWith(
          updateStatus: UpdateMyProfileStatus.failure,
          errorTitle: "تنبيه",
          errorMessage: validationMessage,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await editMyProfilePersonalInfoUseCase(
      EditMyProfilePersonalInfoParams(
        userId: edited.userId,
        changedFields: changedFields,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ savePersonalInfoChanges failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ savePersonalInfoChanges success");
        debugPrint("→ message: ${response.message}");

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.success,
            profile: edited,
            editableProfile: edited,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Map<String, dynamic> _buildChangedBasicInfoFields({
    required MyProfileEntity original,
    required MyProfileEntity edited,
  }) {
    final fields = <String, dynamic>{};

    if (original.name.trim() != edited.name.trim()) {
      fields['name'] = edited.name.trim();
    }

    if (original.governorate.trim() != edited.governorate.trim()) {
      fields['governorate'] = edited.governorate.trim();
    }

    if (original.phone.trim() != edited.phone.trim()) {
      fields['phone'] = edited.phone.trim();
    }

    if (original.birthDate.trim() != edited.birthDate.trim()) {
      fields['birth_date'] = edited.birthDate.trim();
    }

    if (original.gender.trim() != edited.gender.trim()) {
      fields['gender'] = edited.gender.trim();
    }

    debugPrint("→ changed basic fields: $fields");

    return fields;
  }

  String? _validateBasicInfoFields(Map<String, dynamic> fields) {
    if (fields.containsKey('name')) {
      final name = fields['name']?.toString().trim() ?? '';

      if (name.isEmpty) {
        return 'الاسم لا يمكن أن يكون فارغًا';
      }

      final arabicNameRegex = RegExp(r'^[\u0600-\u06FF\s]+$');

      if (!arabicNameRegex.hasMatch(name)) {
        return 'الاسم يجب أن يكون باللغة العربية فقط';
      }
    }

    if (fields.containsKey('phone')) {
      final phone = fields['phone']?.toString().trim() ?? '';

      if (phone.isNotEmpty) {
        final phoneRegex = RegExp(r'^09\d{8}$');

        if (!phoneRegex.hasMatch(phone)) {
          return 'رقم الهاتف يجب أن يبدأ بـ 09 ويتألف من 10 أرقام';
        }
      }
    }

    if (fields.containsKey('birth_date')) {
      final birthDate = fields['birth_date']?.toString().trim() ?? '';

      if (birthDate.isNotEmpty) {
        final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

        if (!dateRegex.hasMatch(birthDate)) {
          return 'تاريخ الميلاد يجب أن يكون بالشكل yyyy-MM-dd';
        }
      }
    }
    return null;
  }

  Future<bool> saveAcademicInfoChanges(
    MyProfileAcademicInformationEntity newAcademicInfo,
  ) async {
    debugPrint(
      "============ MyProfileCubit.saveAcademicInfoChanges ============",
    );

    final original = state.profile;

    if (original == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return false;
    }

    final data = _buildAcademicInfoBody(edited: newAcademicInfo);

    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await editMyProfileAcademicInfoUseCase(
      EditMyProfileAcademicInfoParams(userId: original.userId, data: data),
    );

    final success = result.fold(
      (failure) {
        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (response) {
        final updatedProfile = original.copyWith(
          academicInformation: newAcademicInfo,
        );

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.success,
            profile: updatedProfile,
            editableProfile: updatedProfile,
            clearError: true,
          ),
        );
        return true;
      },
    );

    debugPrint("→ success: $success");
    debugPrint("=================================================");

    return success;
  }

  Map<String, dynamic> _buildAcademicInfoBody({
    required MyProfileAcademicInformationEntity edited,
  }) {
    final data = <String, dynamic>{};

    final level = edited.educationLevel.trim();

    data['education_level'] = level;

    if (level == AcademicLevelRules.school) {
      data['school_stage'] = edited.schoolStage?.trim() ?? '';
    }

    if (level == AcademicLevelRules.university) {
      data['university_name'] = edited.universityName.trim();
      data['department'] = edited.department.trim();

      final yearText = edited.universityYear?.trim() ?? '';
      data['university_year'] = int.tryParse(yearText) ?? yearText;
    }

    if (AcademicLevelRules.isGraduateLevel(level)) {
      data['university_name'] = edited.universityName.trim();
      data['department'] = edited.department.trim();
    }

    debugPrint("→ academic info body: $data");

    return data;
  }

  Future<bool> saveScientificInterestsChanges(
    List<InterestItemEntity> selectedInterests,
  ) async {
    debugPrint(
      "============ MyProfileCubit.saveScientificInterestsChanges ============",
    );

    final original = state.profile;

    if (original == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return false;
    }

    final selectedIds = selectedInterests.map((item) => item.id).toList();

    debugPrint("→ selectedIds: $selectedIds");

    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await editMyProfileScientificInterestsUseCase(
      EditMyProfileScientificInterestsParams(
        userId: original.userId,
        interestIds: selectedIds,
      ),
    );

    final success = result.fold(
      (failure) {
        debugPrint("✗ saveScientificInterestsChanges failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );

        return false;
      },
      (response) {
        debugPrint("✓ saveScientificInterestsChanges success");
        debugPrint("→ message: ${response.message}");

        final updatedInterests = selectedInterests.map((item) {
          return MyProfileScientificInterestEntity(
            id: item.id,
            name: item.name,
          );
        }).toList();

        final updatedProfile = original.copyWith(
          scientificInterests: updatedInterests,
        );

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.success,
            profile: updatedProfile,
            editableProfile: updatedProfile,
            clearError: true,
          ),
        );

        return true;
      },
    );

    debugPrint("→ success: $success");
    debugPrint("=================================================");

    return success;
  }
}
