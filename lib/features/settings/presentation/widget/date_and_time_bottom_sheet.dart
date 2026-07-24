import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests/interest_chip_item.dart';
import 'package:quiz_app_grad/features/settings/domain/enums/settings_date_time_enums.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_bottom_sheet_header.dart';

Future<void> showDateAndTimeBottomSheet({
  required BuildContext context,
  required WeekStartDay selectedWeekStartDay,
  required AppTimeFormat selectedTimeFormat,
  required Future<bool> Function(WeekStartDay) onWeekStartDayChanged,
  required Future<bool> Function(AppTimeFormat) onTimeFormatChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DateAndTimeBottomSheet(
        selectedWeekStartDay: selectedWeekStartDay,
        selectedTimeFormat: selectedTimeFormat,
        onWeekStartDayChanged: onWeekStartDayChanged,
        onTimeFormatChanged: onTimeFormatChanged,
      );
    },
  );
}

class DateAndTimeBottomSheet extends StatefulWidget {
  final WeekStartDay selectedWeekStartDay;
  final AppTimeFormat selectedTimeFormat;
  final Future<bool> Function(WeekStartDay) onWeekStartDayChanged;
  final Future<bool> Function(AppTimeFormat) onTimeFormatChanged;

  const DateAndTimeBottomSheet({
    super.key,
    required this.selectedWeekStartDay,
    required this.selectedTimeFormat,
    required this.onWeekStartDayChanged,
    required this.onTimeFormatChanged,
  });

  @override
  State<DateAndTimeBottomSheet> createState() => _DateAndTimeBottomSheetState();
}

class _DateAndTimeBottomSheetState extends State<DateAndTimeBottomSheet> {
  late WeekStartDay _selectedWeekStartDay;
  late AppTimeFormat _selectedTimeFormat;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    _selectedWeekStartDay = widget.selectedWeekStartDay;
    _selectedTimeFormat = widget.selectedTimeFormat;
  }

  Future<void> _selectWeekStartDay(WeekStartDay day) async {
    if (_selectedWeekStartDay == day || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    var succeeded = false;
    try {
      succeeded = await widget.onWeekStartDayChanged(day);
    } catch (_) {
      succeeded = false;
    }

    if (!mounted) return;

    setState(() {
      if (succeeded) {
        _selectedWeekStartDay = day;
      }
      _isUpdating = false;
    });
  }

  Future<void> _selectTimeFormat(AppTimeFormat format) async {
    if (_selectedTimeFormat == format || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    var succeeded = false;
    try {
      succeeded = await widget.onTimeFormatChanged(format);
    } catch (_) {
      succeeded = false;
    }

    if (!mounted) return;

    setState(() {
      if (succeeded) {
        _selectedTimeFormat = format;
      }
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.45,
      maxChildSize: 0.82,
      expand: false,
      builder: (context, scrollController) {
        return CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: appColors.whiteToblack,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              const SettingsBottomSheetHeader(title: 'التاريخ والوقت'),

              if (_isUpdating)
                LinearProgressIndicator(
                  minHeight: 2,
                  color: appColors.primaryToPrimaryDark,
                ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.045),
                    vertical: SizeConfig.h(0.018),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _WeekStartSection(
                        selectedDay: _selectedWeekStartDay,
                        onSelected: _isUpdating ? null : _selectWeekStartDay,
                      ),

                      SizedBox(height: SizeConfig.h(0.035)),

                      _TimeFormatSection(
                        selectedFormat: _selectedTimeFormat,
                        onSelected: _isUpdating ? null : _selectTimeFormat,
                      ),

                      SizedBox(height: SizeConfig.h(0.03)),
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

class _WeekStartSection extends StatelessWidget {
  final WeekStartDay selectedDay;
  final ValueChanged<WeekStartDay>? onSelected;

  const _WeekStartSection({
    required this.selectedDay,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            'بداية الأسبوع',
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.036),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.005)),

          CustomTextWidget(
            'يقوم ذلك بالتأثير على طريقة عرض عداد الأيام في قائمة المهام اليومية، ويمكن تغييره في أي وقت.',
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.025),
            textAlign: TextAlign.right,
            maxLines: 3,
          ),

          SizedBox(height: SizeConfig.h(0.016)),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Wrap(
              spacing: SizeConfig.w(0.02),
              runSpacing: SizeConfig.h(0.012),
              alignment: WrapAlignment.start,
              children: WeekStartDay.values.map((day) {
                return InterestChipItem(
                  label: day.apiValue,
                  isSelected: selectedDay == day,
                  onTap: onSelected == null ? null : () => onSelected!(day),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeFormatSection extends StatelessWidget {
  final AppTimeFormat selectedFormat;
  final ValueChanged<AppTimeFormat>? onSelected;

  const _TimeFormatSection({
    required this.selectedFormat,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            'نمط التوقيت',
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.036),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.005)),

          CustomTextWidget(
            'يؤثر ذلك على طريقة عرض الوقت في المهام وصفحة الخطة الدراسية.',
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.025),
            textAlign: TextAlign.right,
            maxLines: 2,
          ),

          SizedBox(height: SizeConfig.h(0.016)),

          Row(
            children: [
              Expanded(
                child: InterestChipItem(
                  label: AppTimeFormat.twelveHours.apiValue,
                  isSelected: selectedFormat == AppTimeFormat.twelveHours,
                  onTap: onSelected == null
                      ? null
                      : () => onSelected!(AppTimeFormat.twelveHours),
                ),
              ),

              SizedBox(width: SizeConfig.w(0.025)),

              Expanded(
                child: InterestChipItem(
                  label: AppTimeFormat.twentyFourHours.apiValue,
                  isSelected: selectedFormat == AppTimeFormat.twentyFourHours,
                  onTap: onSelected == null
                      ? null
                      : () => onSelected!(AppTimeFormat.twentyFourHours),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
