import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_bottom_sheet_header.dart';

Future<void> showSocialAccountsBottomSheet({
  required BuildContext context,
  VoidCallback? onFacebookTap,
  VoidCallback? onInstagramTap,
  VoidCallback? onTelegramTap,
  VoidCallback? onYouTubeTap,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return SocialAccountsBottomSheet(
        onFacebookTap: onFacebookTap,
        onInstagramTap: onInstagramTap,
        onTelegramTap: onTelegramTap,
        onYouTubeTap: onYouTubeTap,
      );
    },
  );
}

class SocialAccountsBottomSheet extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onInstagramTap;
  final VoidCallback? onTelegramTap;
  final VoidCallback? onYouTubeTap;

  const SocialAccountsBottomSheet({
    super.key,
    this.onFacebookTap,
    this.onInstagramTap,
    this.onTelegramTap,
    this.onYouTubeTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      height: SizeConfig.h(0.3),
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SettingsBottomSheetHeader(title: 'حسابات التطبيق'),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.035),
              vertical: SizeConfig.h(0.02),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SocialAccountItem(
                  title: 'فيسبوك',
                  icon: Icons.facebook_rounded,
                  onTap: onFacebookTap,
                ),

                _SocialAccountItem(
                  title: 'انستغرام',
                  icon: Icons.camera_alt_outlined,
                  onTap: onInstagramTap,
                ),

                _SocialAccountItem(
                  title: 'تلغرام',
                  icon: Icons.send_rounded,
                  onTap: onTelegramTap,
                ),

                _SocialAccountItem(
                  title: 'يوتيوب',
                  icon: Icons.play_circle_fill_rounded,
                  onTap: onYouTubeTap,
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.h(0.018)),
        ],
      ),
    );
  }
}

class _SocialAccountItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _SocialAccountItem({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.012),
            vertical: SizeConfig.h(0.01),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: SizeConfig.w(0.075),
                color: appColors.blackToGrey2Dark,
              ),

              SizedBox(height: SizeConfig.h(0.006)),

              CustomTextWidget(
                title,
                color: appColors.blackToGrey2Dark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.025),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
