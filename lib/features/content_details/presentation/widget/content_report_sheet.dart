import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ContentReportSheet extends StatefulWidget {
  final void Function({
    required String reason,
    String? description,
  }) onSubmit;

  const ContentReportSheet({
    super.key,
    required this.onSubmit,
  });

  static void show(
    BuildContext context, {
    required void Function({
      required String reason,
      String? description,
    }) onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppPalette.black.withOpacity(0.22),
      isScrollControlled: true,
      builder: (_) => ContentReportSheet(onSubmit: onSubmit),
    );
  }

  @override
  State<ContentReportSheet> createState() => _ContentReportSheetState();
}

class _ContentReportSheetState extends State<ContentReportSheet> {
  static const reasons = [
    'محتوى مسيء (أخلاقيا - دينيا - اجتماعيا)',
    'يوجد أخطاء علمية داخل المحتوى',
    'محتوى فارغ لايوجد به معلومات',
  ];

  final descriptionController = TextEditingController();
  String? selectedReason;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.w(0.040),
          right: SizeConfig.w(0.040),
          bottom: MediaQuery.of(context).viewInsets.bottom + SizeConfig.h(0.025),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.045),
            vertical: SizeConfig.h(0.018),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.70),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                'الإبلاغ عن المحتوى',
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
                fontSize: SizeConfig.text(0.040).clamp(15.0, 18.0).toDouble(),
                fontWeight: FontWeight.w700,
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              Align(
                alignment: Alignment.centerRight,
                child: CustomTextWidget(
                  'سبب البلاغ *',
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  fontSize: SizeConfig.text(0.032).clamp(12.0, 14.0).toDouble(),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: SizeConfig.h(0.008)),

              _ReasonDropdown(
                value: selectedReason,
                reasons: reasons,
                onChanged: (value) {
                  setState(() => selectedReason = value);
                },
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              Align(
                alignment: Alignment.centerRight,
                child: CustomTextWidget(
                  'وصف إضافي (اختياري)',
                  color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: SizeConfig.h(0.008)),

              TextField(
                controller: descriptionController,
                maxLines: 4,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  fontFamily: 'elMessiriRegular',
                  fontSize: SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب وصف البلاغ إن أحببت...',
                  hintStyle: TextStyle(
                    color: AppPalette.greyMedium,
                    fontFamily: 'elMessiriRegular',
                    fontSize:
                        SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppPalette.greyMediumDark
                      : AppPalette.primarySoftMore,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : AppPalette.greyLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.h(0.020)),

              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      title: 'إلغاء',
                      isPrimary: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(0.025)),
                  Expanded(
                    child: _SheetButton(
                      title: 'إرسال البلاغ',
                      isPrimary: true,
                      enabled: selectedReason != null,
                      onTap: () {
                        if (selectedReason == null) return;

                        Navigator.pop(context);

                        widget.onSubmit(
                          reason: selectedReason!,
                          description: descriptionController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonDropdown extends StatelessWidget {
  final String? value;
  final List<String> reasons;
  final ValueChanged<String?> onChanged;

  const _ReasonDropdown({
    required this.value,
    required this.reasons,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyMediumDark : AppPalette.primarySoftMore,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.greyLight,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: CustomTextWidget(
            'اختر سبب البلاغ',
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
            fontWeight: FontWeight.w600,
          ),
          dropdownColor:
              isDark ? AppPalette.fieldColorNDark : AppPalette.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          items: reasons.map((reason) {
            return DropdownMenuItem<String>(
              value: reason,
              child: CustomTextWidget(
                reason,
                textAlign: TextAlign.right,
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
                fontSize: SizeConfig.text(0.028).clamp(10.0, 12.0).toDouble(),
                fontWeight: FontWeight.w600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String title;
  final bool isPrimary;
  final bool enabled;
  final VoidCallback onTap;

  const _SheetButton({
    required this.title,
    required this.isPrimary,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final effectiveColor = enabled
        ? (isPrimary ? primary : AppPalette.greyMedium)
        : AppPalette.grey2;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: SizeConfig.h(0.048),
        decoration: BoxDecoration(
          color: isPrimary && enabled ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: effectiveColor),
        ),
        child: Center(
          child: CustomTextWidget(
            title,
            color: isPrimary && enabled ? AppPalette.white : effectiveColor,
            fontSize: SizeConfig.text(0.032).clamp(12.0, 14.0).toDouble(),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}