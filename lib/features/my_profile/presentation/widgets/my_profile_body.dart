import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_header_card.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_image_action_menu.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_selected_tab_content.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_tabs_section.dart';

class MyProfileBody extends StatelessWidget {
  const MyProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileState>(
      listenWhen: (previous, current) =>
          previous.updateStatus != current.updateStatus,
      listener: (context, state) {
        if (state.isUpdateSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'تم الحفظ',
            message: 'تم تحديث بيانات الملف الشخصي بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<MyProfileCubit>().resetUpdateState();
        }

        if (state.isUpdateFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر حفظ التعديلات',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyProfileCubit>().resetUpdateState();
        }
      },
      builder: (context, state) {
        if (state.isFetchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFetchFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppPalette.red,
                    size: SizeConfig.w(0.12),
                  ),
                  SizedBox(height: SizeConfig.h(0.02)),
                  CustomTextWidget(
                    state.errorTitle ?? 'حدث خطأ غير متوقع',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.045),
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  CustomTextWidget(
                    state.errorMessage ??
                        'يرجى التحقق من الاتصال والمحاولة مرة أخرى',
                    color: AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final profile = state.editableProfile;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(0.012)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: MyProfileHeaderCard(
                  profile: profile,
                  onChangeCoverTap: () {
                    debugPrint("change cover");
                    showMyProfileImageActionMenu(
                      context: context,
                      title: 'اختر خيارًا لتغيير صورة الغلاف الخاصة بك',
                      hasCurrentImage: profile.coverUrl.trim().isNotEmpty,
                      onCamera: () {
                        debugPrint('cover camera');
                      },
                      onGallery: () {
                        debugPrint('cover gallery');
                      },
                      onView: () {
                        debugPrint('cover view');
                      },
                      onDelete: () {
                        context.read<MyProfileCubit>().updateCoverUrl('');
                      },
                    );
                  },
                  onChangeAvatarTap: () {
                    debugPrint("change avatar");
                    showMyProfileImageActionMenu(
                      context: context,
                      title: 'اختر خيارًا لتغيير الصورة الخاصة بك',
                      hasCurrentImage: profile.avatarUrl.trim().isNotEmpty,
                      onCamera: () {
                        debugPrint('avatar camera');
                      },
                      onGallery: () {
                        debugPrint('avatar gallery');
                      },
                      onView: () {
                        debugPrint('avatar view');
                      },
                      onDelete: () {
                        context.read<MyProfileCubit>().updateAvatarUrl('');
                      },
                    );
                  },
                  onShareTap: () {
                    debugPrint("share profile");
                  },
                  onShowSavedTap: () {
                    debugPrint("show saved list");
                  },
                ),
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              MyProfileTabsSection(
                selectedTab: state.selectedTab,
                onTabSelected: (tab) {
                  context.read<MyProfileCubit>().changeSelectedTab(tab);
                },
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: MyProfileSelectedTabContent(
                  selectedTab: state.selectedTab,
                  profile: profile,
                ),
              ),

              SizedBox(height: SizeConfig.h(0.03)),
            ],
          ),
        );
      },
    );
  }
}
