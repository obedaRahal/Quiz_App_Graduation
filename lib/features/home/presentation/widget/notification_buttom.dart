import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class NotificationButton extends StatelessWidget {
  final bool isDark;

  const NotificationButton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppPalette.borderFieldColorNDark
            : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.5),
        child: Icon(
          Icons.notifications_outlined,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.black,
        ),
      ),
    );
  }
}