import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LaboratoryFilterResult {
  final String type;
  final String status;
  final String language;
  final String? owner;
  final String? questionsCount;
  final String? successLimit;
  final String? scientificClassification;

  const LaboratoryFilterResult({
    required this.type,
    required this.status,
    required this.language,
    this.owner,
    this.questionsCount,
    this.successLimit,
    this.scientificClassification,
  });
}

Future<LaboratoryFilterResult?> showLaboratoryFilterBottomSheet(
  BuildContext context,
) {
  return showGeneralDialog<LaboratoryFilterResult>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'laboratory_filter_sheet',
    barrierColor: Colors.black.withOpacity(0.20),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
              child: const SizedBox.expand(),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: _LaboratoryFilterDialog(),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _LaboratoryFilterDialog extends StatefulWidget {
  const _LaboratoryFilterDialog();

  @override
  State<_LaboratoryFilterDialog> createState() =>
      _LaboratoryFilterDialogState();
}

class _LaboratoryFilterDialogState extends State<_LaboratoryFilterDialog> {
  String selectedType = 'الكل';
  String selectedStatus = 'الكل';
  String selectedLanguage = 'الكل';

  String? selectedOwner;
  String? selectedQuestionsCount;
  String? selectedSuccessLimit;
  String? selectedScientificClassification;

  static const List<String> typeOptions = [
    'الكل',
    'عام',
    'خاص',
    'مدفوع',
  ];

  static const List<String> statusOptions = [
    'الكل',
    'قيد المراجعة',
    'يحتاج إلى تعديل',
    'جاهز إلى تعديل',
    'إيقاف المبيعات',
    'تم التحقق منه',
  ];

  static const List<String> languageOptions = [
    'الكل',
    'العربية',
    'الإنكليزية',
    'مختلطة',
  ];

  static const List<String> ownerOptions = [
    'البنك الخاص بي',
    'البنوك العامة',
    'كل البنوك',
  ];

  static const List<String> questionsCountOptions = [
    'أقل من 10 أسئلة',
    'من 10 إلى 25 سؤال',
    'من 25 إلى 50 سؤال',
    'أكثر من 50 سؤال',
  ];

  static const List<String> successLimitOptions = [
    'بدون حد نجاح',
    '20%',
    '30%',
    '40%',
    '50%',
    '60%',
    '70%',
    '80%',
  ];

  static const List<String> scientificClassificationOptions = [
    'علوم أساسية',
    'برمجة',
    'علوم الحاسوب',
    'رياضيات',
    'هندسة البرمجيات',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: SizeConfig.w(0.82),
          constraints: BoxConstraints(
            maxHeight: SizeConfig.h(0.74),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.borderFieldColorNLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.28 : 0.12),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterHeader(
                  onClose: () => Navigator.of(context).pop(),
                ),

                const _DashedDivider(),

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.040),
                      vertical: SizeConfig.h(0.016),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _FilterSectionTitle(title: 'النوع'),
                        SizedBox(height: SizeConfig.h(0.010)),
                        _FilterChipsWrap(
                          items: typeOptions,
                          selectedItem: selectedType,
                          onSelected: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        _FilterSectionTitle(title: 'الحالة'),
                        SizedBox(height: SizeConfig.h(0.010)),
                        _FilterChipsWrap(
                          items: statusOptions,
                          selectedItem: selectedStatus,
                          onSelected: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        _FilterSectionTitle(title: 'اللغة'),
                        SizedBox(height: SizeConfig.h(0.010)),
                        _FilterChipsWrap(
                          items: languageOptions,
                          selectedItem: selectedLanguage,
                          onSelected: (value) {
                            setState(() {
                              selectedLanguage = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.024)),

                        _FilterSectionTitle(title: 'الخصائص'),
                        SizedBox(height: SizeConfig.h(0.012)),

                        _FilterDropDownField(
                          value: selectedOwner,
                          hintText: 'اختر إن كان يحوي البنك على مؤلف...',
                          items: ownerOptions,
                          onSelected: (value) {
                            setState(() {
                              selectedOwner = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterDropDownField(
                          value: selectedQuestionsCount,
                          hintText: 'اختر عدد الأسئلة التي يجب أن يحتويها البنك...',
                          items: questionsCountOptions,
                          onSelected: (value) {
                            setState(() {
                              selectedQuestionsCount = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterDropDownField(
                          value: selectedSuccessLimit,
                          hintText: 'اختر نسبة النجاح المراد البحث عنها...',
                          items: successLimitOptions,
                          onSelected: (value) {
                            setState(() {
                              selectedSuccessLimit = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterDropDownField(
                          value: selectedScientificClassification,
                          hintText:
                              'اختر التصنيف العلمي الذي ينتمي الاختبار إليه...',
                          items: scientificClassificationOptions,
                          onSelected: (value) {
                            setState(() {
                              selectedScientificClassification = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.018)),
                      ],
                    ),
                  ),
                ),

                _ApplyFilterButton(
                  onTap: () {
                    Navigator.of(context).pop(
                      LaboratoryFilterResult(
                        type: selectedType,
                        status: selectedStatus,
                        language: selectedLanguage,
                        owner: selectedOwner,
                        questionsCount: selectedQuestionsCount,
                        successLimit: selectedSuccessLimit,
                        scientificClassification:
                            selectedScientificClassification,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _FilterHeader({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.064),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomTextWidget(
            'فلتر البحث',
            fontSize: SizeConfig.text(0.043),
            fontWeight: FontWeight.w900,
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
            textAlign: TextAlign.center,
          ),

          Positioned(
            left: SizeConfig.w(0.026),
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: SizeConfig.w(0.075),
                height: SizeConfig.w(0.075),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppPalette.fieldColorNDark
                      : const Color(0xFFF6F6F6),
                  border: Border.all(
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.borderFieldColorNLight,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: SizeConfig.text(0.040),
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  final String title;

  const _FilterSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomTextWidget(
      title,
      fontSize: SizeConfig.text(0.039),
      fontWeight: FontWeight.w900,
      color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,
      textAlign: TextAlign.right,
    );
  }
}

class _FilterChipsWrap extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;

  const _FilterChipsWrap({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SizeConfig.w(0.018),
      runSpacing: SizeConfig.h(0.010),
      alignment: WrapAlignment.end,
      children: items.map((item) {
        return _FilterChipItem(
          title: item,
          isSelected: selectedItem == item,
          onTap: () => onSelected(item),
        );
      }).toList(),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final selectedBackground = isDark
        ? AppPalette.fieldColorNDark
        : AppPalette.primarySoft;

    final unselectedBackground = isDark
        ? AppPalette.fieldColorNDark
        : AppPalette.white;

    final selectedBorder = appColors.primaryToPrimaryDark;

    final unselectedBorder = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.borderFieldColorNLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: SizeConfig.h(0.034),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
        decoration: BoxDecoration(
          color: isSelected ? selectedBackground : unselectedBackground,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Center(
          child: CustomTextWidget(
            title,
            fontSize: SizeConfig.text(0.025),
            fontWeight: FontWeight.w800,
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : (isDark ? AppPalette.grey2Dark : AppPalette.greyMedium),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class _FilterDropDownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const _FilterDropDownField({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fieldColor = isDark ? AppPalette.fieldColorNDark : AppPalette.white;
    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.borderFieldColorNLight;

    final textColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    final hintColor = isDark ? AppPalette.grey2Dark : AppPalette.greyMedium;

    return InkWell(
      onTap: () {
        showLaboratoryFilterOptionsSheet(
          context: context,
          title: hintText,
          items: items,
          selectedItem: value,
          onSelected: onSelected,
        );
      },
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: SizeConfig.h(0.043),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: SizeConfig.text(0.044),
              color: hintColor,
            ),

            SizedBox(width: SizeConfig.w(0.014)),

            Expanded(
              child: CustomTextWidget(
                value ?? hintText,
                fontSize: SizeConfig.text(0.026),
                fontWeight: FontWeight.w700,
                color: value == null ? hintColor : textColor,
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplyFilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ApplyFilterButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.w(0.040),
        right: SizeConfig.w(0.040),
        top: SizeConfig.h(0.012),
        bottom: SizeConfig.h(0.014),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.black : AppPalette.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: SizeConfig.h(0.050),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.primaryToPrimaryDark,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: CustomTextWidget(
            'تطبيق الفلتر',
            fontSize: SizeConfig.text(0.032),
            fontWeight: FontWeight.w800,
            color: isDark ? AppPalette.black : AppPalette.white,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

Future<void> showLaboratoryFilterOptionsSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  required String? selectedItem,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.18),
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.w(0.040),
            right: SizeConfig.w(0.040),
            top: SizeConfig.h(0.014),
            bottom: SizeConfig.h(0.020),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : Colors.transparent,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: SizeConfig.w(0.13),
                  height: SizeConfig.h(0.004),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.greyLightDark
                        : AppPalette.smallContainerGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                CustomTextWidget(
                  title,
                  fontSize: SizeConfig.text(0.035),
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                ...items.map((item) {
                  final selected = selectedItem == item;

                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
                    child: InkWell(
                      onTap: () {
                        onSelected(item);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: SizeConfig.h(0.046),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.030),
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? (isDark
                                  ? AppPalette.fieldColorNDark
                                  : AppPalette.primarySoft)
                              : (isDark
                                  ? AppPalette.fieldColorNDark
                                  : AppPalette.white),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? context.appColors.primaryToPrimaryDark
                                : (isDark
                                    ? AppPalette.borderFieldColorNDark
                                    : AppPalette.borderFieldColorNLight),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: SizeConfig.text(0.040),
                              color: selected
                                  ? context.appColors.primaryToPrimaryDark
                                  : (isDark
                                      ? AppPalette.grey2Dark
                                      : AppPalette.greyMedium),
                            ),

                            SizedBox(width: SizeConfig.w(0.018)),

                            Expanded(
                              child: CustomTextWidget(
                                item,
                                fontSize: SizeConfig.text(0.030),
                                fontWeight: FontWeight.w800,
                                color: selected
                                    ? context.appColors.primaryToPrimaryDark
                                    : (isDark
                                        ? AppPalette.textWhiteINDark
                                        : AppPalette.textColorInHome),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : const Color(0xFFD7D7D7),
          dashWidth: 9,
          dashSpace: 6,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}