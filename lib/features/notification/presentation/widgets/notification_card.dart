import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';

import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';

import 'notification_avatar.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final cardColor = notification.isRead
        ? AppPalette.white
        : AppPalette.primarySoft;

    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: () {
        debugPrint('============ Notification Tap ============');

        debugPrint('→ notification id: ${notification.id}');

        debugPrint('→ mode: ${notification.mode}');

        debugPrint('→ screen: ${notification.metadata.screen}');

        debugPrint('→ action: ${notification.metadata.action}');

        debugPrint('→ params: ${notification.metadata.params}');

        debugPrint('============================================');
      },

      child: CustomBackgroundWithChild(
        width: double.infinity,
        borderRadius: BorderRadius.circular(20),

        padding: EdgeInsets.all(SizeConfig.w(0.035)),

        backgroundColor: cardColor,

        child: Row(
          textDirection: TextDirection.rtl,

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            NotificationAvatar(notification: notification),

            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  CustomTextWidget(
                    notification.title,
                    fontSize: SizeConfig.text(0.035),
                    fontFamily: AppFont.elMessiriBold,
                    color: AppPalette.textColorInHome,
                    textAlign: TextAlign.right,
                  ),

                  SizedBox(height: SizeConfig.h(0.006)),

                  CustomTextWidget(
                    notification.body,
                    fontSize: SizeConfig.text(0.030),
                    color: AppPalette.greyMedium,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                  ),

                  SizedBox(height: SizeConfig.h(0.008)),

                  CustomTextWidget(
                    notification.sentAt,
                    fontSize: SizeConfig.text(0.026),
                    color: AppPalette.black,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),

            CustomButtonWidget(
              backgroundColor: AppPalette.primary,
              borderRadius: 10,
              childHorizontalPad: SizeConfig.w(0.035),
              childVerticalPad: SizeConfig.h(0.003),
              onTap: () {},
              child: CustomTextWidget(
                "انتقال",
                color: AppPalette.white,
                fontSize: SizeConfig.text(0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
