import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_body.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:share_plus/share_plus.dart';

class OtherProfileView extends StatefulWidget {
  final int userId;

  const OtherProfileView({super.key, required this.userId});

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // context.read<OtherProfileCubit>().loadMockOtherProfile(
      //       userId: widget.userId,
      //     );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocConsumer<OtherProfileCubit, OtherProfileState>(
              listenWhen: (previous, current) =>
                  previous.shareLinkStatus != current.shareLinkStatus,
              listener: (context, state) async {
                if (state.isShareLinkSuccess) {
                  final shareUrl = state.shareUrl;
                  if (shareUrl == null || shareUrl.isEmpty) {
                    showValidationTopSnackBar(
                      context,
                      title: "خطأ",
                      message: "تعذر تجهيز رابط مشاركة الملف الشخصي",
                      type: AppValidationSnackBarType.error,
                    );

                    context
                        .read<OtherProfileCubit>()
                        .resetOtherProfileShareLinkState();
                    return;
                  }

                  await Share.share(
                    shareUrl,
                    subject: 'مشاركة ملف شخصي من Nerd',
                  );

                  context
                      .read<OtherProfileCubit>()
                      .resetOtherProfileShareLinkState();
                }

                if (state.isShareLinkFailure) {
                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? "خطأ",
                    message: state.errorMessage ?? "تعذر مشاركة الملف الشخصي",
                    type: AppValidationSnackBarType.error,
                  );

                  context
                      .read<OtherProfileCubit>()
                      .resetOtherProfileShareLinkState();
                }
              },
              builder: (context, state) {
                return TopPageHeader(
                  title: 'ملف تعريف المستخدم',
                  onBack: () => safeBackToHome(context),
                  icon: Icons.share_rounded,
                  onIconTap: state.isShareLinkLoading
                      ? () {}
                      : () {
                          debugPrint(
                            "============ OtherProfileView.shareTap ============",
                          );
                          debugPrint("→ userId: ${widget.userId}");
                          debugPrint(
                            "=================================================",
                          );

                          context
                              .read<OtherProfileCubit>()
                              .getOtherProfileShareLink(userId: widget.userId);
                        },
                );
              },
            ),
            SizedBox(height: SizeConfig.h(0.01)),
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

            Expanded(child: OtherProfileBody(userId: widget.userId)),
          ],
        ),
      ),
    );
  }
}
