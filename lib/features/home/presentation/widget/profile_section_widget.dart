import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/database/cache/user_local_storage.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/user_info.dart';

class ProfileSection extends StatelessWidget {
  final bool isDark;

  const ProfileSection({super.key, required this.isDark});

  String _avatarByGender(String? gender) {
    if (gender == 'ذكر') {
      return AppImage.male; // عدليها لاحقًا لصورة كارتون الذكر
    }

    if (gender == 'انثى') {
      return AppImage.female; // عدليها لاحقًا لصورة كارتون الأنثى
    }

    return AppImage.homeProfilePhoto;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        UserLocalStorage.getUserName(),
        UserLocalStorage.getUserGender(),
      ]),
      builder: (context, snapshot) {
        final name = snapshot.data?[0] ?? 'عزيزي المستخدم';
        final gender = snapshot.data?[1];

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
                  path: _avatarByGender(gender),
                  height: 38,
                  width: 35,
                ),
              ),
            ),
            const SizedBox(width: 8),
            UserInfo(
              isDark: isDark,
              name: name,
            ),
          ],
        );
      },
    );
  }
}