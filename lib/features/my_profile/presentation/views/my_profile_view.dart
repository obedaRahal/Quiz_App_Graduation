import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_editor_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_body.dart';
import 'package:quiz_app_grad/features/settings/data/models/settings_route_args.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:share_plus/share_plus.dart';

class MyProfileView extends StatefulWidget {
  final int userId;

  const MyProfileView({super.key, required this.userId});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<MyProfileCubit>().getMyProfilePersonalInfo(
        userId: widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SizeConfig.init(context);

    return BlocListener<MyProfileCubit, MyProfileState>(
      listenWhen: (previous, current) =>
          previous.shareLinkStatus != current.shareLinkStatus,
      listener: _shareProfileListener,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // TopPageHeader(
              //   title: 'الملف الشخصي',
              //   onBack: () => safeBackToHome(context),
              //   icon: Icons.settings_outlined,
              //   onIconTap: () {
              //     debugPrint('settings');
              //     context.pushNamed(AppRouterName.settings);
              //   },
              // ),
              BlocBuilder<MyProfileCubit, MyProfileState>(
                buildWhen: (previous, current) {
                  return previous.profile != current.profile;
                },
                builder: (context, state) {
                  final profile = state.profile;

                  return TopPageHeader(
                    title: 'الملف الشخصي',
                    onBack: () => safeBackToHome(context),
                    icon: Icons.settings_outlined,
                    onIconTap: () {
                      if (profile == null) {
                        showValidationTopSnackBar(
                          context,
                          title: 'تنبيه',
                          message:
                              'يرجى الانتظار حتى يكتمل تحميل بيانات الملف الشخصي',
                          type: AppValidationSnackBarType.hint,
                        );
                        return;
                      }

                      context.pushNamed(
                        AppRouterName.settings,
                        extra: SettingsRouteArgs(
                          name: profile.name ?? '',
                          email: profile.email ?? '',
                          imageUrl: profile.avatarUrl,
                        ),
                      );
                    },
                  );
                },
              ),
              CustomButtonWidget(
                onTap: () {
                  debugPrint("change mode ");
                  context.read<ThemeCubit>().toggleTheme();
                },
                child: ThemedAppImage(
                  darkPath: AppImage.logoDark,
                  lightPath: AppImage.logoLight,
                ),
              ),

              Expanded(child: MyProfileBody(userId: widget.userId)),

              BlocBuilder<MyProfileCubit, MyProfileState>(
                buildWhen: (previous, current) =>
                    previous.selectedTab != current.selectedTab,
                builder: (context, state) {
                  if (state.selectedTab != MyProfileTab.folders) {
                    return const SizedBox.shrink();
                  }

                  return CustomBackgroundWithChild(
                    childVerticalPad: SizeConfig.h(0.01),
                    childHorizontalPad: SizeConfig.w(0.03),
                    backgroundColor: appColors.whiteToblack,
                    width: double.infinity,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppPalette.greyMediumDark
                            : AppPalette.greyBorderCart,
                        blurRadius: 4,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    child: CustomButtonWidget(
                      width: double.infinity,
                      backgroundColor: context.appColors.primaryToPrimaryDark,
                      childHorizontalPad: SizeConfig.w(0.04),
                      childVerticalPad: SizeConfig.w(0.013),
                      borderRadius: 6,
                      onTap: () async {
                        final result = await context.pushNamed(
                          AppRouterName.myProfileFolderEditor,
                          extra: MyProfileFolderEditorRouteArgs.create(
                            userId: widget.userId,
                          ),
                        );

                        if (result == true && context.mounted) {
                          context
                              .read<MyProfileCubit>()
                              .fetchMyProfileFoldersInitial();
                        }
                      },
                      child: CustomTextWidget(
                        'إنشاء مجلد جديد',
                        fontSize: SizeConfig.text(0.03),
                        color: appColors.whiteToblack,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareProfileListener(
    BuildContext context,
    MyProfileState state,
  ) async {
    final cubit = context.read<MyProfileCubit>();

    if (state.isShareLinkSuccess) {
      final shareUrl = state.shareUrl?.trim() ?? '';

      if (shareUrl.isEmpty) {
        showValidationTopSnackBar(
          context,
          title: 'خطأ',
          message: 'تعذر تجهيز رابط مشاركة الملف الشخصي',
          type: AppValidationSnackBarType.error,
        );

        cubit.resetMyProfileShareLinkState();
        return;
      }

      await Share.share(shareUrl, subject: 'مشاركة ملف شخصي من Nerd');

      if (!context.mounted) return;

      cubit.resetMyProfileShareLinkState();
      return;
    }

    if (state.isShareLinkFailure) {
      showValidationTopSnackBar(
        context,
        title: state.errorTitle ?? 'خطأ',
        message: state.errorMessage ?? 'تعذر مشاركة الملف الشخصي',
        type: AppValidationSnackBarType.error,
      );

      cubit.resetMyProfileShareLinkState();
    }
  }
}
