import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';

import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';

class NotificationAvatar extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationAvatar({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final avatarSize = SizeConfig.w(0.13);

    if (notification.mode == 'user') {
      return CircleAvatar(
        radius: SizeConfig.w(0.065),
        backgroundColor: AppPalette.greyLight,
        child: notification.image != null
            ? ClipOval(
                child: SizedBox(
                  width: avatarSize,
                  height: avatarSize,
                  child: CustomAppImage(path: notification.image!),
                ),
              )
            : Icon(
                Icons.person,
                color: AppPalette.greyMedium,
                size: SizeConfig.text(0.06),
              ),
      );
    }

    return Container(
      width: avatarSize,
      height: avatarSize,
      padding: EdgeInsets.all(SizeConfig.w(0.025)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _parseColor(notification.floorColor) ?? AppPalette.primarySoft,
      ),
      child: notification.icon != null
          ? CustomAppImage(path: notification.icon!)
          : Icon(Icons.notifications, color: AppPalette.primary),
    );
  }

  Color? _parseColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      final normalizedValue = value
          .trim()
          .replaceFirst('#', '')
          .padLeft(8, 'f');

      return Color(int.parse(normalizedValue, radix: 16));
    } catch (_) {
      return null;
    }
  }
}
