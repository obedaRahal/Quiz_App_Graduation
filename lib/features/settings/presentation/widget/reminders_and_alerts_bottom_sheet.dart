import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_bottom_sheet_header.dart';

Future<void> showRemindersAndAlertsBottomSheet({
  required BuildContext context,
  required bool taskRemindersEnabled,
  required ValueChanged<bool> onTaskRemindersChanged,
  VoidCallback? onOpenNotificationSettings,
  VoidCallback? onTestNotification,
  VoidCallback? onTestAlarm,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return RemindersAndAlertsBottomSheet(
        taskRemindersEnabled: taskRemindersEnabled,
        onTaskRemindersChanged: onTaskRemindersChanged,
        onOpenNotificationSettings: onOpenNotificationSettings,
        onTestNotification: onTestNotification,
        onTestAlarm: onTestAlarm,
      );
    },
  );
}

class RemindersAndAlertsBottomSheet extends StatefulWidget {
  final bool taskRemindersEnabled;
  final ValueChanged<bool> onTaskRemindersChanged;
  final VoidCallback? onOpenNotificationSettings;
  final VoidCallback? onTestNotification;
  final VoidCallback? onTestAlarm;

  const RemindersAndAlertsBottomSheet({
    super.key,
    required this.taskRemindersEnabled,
    required this.onTaskRemindersChanged,
    this.onOpenNotificationSettings,
    this.onTestNotification,
    this.onTestAlarm,
  });

  @override
  State<RemindersAndAlertsBottomSheet> createState() =>
      _RemindersAndAlertsBottomSheetState();
}

class _RemindersAndAlertsBottomSheetState
    extends State<RemindersAndAlertsBottomSheet> {
  late bool _taskRemindersEnabled;

  @override
  void initState() {
    super.initState();
    _taskRemindersEnabled = widget.taskRemindersEnabled;
  }

  void _changeTaskReminders(bool value) {
    setState(() {
      _taskRemindersEnabled = value;
    });

    widget.onTaskRemindersChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.55,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: appColors.whiteToblack,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              const SettingsBottomSheetHeader(title: 'التذكيرات والتنبيهات'),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.04),
                    vertical: SizeConfig.h(0.018),
                  ),
                  child: Column(
                    children: [
                      _NotificationPermissionCard(
                        onOpenSettings: widget.onOpenNotificationSettings,
                      ),

                      SizedBox(height: SizeConfig.h(0.018)),

                      _ReminderActionTile(
                        title: 'إشعار',
                        subtitle: 'تذكير يظهر في مركز الإشعارات',
                        icon: Icons.notifications_none_rounded,
                        iconColor: const Color(0xFFF0B94B),
                        iconBackgroundColor: const Color(0xFFFFE6A6),
                        actionText: 'تجربة',
                        onActionTap: widget.onTestNotification,
                      ),

                      SizedBox(height: SizeConfig.h(0.012)),

                      _ReminderActionTile(
                        title: 'منبه',
                        subtitle: 'يعمل بالصوت حتى في وضع الصامت',
                        icon: Icons.alarm_rounded,
                        iconColor: const Color(0xFFF06A73),
                        iconBackgroundColor: const Color(0xFFFFB8BD),
                        actionText: 'تجربة',
                        onActionTap: widget.onTestAlarm,
                      ),

                      SizedBox(height: SizeConfig.h(0.012)),

                      _TaskReminderSwitchTile(
                        value: _taskRemindersEnabled,
                        onChanged: _changeTaskReminders,
                      ),

                      SizedBox(height: SizeConfig.h(0.02)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  final bool isDark;

  const _BottomSheetHandle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(0.12),
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyLightDark : AppPalette.greyLight,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class _NotificationPermissionCard extends StatelessWidget {
  final VoidCallback? onOpenSettings;

  const _NotificationPermissionCard({this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: context.appColors.greyToGreyMediumDark,
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.018),
      ),
      border: Border.all(color: AppPalette.greyBorderCart),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: SizeConfig.w(0.095),
                color: const Color(0xFF5C86FF),
              ),
              Transform.rotate(
                angle: -0.7,
                child: Container(
                  width: SizeConfig.w(0.12),
                  height: 2,
                  color: AppPalette.red,
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          CustomTextWidget(
            'يحتاج التطبيق الإذن لتذكيرك',
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.034),
            color: appColors.blackToGrey2Dark,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          CustomButtonWidget(
            onTap: onOpenSettings ?? () {},
            backgroundColor: appColors.primaryToPrimaryDark,
            borderRadius: 6,
            childHorizontalPad: SizeConfig.w(0.035),
            childVerticalPad: SizeConfig.h(0.007),
            child: CustomTextWidget(
              'فتحها من الإعدادات',
              color: Colors.white,
              fontSize: SizeConfig.text(0.027),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String actionText;
  final VoidCallback? onActionTap;

  const _ReminderActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: context.appColors.greyToGreyMediumDark,
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.012),
      ),
      border: Border.all(color: AppPalette.greyBorderCart),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _ReminderIcon(
            icon: icon,
            iconColor: iconColor,
            backgroundColor: iconBackgroundColor,
          ),

          SizedBox(width: SizeConfig.w(0.025)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.031),
                  color: appColors.blackToGrey2Dark,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: SizeConfig.h(0.002)),
                CustomTextWidget(
                  subtitle,
                  fontSize: SizeConfig.text(0.022),
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: SizeConfig.w(0.02)),

          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.015),
                vertical: SizeConfig.h(0.007),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.w(0.028),
                    color: appColors.primaryToPrimaryDark,
                  ),
                  SizedBox(width: SizeConfig.w(0.008)),
                  CustomTextWidget(
                    actionText,
                    color: appColors.primaryToPrimaryDark,
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.025),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskReminderSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TaskReminderSwitchTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: context.appColors.greyToGreyMediumDark,
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.01),
      ),
      border: Border.all(color: AppPalette.greyBorderCart),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const _ReminderIcon(
            icon: Icons.notifications_active_outlined,
            iconColor: Color(0xFF159FD0),
            backgroundColor: Color(0xFF75D8F2),
          ),

          SizedBox(width: SizeConfig.w(0.025)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  'تذكيرات المهام',
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.031),
                  color: appColors.blackToGrey2Dark,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: SizeConfig.h(0.002)),
                CustomTextWidget(
                  'تذكيرك قبل الموعد المحدد للمهمة',
                  fontSize: SizeConfig.text(0.022),
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: SizeConfig.w(0.01)),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: appColors.primaryToPrimaryDark,
              ),
              CustomTextWidget(
                value ? 'مفعلة' : 'معطلة',
                color: value
                    ? appColors.primaryToPrimaryDark
                    : AppPalette.greyMedium,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.022),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReminderIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _ReminderIcon({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(0.105),
      height: SizeConfig.w(0.105),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.25),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: SizeConfig.w(0.052)),
    );
  }
}
