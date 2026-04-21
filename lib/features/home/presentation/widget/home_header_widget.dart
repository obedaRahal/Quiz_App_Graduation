import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/notification_buttom.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/profile_section_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          ProfileSection(isDark: isDark),
          NotificationButton(isDark: isDark),
        ],
      ),
    );
  }
}