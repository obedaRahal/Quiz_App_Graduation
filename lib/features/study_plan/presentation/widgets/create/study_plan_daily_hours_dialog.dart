import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanDailyHoursDialog extends StatefulWidget {
  final int initialHours;
  final int minHours;
  final int maxHours;

  const StudyPlanDailyHoursDialog({
    super.key,
    required this.initialHours,
    this.minHours = 1,
    this.maxHours = 10,
  });

  @override
  State<StudyPlanDailyHoursDialog> createState() =>
      _StudyPlanDailyHoursDialogState();
}

class _StudyPlanDailyHoursDialogState
    extends State<StudyPlanDailyHoursDialog> {
  late int _selectedHours;

  @override
  void initState() {
    super.initState();

    _selectedHours = widget.initialHours.clamp(
      widget.minHours,
      widget.maxHours,
    );
  }

  void _increaseHours() {
    if (_selectedHours >= widget.maxHours) {
      return;
    }

    setState(() {
      _selectedHours++;
    });
  }

  void _decreaseHours() {
    if (_selectedHours <= widget.minHours) {
      return;
    }

    setState(() {
      _selectedHours--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final primaryColor =
        context.appColors.primaryToPrimaryDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.055),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          SizeConfig.w(0.045),
          SizeConfig.h(0.018),
          SizeConfig.w(0.045),
          SizeConfig.h(0.02),
        ),
        decoration: BoxDecoration(
          color: context.appColors.whiteToblack,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'ساعات الدراسة اليومية',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.043),
                    color: context.appColors.blackToGrey2Dark,
                    textAlign: TextAlign.right,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: SizeConfig.w(0.078),
                    height: SizeConfig.w(0.078),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppPalette.fieldColorNDark
                          : AppPalette.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: SizeConfig.text(0.05),
                      color: context.appColors.blackToGrey2Dark,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(0.008)),

            CustomTextWidget(
              'اختر عدد الساعات التي تستطيع تخصيصها للدراسة يوميًا',
              fontSize: SizeConfig.text(0.03),
              fontWeight: FontWeight.w500,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),

            SizedBox(height: SizeConfig.h(0.025)),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.035),
                vertical: SizeConfig.h(0.02),
              ),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HourControlButton(
                    icon: Icons.remove_rounded,
                    enabled: _selectedHours > widget.minHours,
                    onTap: _decreaseHours,
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration:
                            const Duration(milliseconds: 180),
                        transitionBuilder: (
                          child,
                          animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: CustomTextWidget(
                          '$_selectedHours',
                          key: ValueKey(_selectedHours),
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.09),
                          color: primaryColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomTextWidget(
                        _hoursLabel(_selectedHours),
                        fontFamily:
                            AppFont.elMessiriSemiBold,
                        fontSize: SizeConfig.text(0.031),
                        color: context
                            .appColors.blackToGrey2Dark,
                      ),
                    ],
                  ),

                  _HourControlButton(
                    icon: Icons.add_rounded,
                    enabled:
                        _selectedHours < widget.maxHours,
                    onTap: _increaseHours,
                  ),
                ],
              ),
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor:
                    primaryColor.withValues(alpha: 0.18),
                thumbColor: primaryColor,
                overlayColor:
                    primaryColor.withValues(alpha: 0.12),
                trackHeight: 4,
              ),
              child: Slider(
                value: _selectedHours.toDouble(),
                min: widget.minHours.toDouble(),
                max: widget.maxHours.toDouble(),
                divisions:
                    widget.maxHours - widget.minHours,
                label: '$_selectedHours',
                onChanged: (value) {
                  setState(() {
                    _selectedHours = value.round();
                  });
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.008),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    '${widget.minHours} ساعة',
                    fontSize: SizeConfig.text(0.026),
                    color: AppPalette.greyMedium,
                  ),
                  CustomTextWidget(
                    '${widget.maxHours} ساعات',
                    fontSize: SizeConfig.text(0.026),
                    color: AppPalette.greyMedium,
                  ),
                ],
              ),
            ),

            SizedBox(height: SizeConfig.h(0.022)),

            CustomButtonWidget(
              width: double.infinity,
              backgroundColor: primaryColor,
              childHorizontalPad:
                  SizeConfig.w(0.04),
              childVerticalPad:
                  SizeConfig.h(0.011),
              borderRadius: 8,
              onTap: () {
                Navigator.of(context).pop(
                  _selectedHours,
                );
              },
              child: CustomTextWidget(
                'تأكيد',
                fontFamily:
                    AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.031),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hoursLabel(int hours) {
    if (hours == 1) {
      return 'ساعة واحدة يوميًا';
    }

    if (hours == 2) {
      return 'ساعتان يوميًا';
    }

    if (hours >= 3 && hours <= 10) {
      return '$hours ساعات يوميًا';
    }

    return '$hours ساعة يوميًا';
  }
}

class _HourControlButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _HourControlButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        context.appColors.primaryToPrimaryDark;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: SizeConfig.w(0.12),
        height: SizeConfig.w(0.12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? primaryColor
              : primaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: SizeConfig.text(0.065),
          color: enabled
              ? Colors.white
              : primaryColor.withValues(alpha: 0.42),
        ),
      ),
    );
  }
}