import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/user_info.dart';

class ProfileSection extends StatelessWidget {
  final bool isDark;

  const ProfileSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
            child: CustomAppImage(
              path: AppImage.homeProfilePhoto,
              height: 38,
              width: 35,
            ),
          ),
        ),
        const SizedBox(width: 8),
        UserInfo(isDark: isDark),
      ],
    );
  }
}