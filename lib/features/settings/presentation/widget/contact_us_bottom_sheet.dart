import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_bottom_sheet_header.dart';

Future<void> showContactUsBottomSheet({
  required BuildContext context,
  VoidCallback? onGmailTap,
  VoidCallback? onOutlookTap,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ContactUsBottomSheet(
        onGmailTap: onGmailTap,
        onOutlookTap: onOutlookTap,
      );
    },
  );
}

class ContactUsBottomSheet extends StatelessWidget {
  final VoidCallback? onGmailTap;
  final VoidCallback? onOutlookTap;

  const ContactUsBottomSheet({super.key, this.onGmailTap, this.onOutlookTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      height: SizeConfig.h(0.4),
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SettingsBottomSheetHeader(title: 'تواصل معنا'),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.055),
              vertical: SizeConfig.h(0.025),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: _EmailAppItem(
                    title: 'Gmail',
                    icon: Icons.mail_rounded,
                    iconColor: const Color(0xFFEA4335),
                    onTap: onGmailTap,
                  ),
                ),

                SizedBox(width: SizeConfig.w(0.08)),

                Expanded(
                  child: _EmailAppItem(
                    title: 'Outlook',
                    icon: Icons.mark_email_unread_rounded,
                    iconColor: const Color(0xFF1473E6),
                    onTap: onOutlookTap,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.h(0.02)),
        ],
      ),
    );
  }
}

class _EmailAppItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _EmailAppItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.015)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: SizeConfig.w(0.18),
                height: SizeConfig.w(0.18),
                decoration: BoxDecoration(
                  color: appColors.greyToGreyMediumDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color:
                        appColors.borderFieldColorNLightToborderFieldColorNDark,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: SizeConfig.w(0.095)),
              ),

              SizedBox(height: SizeConfig.h(0.01)),

              CustomTextWidget(
                title,
                color: appColors.blackToGrey2Dark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.032),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
