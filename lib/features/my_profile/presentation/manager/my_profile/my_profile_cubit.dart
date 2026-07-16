import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/delete_my_profile_folder_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/delete_my_profile_picture_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_academic_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_picture_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_scientific_interests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_%5Bicker_search_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_folder_content_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_folders_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_library_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_picker_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/filter_my_profile_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/delete_my_profile_folder_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/delete_my_profile_picture_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_academic_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_personal_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_picture_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/edit_my_profile_scientific_interests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_folder_content_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_folders_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_library_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_search_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/filter_my_profile_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/get_my_profile_personal_info_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/get_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/search_my_profile_library_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/search_my_profile_library_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/acadimic_info/my_profile_academic_info_bottom_sheet.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_share_link_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_share_link_params.dart';
import 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final GetMyProfilePersonalInfoUseCase getMyProfilePersonalInfoUseCase;
  final EditMyProfilePersonalInfoUseCase editMyProfilePersonalInfoUseCase;
  final EditMyProfileAcademicInfoUseCase editMyProfileAcademicInfoUseCase;
  final EditMyProfileScientificInterestsUseCase
  editMyProfileScientificInterestsUseCase;
  final EditMyProfilePictureUseCase editMyProfilePictureUseCase;
  final DeleteMyProfilePictureUseCase deleteMyProfilePictureUseCase;

  final FetchMyProfileLibraryUseCase fetchMyProfileLibraryUseCase;

  final SearchMyProfileLibraryUseCase searchMyProfileLibraryUseCase;
  Timer? _librarySearchDebounce;

  final FetchMyProfileFoldersUseCase fetchMyProfileFoldersUseCase;

  final FetchMyProfileFolderContentUseCase fetchMyProfileFolderContentUseCase;

  final DeleteMyProfileFolderUseCase deleteMyProfileFolderUseCase;

  final FetchMyProfilePickerTestsUseCase fetchMyProfileTestsUseCase;
  final FetchMyProfilePickerSearchTestsUseCase searchMyProfileTestsUseCase;
  Timer? _testsSearchDebounce;

  final FilterMyProfileTestsUseCase filterMyProfileTestsUseCase;
  final GetAllInterestsUseCase getAllInterestsUseCase;
  bool _isFetchingFilteredTestsMore = false;

  final GetOtherProfileShareLinkUseCase getMyProfileShareLinkUseCase;

  MyProfileCubit({
    required this.getMyProfilePersonalInfoUseCase,
    required this.editMyProfilePersonalInfoUseCase,
    required this.editMyProfileAcademicInfoUseCase,
    required this.editMyProfileScientificInterestsUseCase,
    required this.editMyProfilePictureUseCase,
    required this.deleteMyProfilePictureUseCase,

    required this.fetchMyProfileLibraryUseCase,
    required this.searchMyProfileLibraryUseCase,

    required this.fetchMyProfileFoldersUseCase,
    required this.fetchMyProfileFolderContentUseCase,
    required this.deleteMyProfileFolderUseCase,
    required this.searchMyProfileTestsUseCase,
    required this.fetchMyProfileTestsUseCase,

    required this.filterMyProfileTestsUseCase,
    required this.getAllInterestsUseCase,

    required this.getMyProfileShareLinkUseCase,
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

  Future<void> changeSelectedTab(MyProfileTab tab) async {
    if (state.selectedTab == tab) return;

    debugPrint("============ MyProfileCubit.changeSelectedTab ============");
    debugPrint("→ selected tab: $tab");

    emit(state.copyWith(selectedTab: tab, clearError: true));

    switch (tab) {
      case MyProfileTab.content:
        final shouldFetchContent =
            state.libraryStatus == FetchMyProfileStatus.initial &&
            state.libraryResponse == null;

        if (shouldFetchContent) {
          await fetchMyProfileLibraryInitial();
        }
        break;

      case MyProfileTab.folders:
        final shouldFetchFolders =
            state.foldersStatus == FetchMyProfileStatus.initial &&
            state.foldersResponse == null;

        if (shouldFetchFolders) {
          await fetchMyProfileFoldersInitial();
        }
        break;

      case MyProfileTab.tests:
        final shouldFetchTests =
            state.testsStatus == MyProfileTestsStatus.initial &&
            state.testsResponse == null;

        if (shouldFetchTests) {
          await fetchMyProfileTestsInitial();
        }
        break;

      case MyProfileTab.personalInfo:
        //case MyProfileTab.achievements:
        break;
    }

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

  Future<bool> editMyProfilePicture({
    required String type,
    required String imagePath,
  }) async {
    debugPrint("============ MyProfileCubit.editMyProfilePicture ============");
    debugPrint("→ type: $type");
    debugPrint("→ imagePath: $imagePath");

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return false;
    }

    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await editMyProfilePictureUseCase(
      EditMyProfilePictureParams(
        userId: profile.userId,
        type: type,
        imagePath: imagePath,
      ),
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
        final updatedProfile = type == 'avatar'
            ? profile.copyWith(avatarUrl: imagePath)
            : profile.copyWith(coverUrl: imagePath);

        emit(
          state.copyWith(
            updateStatus: UpdateMyProfileStatus.success,
            profile: updatedProfile,
            editableProfile: updatedProfile,
            clearError: true,
          ),
        );

        getMyProfilePersonalInfo(userId: profile.userId);

        return true;
      },
    );

    debugPrint("→ success: $success");
    debugPrint("=================================================");

    return success;
  }

  Future<bool> deleteMyProfilePicture({required String type}) async {
    debugPrint(
      "============ MyProfileCubit.deleteMyProfilePicture ============",
    );
    debugPrint("→ type: $type");

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return false;
    }

    emit(
      state.copyWith(
        updateStatus: UpdateMyProfileStatus.loading,
        clearError: true,
      ),
    );

    final result = await deleteMyProfilePictureUseCase(
      DeleteMyProfilePictureParams(userId: profile.userId, type: type),
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
        final defaultUrl = response.defaultPhotoUrl;

        final updatedProfile = type == 'avatar'
            ? profile.copyWith(avatarUrl: defaultUrl)
            : profile.copyWith(coverUrl: defaultUrl);

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
  ////////////////// content tab //////////////////

  Future<void> changeMyProfileLibraryTab(MyProfileLibraryTab tab) async {
    if (state.selectedLibraryTab == tab) return;

    clearMyProfileLibrarySearch();

    debugPrint(
      "============ MyProfileCubit.changeMyProfileLibraryTab ============",
    );
    debugPrint("→ from: ${state.selectedLibraryTab.apiValue}");
    debugPrint("→ to: ${tab.apiValue}");

    emit(
      state.copyWith(
        selectedLibraryTab: tab,
        libraryStatus: FetchMyProfileStatus.loading,
        isLibraryLoadingMore: false,
        libraryResponse: null,
        librarySearchText: '',
        clearError: true,
      ),
    );

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return;
    }

    final result = await fetchMyProfileLibraryUseCase(
      FetchMyProfileLibraryParams(userId: profile.userId, tab: tab.apiValue),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.failure,
            isLibraryLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.success,
            libraryResponse: response,
            isLibraryLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMyProfileLibraryInitial() async {
    debugPrint(
      "============ MyProfileCubit.fetchMyProfileLibraryInitial ============",
    );

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        libraryStatus: FetchMyProfileStatus.loading,
        isLibraryLoadingMore: false,
        libraryResponse: null,
        librarySearchText: '',
        clearError: true,
      ),
    );

    final result = await fetchMyProfileLibraryUseCase(
      FetchMyProfileLibraryParams(
        userId: profile.userId,
        tab: state.selectedLibraryTab.apiValue,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.failure,
            isLibraryLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.success,
            isLibraryLoadingMore: false,
            libraryResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileLibraryIfNeeded() async {
    final response = state.libraryResponse;
    final meta = response?.meta;

    if (state.isLibraryLoading ||
        state.isLibraryLoadingMore ||
        response == null ||
        meta == null ||
        !meta.hasMorePages) {
      return;
    }

    final profile = state.profile;
    if (profile == null) return;

    final cursor = meta.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) return;

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileLibraryIfNeeded ============",
    );
    debugPrint("→ tab: ${state.selectedLibraryTab.apiValue}");
    debugPrint("→ cursor: $cursor");

    emit(state.copyWith(isLibraryLoadingMore: true, clearError: true));

    final result = await fetchMyProfileLibraryUseCase(
      FetchMyProfileLibraryParams(
        userId: profile.userId,
        tab: state.selectedLibraryTab.apiValue,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLibraryLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfileLibraryEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        emit(
          state.copyWith(
            isLibraryLoadingMore: false,
            libraryResponse: updatedResponse,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void changeMyProfileLibrarySearchText(String value) {
    final query = value.trim();

    emit(state.copyWith(librarySearchText: value, clearError: true));

    _librarySearchDebounce?.cancel();

    _librarySearchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (query.isEmpty) {
        fetchMyProfileLibraryInitial();
        return;
      }

      _searchMyProfileLibraryInitial(query: query);
    });
  }

  Future<void> _searchMyProfileLibraryInitial({required String query}) async {
    debugPrint(
      "============ MyProfileCubit._searchMyProfileLibraryInitial ============",
    );
    debugPrint("→ query: $query");

    emit(
      state.copyWith(
        libraryStatus: FetchMyProfileStatus.loading,
        isLibraryLoadingMore: false,
        libraryResponse: null,
        clearError: true,
      ),
    );

    final result = await searchMyProfileLibraryUseCase(
      SearchMyProfileLibraryParams(query: query, mode: 'user_owned'),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.failure,
            isLibraryLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            libraryStatus: FetchMyProfileStatus.success,
            isLibraryLoadingMore: false,
            libraryResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileLibrarySearchIfNeeded() async {
    final query = state.librarySearchText.trim();
    if (query.isEmpty) return;

    final response = state.libraryResponse;

    if (state.isLibraryLoading ||
        state.isLibraryLoadingMore ||
        response == null ||
        !response.meta.hasMorePages) {
      return;
    }

    final cursor = response.meta.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) return;

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileLibrarySearchIfNeeded ============",
    );
    debugPrint("→ query: $query");
    debugPrint("→ cursor: $cursor");

    emit(state.copyWith(isLibraryLoadingMore: true, clearError: true));

    final result = await searchMyProfileLibraryUseCase(
      SearchMyProfileLibraryParams(
        query: query,
        mode: 'user_owned',
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLibraryLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfileLibraryEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        emit(
          state.copyWith(
            isLibraryLoadingMore: false,
            libraryResponse: updatedResponse,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void clearMyProfileLibrarySearch() {
    _librarySearchDebounce?.cancel();

    emit(state.copyWith(librarySearchText: '', clearError: true));

    fetchMyProfileLibraryInitial();
  }

  Future<void> refreshMyProfileLibrary() async {
    await fetchMyProfileLibraryInitial();
  }

  ///////////////////////// folder Api /////////////////
  Future<void> changeMyProfileFoldersTab(MyProfileFoldersTabEnum tab) async {
    if (state.selectedFoldersTab == tab) return;

    debugPrint(
      "============ MyProfileCubit.changeMyProfileFoldersTab ============",
    );
    debugPrint("→ from: ${state.selectedFoldersTab.apiValue}");
    debugPrint("→ to: ${tab.apiValue}");

    emit(
      state.copyWith(
        selectedFoldersTab: tab,
        foldersStatus: FetchMyProfileStatus.loading,
        isFoldersLoadingMore: false,
        clearFoldersResponse: true,
        clearError: true,
      ),
    );

    await fetchMyProfileFoldersInitial();

    debugPrint("=================================================");
  }

  Future<void> fetchMyProfileFoldersInitial() async {
    debugPrint(
      "============ MyProfileCubit.fetchMyProfileFoldersInitial ============",
    );

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        foldersStatus: FetchMyProfileStatus.loading,
        isFoldersLoadingMore: false,
        clearFoldersResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfileFoldersUseCase(
      FetchMyProfileFoldersParams(
        userId: profile.userId,
        tab: state.selectedFoldersTab.apiValue,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMyProfileFoldersInitial failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            foldersStatus: FetchMyProfileStatus.failure,
            isFoldersLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ fetchMyProfileFoldersInitial success");
        debugPrint("→ items count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            foldersStatus: FetchMyProfileStatus.success,
            foldersResponse: response,
            isFoldersLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileFoldersIfNeeded() async {
    final response = state.foldersResponse;

    if (state.isFoldersLoading ||
        state.isFoldersLoadingMore ||
        response == null ||
        !response.meta.hasMorePages) {
      return;
    }

    final profile = state.profile;
    if (profile == null) return;

    final cursor = response.meta.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) return;

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileFoldersIfNeeded ============",
    );
    debugPrint("→ tab: ${state.selectedFoldersTab.apiValue}");
    debugPrint("→ cursor: $cursor");

    emit(state.copyWith(isFoldersLoadingMore: true, clearError: true));

    final result = await fetchMyProfileFoldersUseCase(
      FetchMyProfileFoldersParams(
        userId: profile.userId,
        tab: state.selectedFoldersTab.apiValue,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMoreMyProfileFoldersIfNeeded failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            isFoldersLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfileFoldersEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        debugPrint("✓ fetchMoreMyProfileFoldersIfNeeded success");
        debugPrint("→ old count: ${response.data.length}");
        debugPrint("→ new count: ${newResponse.data.length}");
        debugPrint("→ total count: ${updatedResponse.data.length}");
        debugPrint("→ hasMorePages: ${newResponse.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${newResponse.meta.nextCursor}");

        emit(
          state.copyWith(
            isFoldersLoadingMore: false,
            foldersResponse: updatedResponse,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMyProfileFolderContent({required int folderId}) async {
    debugPrint(
      "============ MyProfileCubit.fetchMyProfileFolderContent ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    if (state.isFolderContentLoading &&
        state.activeFolderContentId == folderId) {
      debugPrint("✗ folder content already loading for same folder");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        folderContentStatus: FetchMyProfileFolderContentStatus.loading,
        activeFolderContentId: folderId,
        clearFolderContentResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfileFolderContentUseCase(
      FetchMyProfileFolderContentParams(folderId: folderId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMyProfileFolderContent failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            folderContentStatus: FetchMyProfileFolderContentStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ fetchMyProfileFolderContent success");
        debugPrint("→ tests count: ${response.data.length}");

        emit(
          state.copyWith(
            folderContentStatus: FetchMyProfileFolderContentStatus.success,
            folderContentResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetMyProfileFolderContentState() {
    emit(
      state.copyWith(
        folderContentStatus: FetchMyProfileFolderContentStatus.initial,
        clearFolderContentResponse: true,
        clearActiveFolderContentId: true,
        clearError: true,
      ),
    );
  }

  Future<void> deleteMyProfileFolder({required int folderId}) async {
    debugPrint(
      "============ MyProfileCubit.deleteMyProfileFolder ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    if (state.isDeleteFolderLoading) {
      debugPrint("✗ another folder delete action is already loading");
      debugPrint("=================================================");
      return;
    }

    final currentResponse = state.foldersResponse;

    if (currentResponse == null) {
      debugPrint("✗ foldersResponse is null");
      debugPrint("=================================================");
      return;
    }

    final folderExists = currentResponse.data.any(
      (folder) => folder.id == folderId,
    );

    if (!folderExists) {
      debugPrint("✗ folder does not exist locally");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        deleteFolderStatus: DeleteMyProfileFolderStatus.loading,
        activeDeletingFolderId: folderId,
        clearFolderActionMessage: true,
        clearError: true,
      ),
    );

    final result = await deleteMyProfileFolderUseCase(
      DeleteMyProfileFolderParams(folderId: folderId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ deleteMyProfileFolder failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            deleteFolderStatus: DeleteMyProfileFolderStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveDeletingFolderId: true,
            clearFolderActionMessage: true,
          ),
        );
      },
      (response) {
        final updatedFolders = currentResponse.data
            .where((folder) => folder.id != folderId)
            .toList();

        final updatedResponse = MyProfileFoldersEntity(
          success: currentResponse.success,
          message: currentResponse.message,
          data: updatedFolders,
          meta: currentResponse.meta,
          statusCode: currentResponse.statusCode,
        );

        debugPrint("✓ deleteMyProfileFolder success");
        debugPrint("→ deleted folder id: $folderId");
        debugPrint(
          "→ folders count: ${currentResponse.data.length} "
          "→ ${updatedFolders.length}",
        );

        emit(
          state.copyWith(
            deleteFolderStatus: DeleteMyProfileFolderStatus.success,
            foldersResponse: updatedResponse,
            folderActionMessage: response.message.isNotEmpty
                ? response.message
                : 'تم حذف المجلد بنجاح',
            clearActiveDeletingFolderId: true,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetDeleteMyProfileFolderState() {
    emit(
      state.copyWith(
        deleteFolderStatus: DeleteMyProfileFolderStatus.initial,
        clearActiveDeletingFolderId: true,
        clearFolderActionMessage: true,
        clearError: true,
      ),
    );
  }

  /////////////////////////// TEST tab //////////////////////////
  /////////////////////////// TEST tab //////////////////////////
  /////////////////////////// TEST tab //////////////////////////
  /////////////////////////// TEST tab //////////////////////////
  /////////////////////////// TEST tab /////////////////////////

  Future<void> fetchMyProfileTestsInitial() async {
    debugPrint(
      "============ MyProfileCubit.fetchMyProfileTestsInitial ============",
    );

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return;
    }

    debugPrint(
      "→ params: "
      "{userId: ${profile.userId}, "
      "tab: ${state.selectedTestsTab.name}}",
    );

    emit(
      state.copyWith(
        testsStatus: MyProfileTestsStatus.loading,
        testsLoadMoreStatus: MyProfileTestsLoadMoreStatus.initial,
        clearTestsResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfileTestsUseCase(
      FetchMyProfilePickerTestsParams(
        userId: profile.userId,
        tab: state.selectedTestsTab.name,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMyProfileTestsInitial failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            testsStatus: MyProfileTestsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ fetchMyProfileTestsInitial success");
        debugPrint("→ tests count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            testsStatus: MyProfileTestsStatus.success,
            testsResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> changeMyProfileTestsTab(MyProfilePickerTestsTab tab) async {
    if (state.selectedTestsTab == tab) return;

    debugPrint(
      "============ MyProfileCubit.changeMyProfileTestsTab ============",
    );
    debugPrint("→ from: ${state.selectedTestsTab.apiValue}");
    debugPrint("→ to: ${tab.apiValue}");

    _testsSearchDebounce?.cancel();

    emit(
      state.copyWith(
        selectedTestsTab: tab,

        testsSearchQuery: '',
        testsSearchStatus: MyProfileTestsSearchStatus.initial,
        testsSearchLoadMoreStatus: MyProfileTestsSearchLoadMoreStatus.initial,
        clearTestsSearchResponse: true,
        testsSearchPage: 1,
        testsSearchHasMorePages: true,

        testsStatus: MyProfileTestsStatus.loading,
        testsLoadMoreStatus: MyProfileTestsLoadMoreStatus.initial,
        clearTestsResponse: true,

        clearError: true,
        isTestsFilterMode: false,
        testsFilterStatus: MyProfileTestsFilterStatus.initial,
        testsFilterLoadMoreStatus: MyProfileTestsFilterLoadMoreStatus.initial,
        clearFilteredTestsResponse: true,
        clearActiveTestsFilterParams: true,
      ),
    );

    await fetchMyProfileTestsInitial();

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileTestsIfNeeded() async {
    final response = state.testsResponse;

    if (state.isTestsLoading ||
        state.isTestsLoadingMore ||
        response == null ||
        !response.meta.hasMorePages) {
      return;
    }

    final profile = state.profile;
    if (profile == null) return;

    final cursor = response.meta.nextCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileTestsIfNeeded ============",
    );
    debugPrint("→ tab: ${state.selectedTestsTab.apiValue}");
    debugPrint("→ cursor: $cursor");

    emit(
      state.copyWith(
        testsLoadMoreStatus: MyProfileTestsLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchMyProfileTestsUseCase(
      FetchMyProfilePickerTestsParams(
        userId: profile.userId,
        tab: state.selectedTestsTab.apiValue,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMoreMyProfileTestsIfNeeded failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            testsLoadMoreStatus: MyProfileTestsLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfilePickerTestsEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        debugPrint("✓ fetchMoreMyProfileTestsIfNeeded success");
        debugPrint("→ old count: ${response.data.length}");
        debugPrint("→ new count: ${newResponse.data.length}");
        debugPrint("→ total count: ${updatedResponse.data.length}");

        emit(
          state.copyWith(
            testsLoadMoreStatus: MyProfileTestsLoadMoreStatus.success,
            testsResponse: updatedResponse,
            clearError: true,

            isTestsFilterMode: false,

            testsFilterStatus: MyProfileTestsFilterStatus.initial,

            testsFilterLoadMoreStatus:
                MyProfileTestsFilterLoadMoreStatus.initial,

            clearFilteredTestsResponse: true,
            clearActiveTestsFilterParams: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void changeMyProfileTestsSearchQuery(String value) {
    if (state.isTestsFilterMode) {
      clearMyProfileTestsFilter();
    }
    final query = value.trim();

    emit(state.copyWith(testsSearchQuery: value, clearError: true));

    _testsSearchDebounce?.cancel();

    _testsSearchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (query.isEmpty) {
        clearMyProfileTestsSearch();
        return;
      }

      searchMyProfileTestsInitial(query: query);
    });
  }

  Future<void> searchMyProfileTestsInitial({required String query}) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) return;

    debugPrint(
      "============ MyProfileCubit.searchMyProfileTestsInitial ============",
    );
    debugPrint("→ query: $cleanQuery");
    debugPrint("→ page: 1");

    emit(
      state.copyWith(
        testsSearchStatus: MyProfileTestsSearchStatus.loading,
        testsSearchLoadMoreStatus: MyProfileTestsSearchLoadMoreStatus.initial,
        clearTestsSearchResponse: true,
        testsSearchPage: 1,
        testsSearchHasMorePages: true,
        clearError: true,
      ),
    );

    final result = await searchMyProfileTestsUseCase(
      FetchMyProfilePickerSearchTestsParams(query: cleanQuery, page: 1),
    );

    result.fold(
      (failure) {
        debugPrint("✗ searchMyProfileTestsInitial failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            testsSearchStatus: MyProfileTestsSearchStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ searchMyProfileTestsInitial success");
        debugPrint("→ count: ${response.data.length}");

        emit(
          state.copyWith(
            testsSearchStatus: MyProfileTestsSearchStatus.success,
            testsSearchResponse: response,
            testsSearchPage: 1,

            testsSearchHasMorePages: response.data.isNotEmpty,

            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileTestsSearchIfNeeded() async {
    final query = state.testsSearchQuery.trim();
    final currentResponse = state.testsSearchResponse;

    if (query.isEmpty ||
        state.isTestsSearchLoading ||
        state.isTestsSearchLoadingMore ||
        currentResponse == null ||
        !state.testsSearchHasMorePages) {
      return;
    }

    final nextPage = state.testsSearchPage + 1;

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileTestsSearchIfNeeded ============",
    );
    debugPrint("→ query: $query");
    debugPrint("→ page: $nextPage");

    emit(
      state.copyWith(
        testsSearchLoadMoreStatus: MyProfileTestsSearchLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await searchMyProfileTestsUseCase(
      FetchMyProfilePickerSearchTestsParams(query: query, page: nextPage),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMoreMyProfileTestsSearchIfNeeded failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            testsSearchLoadMoreStatus:
                MyProfileTestsSearchLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final existingIds = currentResponse.data.map((test) => test.id).toSet();

        final uniqueNewTests = newResponse.data
            .where((test) => !existingIds.contains(test.id))
            .toList();

        final updatedResponse = MyProfilePickerSearchTestsEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...currentResponse.data, ...uniqueNewTests],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        final hasMorePages = newResponse.data.isNotEmpty;

        debugPrint("✓ fetchMoreMyProfileTestsSearchIfNeeded success");
        debugPrint("→ received count: ${newResponse.data.length}");
        debugPrint("→ unique count: ${uniqueNewTests.length}");
        debugPrint("→ page: $nextPage");
        debugPrint("→ hasMorePages: $hasMorePages");

        emit(
          state.copyWith(
            testsSearchLoadMoreStatus:
                MyProfileTestsSearchLoadMoreStatus.success,
            testsSearchResponse: updatedResponse,
            testsSearchPage: nextPage,
            testsSearchHasMorePages: hasMorePages,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void clearMyProfileTestsSearch() {
    _testsSearchDebounce?.cancel();

    emit(
      state.copyWith(
        testsSearchQuery: '',
        testsSearchStatus: MyProfileTestsSearchStatus.initial,
        testsSearchLoadMoreStatus: MyProfileTestsSearchLoadMoreStatus.initial,
        clearTestsSearchResponse: true,
        testsSearchPage: 1,
        testsSearchHasMorePages: true,
        clearError: true,
      ),
    );
  }

  ////////////////// filter /////////////////////
  ////////////////// filter /////////////////////
  ////////////////// filter /////////////////////
  Future<void> getMyProfileTestsFilterInterests() async {
    if (state.isTestsFilterInterestsLoading) {
      return;
    }

    if (state.testsFilterInterestCategories.isNotEmpty) {
      return;
    }

    debugPrint(
      "============ MyProfileCubit.getMyProfileTestsFilterInterests ============",
    );

    emit(
      state.copyWith(
        isTestsFilterInterestsLoading: true,
        clearTestsFilterInterestsError: true,
      ),
    );

    try {
      final response = await getAllInterestsUseCase();

      debugPrint("✓ getMyProfileTestsFilterInterests success");
      debugPrint("→ categories count: ${response.categories.length}");

      emit(
        state.copyWith(
          isTestsFilterInterestsLoading: false,
          testsFilterInterestCategories: response.categories,
          clearTestsFilterInterestsError: true,
        ),
      );
    } catch (e) {
      debugPrint("✗ getMyProfileTestsFilterInterests error: $e");

      emit(
        state.copyWith(
          isTestsFilterInterestsLoading: false,
          testsFilterInterestsError: e.toString(),
        ),
      );
    }

    debugPrint("=================================================");
  }

  Future<void> applyMyProfileTestsFilter(
    FilterMyProfileTestsParams params,
  ) async {
    debugPrint(
      "============ MyProfileCubit.applyMyProfileTestsFilter ============",
    );
    debugPrint("→ query: ${params.toQueryParameters()}");

    if (state.isTestsFilterLoading) {
      debugPrint("✗ tests filter already loading");
      debugPrint("=================================================");
      return;
    }

    if (!params.hasAnyFilter) {
      debugPrint("✗ no filter value selected");
      debugPrint("=================================================");
      return;
    }

    _testsSearchDebounce?.cancel();

    emit(
      state.copyWith(
        isTestsFilterMode: true,

        testsFilterStatus: MyProfileTestsFilterStatus.loading,

        testsFilterLoadMoreStatus: MyProfileTestsFilterLoadMoreStatus.initial,

        clearFilteredTestsResponse: true,

        activeTestsFilterParams: params,

        testsSearchQuery: '',
        testsSearchStatus: MyProfileTestsSearchStatus.initial,
        testsSearchLoadMoreStatus: MyProfileTestsSearchLoadMoreStatus.initial,
        clearTestsSearchResponse: true,
        testsSearchPage: 1,
        testsSearchHasMorePages: true,

        clearError: true,
      ),
    );

    final result = await filterMyProfileTestsUseCase(params);

    result.fold(
      (failure) {
        debugPrint("✗ applyMyProfileTestsFilter failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            testsFilterStatus: MyProfileTestsFilterStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint('✓ applyMyProfileTestsFilter success');
        debugPrint('→ response count: ${response.data.length}');

        emit(
          state.copyWith(
            isTestsFilterMode: true,
            testsFilterStatus: MyProfileTestsFilterStatus.success,
            filteredTestsResponse: response,
            clearFilteredTestsResponse: false,
            clearError: true,
          ),
        );

        debugPrint(
          '→ state count after emit: '
          '${state.filteredTestsResponse?.data.length}',
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMoreMyProfileFilteredTestsIfNeeded() async {
    if (_isFetchingFilteredTestsMore) return;

    if (!state.isTestsFilterMode) return;

    if (state.activeTestsFilterParams == null) {
      return;
    }

    if (state.isTestsFilterLoading || state.isTestsFilterLoadingMore) {
      return;
    }

    final currentResponse = state.filteredTestsResponse;

    if (currentResponse == null || !currentResponse.meta.hasMorePages) {
      return;
    }

    final cursor = currentResponse.meta.nextCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    _isFetchingFilteredTestsMore = true;

    debugPrint(
      "============ MyProfileCubit.fetchMoreMyProfileFilteredTestsIfNeeded ============",
    );
    debugPrint("→ cursor: $cursor");

    emit(
      state.copyWith(
        testsFilterLoadMoreStatus: MyProfileTestsFilterLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    try {
      final params = state.activeTestsFilterParams!.copyWith(cursor: cursor);

      final result = await filterMyProfileTestsUseCase(params);

      result.fold(
        (failure) {
          debugPrint("✗ fetchMoreMyProfileFilteredTestsIfNeeded failure");
          debugPrint("→ title: ${failure.title}");
          debugPrint("→ message: ${failure.message}");

          emit(
            state.copyWith(
              testsFilterLoadMoreStatus:
                  MyProfileTestsFilterLoadMoreStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (newResponse) {
          final existingIds = currentResponse.data
              .map((item) => item.id)
              .toSet();

          final uniqueNewItems = newResponse.data
              .where((item) => !existingIds.contains(item.id))
              .toList();

          final updatedResponse = MyProfileFilteredTestsEntity(
            success: newResponse.success,
            message: newResponse.message,
            data: [...currentResponse.data, ...uniqueNewItems],
            meta: newResponse.meta,
            statusCode: newResponse.statusCode,
          );

          debugPrint("✓ fetchMoreMyProfileFilteredTestsIfNeeded success");
          debugPrint("→ received count: ${newResponse.data.length}");
          debugPrint("→ unique count: ${uniqueNewItems.length}");
          debugPrint("→ total count: ${updatedResponse.data.length}");

          emit(
            state.copyWith(
              testsFilterLoadMoreStatus:
                  MyProfileTestsFilterLoadMoreStatus.success,
              filteredTestsResponse: updatedResponse,
              clearError: true,
            ),
          );
        },
      );
    } finally {
      _isFetchingFilteredTestsMore = false;
    }

    debugPrint("=================================================");
  }

  void clearMyProfileTestsFilter() {
    debugPrint(
      "============ MyProfileCubit.clearMyProfileTestsFilter ============",
    );

    _isFetchingFilteredTestsMore = false;

    emit(
      state.copyWith(
        isTestsFilterMode: false,

        testsFilterStatus: MyProfileTestsFilterStatus.initial,

        testsFilterLoadMoreStatus: MyProfileTestsFilterLoadMoreStatus.initial,

        clearFilteredTestsResponse: true,
        clearActiveTestsFilterParams: true,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }

  /////////////////// share profile /////////////
  Future<void> getMyProfileShareLink() async {
    debugPrint(
      "============ MyProfileCubit.getMyProfileShareLink ============",
    );

    if (state.isShareLinkLoading) return;

    final profile = state.profile;

    if (profile == null || profile.userId <= 0) {
      emit(
        state.copyWith(
          shareLinkStatus: MyProfileShareLinkStatus.failure,
          errorTitle: 'خطأ',
          errorMessage: 'تعذر تحديد الملف الشخصي المراد مشاركته',
          clearShareUrl: true,
        ),
      );
      return;
    }

    debugPrint('→ params: {userId: ${profile.userId}}');

    emit(
      state.copyWith(
        shareLinkStatus: MyProfileShareLinkStatus.loading,
        clearShareUrl: true,
        clearError: true,
      ),
    );

    final result = await getMyProfileShareLinkUseCase(
      GetOtherProfileShareLinkParams(userId: profile.userId),
    );

    result.fold(
      (failure) {
        debugPrint('✗ getMyProfileShareLink failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            shareLinkStatus: MyProfileShareLinkStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearShareUrl: true,
          ),
        );
      },
      (response) {
        final shareUrl = response.data.shareUrl.trim();

        debugPrint('✓ getMyProfileShareLink success');
        debugPrint('→ shareUrl: $shareUrl');

        if (shareUrl.isEmpty) {
          emit(
            state.copyWith(
              shareLinkStatus: MyProfileShareLinkStatus.failure,
              errorTitle: 'خطأ',
              errorMessage: 'تعذر تجهيز رابط مشاركة الملف الشخصي',
              clearShareUrl: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            shareLinkStatus: MyProfileShareLinkStatus.success,
            shareUrl: shareUrl,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetMyProfileShareLinkState() {
    emit(
      state.copyWith(
        shareLinkStatus: MyProfileShareLinkStatus.initial,
        clearShareUrl: true,
        clearError: true,
      ),
    );
  }
  

  @override
  Future<void> close() {
    _librarySearchDebounce?.cancel();
    _testsSearchDebounce?.cancel();
    return super.close();
  }
}
