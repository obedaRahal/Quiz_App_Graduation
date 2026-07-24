import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SettingsProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const SettingsProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final profileName = name.trim();
    final profileEmail = email.trim();
    final profileImage = imageUrl?.trim() ?? '';

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig.w(0.19),
          height: SizeConfig.w(0.19),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.appColors.greyToGreyMediumDark,
            border: Border.all(color: context.appColors.whiteToblack, width: 3),
          ),
          child: ClipOval(
            child: profileImage.isEmpty
                ? Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: SizeConfig.w(0.09),
                      color: AppPalette.greyMedium,
                    ),
                  )
                : CustomAppImage(
                    path: profileImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        SizedBox(width: SizeConfig.w(0.025)),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                profileName.isEmpty ? 'مستخدم Nerd' : profileName,
                color: context.appColors.blackToGrey2Dark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.038),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              if (profileEmail.isNotEmpty) ...[
                SizedBox(height: SizeConfig.h(0.003)),
                CustomTextWidget(
                  profileEmail,
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.027),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
