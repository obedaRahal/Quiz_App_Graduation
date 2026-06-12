import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';

class LaboratoryFilterResult {
  final String typeLabel;
  final String typeValue;

  final String languageLabel;
  final String languageValue;

  final String? hasTimerLabel;
  final int? hasTimerValue;

  final String? questionsCountLabel;
  final int? questionsCountLte;

  final String? passMarkLabel;
  final int? passMarkLte;

  final String? scientificClassificationLabel;
  final int? interestId;

  const LaboratoryFilterResult({
    required this.typeLabel,
    required this.typeValue,
    required this.languageLabel,
    required this.languageValue,
    this.hasTimerLabel,
    this.hasTimerValue,
    this.questionsCountLabel,
    this.questionsCountLte,
    this.passMarkLabel,
    this.passMarkLte,
    this.scientificClassificationLabel,
    this.interestId,
  });
}

class _FilterOption<T> {
  final String label;
  final T value;

  const _FilterOption({required this.label, required this.value});
}

Future<LaboratoryFilterResult?> showLaboratoryFilterBottomSheet(
  BuildContext context, {
  required List<InterestCategoryEntity> interestCategories,
}) {
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
          Align(
            alignment: Alignment.center,
            child: _LaboratoryFilterDialog(
              interestCategories: interestCategories,
            ),
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
  final List<InterestCategoryEntity> interestCategories;

  const _LaboratoryFilterDialog({required this.interestCategories});

  @override
  State<_LaboratoryFilterDialog> createState() =>
      _LaboratoryFilterDialogState();
}

class _LaboratoryFilterDialogState extends State<_LaboratoryFilterDialog> {
  static const List<_FilterOption<String>> typeOptions = [
    _FilterOption(label: 'الكل', value: 'all'),
    _FilterOption(label: 'مدفوع', value: 'paid'),
  ];

  static const List<_FilterOption<String>> languageOptions = [
    _FilterOption(label: 'الكل', value: 'all'),
    _FilterOption(label: 'العربية', value: 'arabic'),
    _FilterOption(label: 'الانكليزية', value: 'english'),
    _FilterOption(label: 'مختلطة', value: 'mixed'),
  ];

  static const List<_FilterOption<int?>> timerOptions = [
    _FilterOption(label: 'الكل', value: null),
    _FilterOption(label: 'مع مؤقت', value: 1),
    _FilterOption(label: 'بدون مؤقت', value: 0),
  ];

  static const List<_FilterOption<int?>> questionsCountOptions = [
    _FilterOption(label: 'الكل', value: null),
    _FilterOption(label: '10 سؤال فأقل', value: 10),
    _FilterOption(label: '20 سؤال فأقل', value: 20),
    _FilterOption(label: '30 سؤال فأقل', value: 30),
    _FilterOption(label: '40 سؤال فأقل', value: 40),
    _FilterOption(label: '50 سؤال فأقل', value: 50),
    _FilterOption(label: '60 سؤال فأقل', value: 60),
    _FilterOption(label: '70 سؤال فأقل', value: 70),
    _FilterOption(label: '80 سؤال فأقل', value: 80),
    _FilterOption(label: '90 سؤال فأقل', value: 90),
    _FilterOption(label: '100 سؤال فأقل', value: 100),
  ];

  static const List<_FilterOption<int?>> passMarkOptions = [
    _FilterOption(label: 'الكل', value: null),
    _FilterOption(label: '20% فأقل', value: 20),
    _FilterOption(label: '30% فأقل', value: 30),
    _FilterOption(label: '40% فأقل', value: 40),
    _FilterOption(label: '50% فأقل', value: 50),
    _FilterOption(label: '60% فأقل', value: 60),
    _FilterOption(label: '70% فأقل', value: 70),
    _FilterOption(label: '80% فأقل', value: 80),
  ];

  List<_FilterOption<int?>> get scientificClassificationOptions {
    final options = <_FilterOption<int?>>[
      const _FilterOption(label: 'الكل', value: null),
    ];

    for (final category in widget.interestCategories) {
      for (final interest in category.interests) {
        options.add(
          _FilterOption<int?>(label: interest.name, value: interest.id),
        );
      }
    }

    return options;
  }

  _FilterOption<String> selectedType = typeOptions.first;
  _FilterOption<String> selectedLanguage = languageOptions.first;

  _FilterOption<int?>? selectedTimer;
  _FilterOption<int?>? selectedQuestionsCount;
  _FilterOption<int?>? selectedPassMark;
  _FilterOption<int?>? selectedScientificClassification;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: SizeConfig.w(0.82),
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.80)),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.borderFieldColorNLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.30 : 0.13),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterHeader(onClose: () => Navigator.of(context).pop()),

                const _DashedDivider(),

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      right: SizeConfig.w(0.040),
                      left: SizeConfig.w(0.040),
                      top: SizeConfig.h(0.016),
                      bottom: SizeConfig.h(0.014),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FilterSectionTitle(title: 'النوع'),
                        SizedBox(height: SizeConfig.h(0.010)),
                        _FilterChipsLine<String>(
                          items: typeOptions,
                          selectedItem: selectedType,
                          onSelected: (value) {
                            setState(() => selectedType = value);
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        const _FilterSectionTitle(title: 'اللغة'),
                        SizedBox(height: SizeConfig.h(0.010)),
                        _FilterChipsLine<String>(
                          items: languageOptions,
                          selectedItem: selectedLanguage,
                          onSelected: (value) {
                            setState(() => selectedLanguage = value);
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.024)),

                        const _FilterSectionTitle(title: 'الخصائص'),
                        SizedBox(height: SizeConfig.h(0.012)),

                        _FilterDropDownField<int?>(
                          value: selectedTimer?.label,
                          hintText: 'اختر إن كان الاختبار يحتوي مؤقت...',
                          sheetTitle: 'هل يحتوي الاختبار على مؤقت؟',
                          items: timerOptions,
                          selectedItem: selectedTimer,
                          onSelected: (value) {
                            setState(() => selectedTimer = value);
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterDropDownField<int?>(
                          value: selectedQuestionsCount?.label,
                          hintText:
                              'اختر عدد الأسئلة التي يجب أن يحتويها البنك...',
                          sheetTitle: 'عدد الأسئلة',
                          items: questionsCountOptions,
                          selectedItem: selectedQuestionsCount,
                          onSelected: (value) {
                            setState(() => selectedQuestionsCount = value);
                          },
                        ),
                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterDropDownField<int?>(
                          value: selectedPassMark?.label,
                          hintText: 'اختر نسبة النجاح المراد البحث عنها...',
                          sheetTitle: 'نسبة النجاح',
                          items: passMarkOptions,
                          selectedItem: selectedPassMark,
                          onSelected: (value) {
                            setState(() => selectedPassMark = value);
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.010)),

                        _FilterScientificClassificationField(
                          value: selectedScientificClassification?.label,
                          hintText:
                              'اختر التصنيف العلمي الذي ينتمي الاختبار إليه...',
                          categories: widget.interestCategories,
                          selectedItem: selectedScientificClassification,
                          onSelected: (value) {
                            setState(() {
                              selectedScientificClassification = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                _ApplyFilterButton(
                  onTap: () {
                    Navigator.of(context).pop(
                      LaboratoryFilterResult(
                        typeLabel: selectedType.label,
                        typeValue: selectedType.value,
                        languageLabel: selectedLanguage.label,
                        languageValue: selectedLanguage.value,
                        hasTimerLabel: selectedTimer?.label,
                        hasTimerValue: selectedTimer?.value,
                        questionsCountLabel: selectedQuestionsCount?.label,
                        questionsCountLte: selectedQuestionsCount?.value,
                        passMarkLabel: selectedPassMark?.label,
                        passMarkLte: selectedPassMark?.value,
                        scientificClassificationLabel:
                            selectedScientificClassification?.label,
                        interestId: selectedScientificClassification?.value,
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

  const _FilterHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.062),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: CustomTextWidget(
              'فلتر البحث',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.center,
            ),
          ),

          PositionedDirectional(
            start: SizeConfig.w(0.026),
            top: 0,
            bottom: 0,
            child: Center(
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: SizeConfig.w(0.073),
                  height: SizeConfig.w(0.073),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppPalette.fieldColorNDark
                        : const Color(0xFFF6F6F6),
                    border: Border.all(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : AppPalette.borderFieldColorNLight,
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
          ),
        ],
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  final String title;

  const _FilterSectionTitle({required this.title});

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

class _FilterChipsLine<T> extends StatelessWidget {
  final List<_FilterOption<T>> items;
  final _FilterOption<T> selectedItem;
  final ValueChanged<_FilterOption<T>> onSelected;

  const _FilterChipsLine({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: items.map((item) {
          final isLast = item == items.last;

          return Padding(
            padding: EdgeInsets.only(left: isLast ? 0 : SizeConfig.w(0.014)),
            child: _FilterChipItem(
              title: item.label,
              width: items.length <= 2
                  ? SizeConfig.w(0.145)
                  : SizeConfig.w(0.105),
              isSelected: item.value == selectedItem.value,
              onTap: () => onSelected(item),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String title;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.title,
    required this.width,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: width,
        height: SizeConfig.h(0.029),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft)
              : (isDark ? AppPalette.fieldColorNDark : AppPalette.white),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : (isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight),
            width: isSelected ? 1.1 : 1,
          ),
        ),
        child: Center(
          child: CustomTextWidget(
            title,
            fontSize: SizeConfig.text(0.022),
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

class _FilterDropDownField<T> extends StatelessWidget {
  final String? value;
  final String hintText;
  final String sheetTitle;
  final List<_FilterOption<T>> items;
  final _FilterOption<T>? selectedItem;
  final ValueChanged<_FilterOption<T>> onSelected;

  const _FilterDropDownField({
    required this.value,
    required this.hintText,
    required this.sheetTitle,
    required this.items,
    required this.selectedItem,
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
        showLaboratoryFilterOptionsSheet<T>(
          context: context,
          title: sheetTitle,
          items: items,
          selectedItem: selectedItem,
          onSelected: onSelected,
        );
      },
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: SizeConfig.h(0.041),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.028)),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: SizeConfig.text(0.040),
              color: hintColor,
            ),
            SizedBox(width: SizeConfig.w(0.012)),
            Expanded(
              child: CustomTextWidget(
                value ?? hintText,
                fontSize: SizeConfig.text(0.025),
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

class _FilterScientificClassificationField extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<InterestCategoryEntity> categories;
  final _FilterOption<int?>? selectedItem;
  final ValueChanged<_FilterOption<int?>> onSelected;

  const _FilterScientificClassificationField({
    required this.value,
    required this.hintText,
    required this.categories,
    required this.selectedItem,
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
        showLaboratoryScientificClassificationSheet(
          context: context,
          categories: categories,
          selectedItem: selectedItem,
          onSelected: onSelected,
        );
      },
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: SizeConfig.h(0.041),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.028)),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: SizeConfig.text(0.040),
              color: hintColor,
            ),
            SizedBox(width: SizeConfig.w(0.012)),
            Expanded(
              child: CustomTextWidget(
                value ?? hintText,
                fontSize: SizeConfig.text(0.025),
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

  const _ApplyFilterButton({required this.onTap});

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

Future<void> showLaboratoryFilterOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<_FilterOption<T>> items,
  required _FilterOption<T>? selectedItem,
  required ValueChanged<_FilterOption<T>> onSelected,
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
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.62)),
          padding: EdgeInsets.only(
            left: SizeConfig.w(0.040),
            right: SizeConfig.w(0.040),
            top: SizeConfig.h(0.014),
            bottom: SizeConfig.h(0.020),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items.map((item) {
                        final selected =
                            selectedItem != null &&
                            item.value == selectedItem!.value;

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
                                            : AppPalette
                                                  .borderFieldColorNLight),
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
                                      item.label,
                                      fontSize: SizeConfig.text(0.030),
                                      fontWeight: FontWeight.w800,
                                      color: selected
                                          ? context
                                                .appColors
                                                .primaryToPrimaryDark
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
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showLaboratoryScientificClassificationSheet({
  required BuildContext context,
  required List<InterestCategoryEntity> categories,
  required _FilterOption<int?>? selectedItem,
  required ValueChanged<_FilterOption<int?>> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.18),
    isScrollControlled: true,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      final allOption = const _FilterOption<int?>(label: 'الكل', value: null);

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.70)),
          padding: EdgeInsets.only(
            left: SizeConfig.w(0.040),
            right: SizeConfig.w(0.040),
            top: SizeConfig.h(0.014),
            bottom: SizeConfig.h(0.020),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  'التصنيف العلمي',
                  fontSize: SizeConfig.text(0.038),
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ScientificInterestOptionTile(
                          title: allOption.label,
                          isSelected:
                              selectedItem != null &&
                              selectedItem.value == allOption.value,
                          onTap: () {
                            onSelected(allOption);
                            Navigator.of(context).pop();
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.012)),

                        if (categories.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.h(0.020),
                            ),
                            child: Center(
                              child: CustomTextWidget(
                                'لا توجد تصنيفات متاحة حالياً',
                                fontSize: SizeConfig.text(0.030),
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppPalette.grey2Dark
                                    : AppPalette.greyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        ...categories.map((category) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.h(0.018),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  category.title,
                                  fontSize: SizeConfig.text(0.034),
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppPalette.textWhiteINDark
                                      : AppPalette.textColorInHome,
                                  textAlign: TextAlign.right,
                                ),

                                SizedBox(height: SizeConfig.h(0.010)),

                                Wrap(
                                  spacing: SizeConfig.w(0.014),
                                  runSpacing: SizeConfig.h(0.009),
                                  alignment: WrapAlignment.end,
                                  children: category.interests.map((interest) {
                                    final option = _FilterOption<int?>(
                                      label: interest.name,
                                      value: interest.id,
                                    );

                                    final selected =
                                        selectedItem != null &&
                                        selectedItem.value == option.value;

                                    return _ScientificInterestChip(
                                      title: option.label,
                                      isSelected: selected,
                                      onTap: () {
                                        onSelected(option);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ScientificInterestOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScientificInterestOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: SizeConfig.h(0.044),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft)
              : (isDark ? AppPalette.fieldColorNDark : AppPalette.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : (isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: SizeConfig.text(0.038),
              color: isSelected
                  ? appColors.primaryToPrimaryDark
                  : (isDark ? AppPalette.grey2Dark : AppPalette.greyMedium),
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            Expanded(
              child: CustomTextWidget(
                title,
                fontSize: SizeConfig.text(0.030),
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? appColors.primaryToPrimaryDark
                    : (isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScientificInterestChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScientificInterestChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: SizeConfig.h(0.032),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.024)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft)
              : (isDark ? AppPalette.fieldColorNDark : AppPalette.white),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : (isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight),
          ),
        ),
        child: Center(
          child: CustomTextWidget(
            title,
            fontSize: SizeConfig.text(0.024),
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
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);

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
