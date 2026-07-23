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
    final imageUrl = _nonEmpty(notification.image);

    if (imageUrl != null) {
      return ClipOval(
        child: CustomAppImage(
          path: imageUrl,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          fallback: _buildIconAvatar(avatarSize),
        ),
      );
    }

    return _buildIconAvatar(avatarSize);
  }

  Widget _buildIconAvatar(double avatarSize) {
    final iconUrl = _nonEmpty(notification.icon);

    return Container(
      width: avatarSize,
      height: avatarSize,
      padding: EdgeInsets.all(SizeConfig.w(0.025)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _parseColor(notification.floorColor) ?? AppPalette.primarySoft,
      ),
      child: iconUrl != null
          ? CustomAppImage(
              path: iconUrl,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
              fallback: Icon(Icons.notifications, color: AppPalette.primary),
            )
          : Icon(Icons.notifications, color: AppPalette.primary),
    );
  }

  String? _nonEmpty(String? value) {
    final normalized = value?.trim();

    if (normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return null;
    }

    return normalized;
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
