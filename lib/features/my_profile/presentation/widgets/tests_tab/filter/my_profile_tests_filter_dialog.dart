import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/tests_tab/filter/my_profile_tests_filter_result.dart';

class MyProfileTestsFilterOption<T> {
  final String label;
  final T value;

  const MyProfileTestsFilterOption({required this.label, required this.value});
}

Future<MyProfileTestsFilterResult?> showMyProfileTestsFilterDialog({
  required BuildContext context,
  required List<InterestCategoryEntity> interestCategories,
}) {
  return showGeneralDialog<MyProfileTestsFilterResult>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'my_profile_tests_filter',
    barrierColor: Colors.black.withOpacity(0.20),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) {
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
            child: _MyProfileTestsFilterDialog(
              interestCategories: interestCategories,
            ),
          ),
        ],
      );
    },
    transitionBuilder: (_, animation, __, child) {
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

class _MyProfileTestsFilterDialog extends StatefulWidget {
  final List<InterestCategoryEntity> interestCategories;

  const _MyProfileTestsFilterDialog({required this.interestCategories});

  @override
  State<_MyProfileTestsFilterDialog> createState() =>
      _MyProfileTestsFilterDialogState();
}

class _MyProfileTestsFilterDialogState
    extends State<_MyProfileTestsFilterDialog> {
  static const typeOptions = [
    MyProfileTestsFilterOption(label: 'الكل', value: 'all'),
    MyProfileTestsFilterOption(label: 'عام', value: 'public'),
    MyProfileTestsFilterOption(label: 'خاص', value: 'private'),
    MyProfileTestsFilterOption(label: 'مدفوع', value: 'paid'),
  ];

  static const statusOptions = [
    MyProfileTestsFilterOption(label: 'الكل', value: 'all'),
    MyProfileTestsFilterOption(label: 'مسودة', value: 'new'),
    MyProfileTestsFilterOption(label: 'قيد المراجعة', value: 'under_review'),
    MyProfileTestsFilterOption(label: 'يحتاج تعديل', value: 'needs_revision'),
    MyProfileTestsFilterOption(label: 'تمت الموافقة', value: 'approved'),
    MyProfileTestsFilterOption(label: 'مبلغ عنه', value: 'reported'),
  ];

  static const languageOptions = [
    MyProfileTestsFilterOption(label: 'الكل', value: 'all'),
    MyProfileTestsFilterOption(label: 'العربية', value: 'arabic'),
    MyProfileTestsFilterOption(label: 'الإنكليزية', value: 'english'),
    MyProfileTestsFilterOption(label: 'مختلطة', value: 'mixed'),
  ];

  static const timerOptions = [
    MyProfileTestsFilterOption(label: 'مع مؤقت', value: 1),
    MyProfileTestsFilterOption(label: 'بدون مؤقت', value: 0),
  ];

  static const questionsCountOptions = [
    MyProfileTestsFilterOption(label: '10 أسئلة فأقل', value: 10),
    MyProfileTestsFilterOption(label: '20 سؤالًا فأقل', value: 20),
    MyProfileTestsFilterOption(label: '30 سؤالًا فأقل', value: 30),
    MyProfileTestsFilterOption(label: '40 سؤالًا فأقل', value: 40),
    MyProfileTestsFilterOption(label: '50 سؤالًا فأقل', value: 50),
    MyProfileTestsFilterOption(label: '60 سؤالًا فأقل', value: 60),
    MyProfileTestsFilterOption(label: '70 سؤالًا فأقل', value: 70),
    MyProfileTestsFilterOption(label: '80 سؤالًا فأقل', value: 80),
    MyProfileTestsFilterOption(label: '90 سؤالًا فأقل', value: 90),
    MyProfileTestsFilterOption(label: '100 سؤال فأقل', value: 100),
  ];

  static const passMarkOptions = [
    MyProfileTestsFilterOption(label: '20% فأقل', value: 20),
    MyProfileTestsFilterOption(label: '30% فأقل', value: 30),
    MyProfileTestsFilterOption(label: '40% فأقل', value: 40),
    MyProfileTestsFilterOption(label: '50% فأقل', value: 50),
    MyProfileTestsFilterOption(label: '60% فأقل', value: 60),
    MyProfileTestsFilterOption(label: '70% فأقل', value: 70),
    MyProfileTestsFilterOption(label: '80% فأقل', value: 80),
  ];

  MyProfileTestsFilterOption<String>? selectedType;
  MyProfileTestsFilterOption<String>? selectedStatus;
  MyProfileTestsFilterOption<String>? selectedLanguage;

  MyProfileTestsFilterOption<int>? selectedTimer;
  MyProfileTestsFilterOption<int>? selectedQuestionsCount;
  MyProfileTestsFilterOption<int>? selectedPassMark;
  MyProfileTestsFilterOption<int>? selectedInterest;

  bool get hasAnySelection =>
      selectedType != null ||
      selectedStatus != null ||
      selectedLanguage != null ||
      selectedTimer != null ||
      selectedQuestionsCount != null ||
      selectedPassMark != null ||
      selectedInterest != null;

  void _apply() {
    if (!hasAnySelection) return;

    Navigator.of(context).pop(
      MyProfileTestsFilterResult(
        type: selectedType?.value,
        status: selectedStatus?.value,
        language: selectedLanguage?.value,
        hasTimer: selectedTimer?.value,
        questionsCountLte: selectedQuestionsCount?.value,
        passMarkLte: selectedPassMark?.value,
        interestId: selectedInterest?.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: SizeConfig.w(0.85),
          height: SizeConfig.h(0.76),
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.86)),
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
              children: [
                _FilterHeader(onClose: () => Navigator.of(context).pop()),

                const CustomDivider(height: 10, thickness: 2, isDashed: true),

                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.04),
                      vertical: SizeConfig.h(0.016),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(title: 'النوع'),
                        SizedBox(height: SizeConfig.h(0.01)),
                        _FilterChipsWrap<String>(
                          items: typeOptions,
                          selectedItem: selectedType,
                          onSelected: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        const _SectionTitle(title: 'الحالة'),
                        SizedBox(height: SizeConfig.h(0.01)),
                        _FilterChipsWrap<String>(
                          items: statusOptions,
                          selectedItem: selectedStatus,
                          itemWidth: SizeConfig.w(0.235),
                          onSelected: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.022)),

                        const _SectionTitle(title: 'اللغة'),
                        SizedBox(height: SizeConfig.h(0.01)),
                        _FilterChipsWrap<String>(
                          items: languageOptions,
                          selectedItem: selectedLanguage,
                          onSelected: (value) {
                            setState(() {
                              selectedLanguage = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.024)),

                        const _SectionTitle(title: 'الخصائص'),
                        SizedBox(height: SizeConfig.h(0.012)),

                        _FilterDropDownField<int>(
                          value: selectedTimer?.label,
                          hintText: 'اختر إن كان الاختبار يحتوي مؤقتًا...',
                          sheetTitle: 'هل يحتوي الاختبار على مؤقت؟',
                          items: timerOptions,
                          selectedItem: selectedTimer,
                          onSelected: (value) {
                            setState(() {
                              selectedTimer = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.01)),

                        _FilterDropDownField<int>(
                          value: selectedQuestionsCount?.label,
                          hintText: 'اختر الحد الأعلى لعدد الأسئلة...',
                          sheetTitle: 'عدد الأسئلة',
                          items: questionsCountOptions,
                          selectedItem: selectedQuestionsCount,
                          onSelected: (value) {
                            setState(() {
                              selectedQuestionsCount = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.01)),

                        _FilterDropDownField<int>(
                          value: selectedPassMark?.label,
                          hintText: 'اختر الحد الأعلى لنسبة النجاح...',
                          sheetTitle: 'نسبة النجاح',
                          items: passMarkOptions,
                          selectedItem: selectedPassMark,
                          onSelected: (value) {
                            setState(() {
                              selectedPassMark = value;
                            });
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.01)),

                        _ScientificClassificationField(
                          value: selectedInterest?.label,
                          categories: widget.interestCategories,
                          selectedItem: selectedInterest,
                          onSelected: (value) {
                            setState(() {
                              selectedInterest = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                _ApplyFilterButton(isEnabled: hasAnySelection, onTap: _apply),
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
      child: Row(
        children: [
          SizedBox(width: 20),
          Spacer(),
          CustomTextWidget(
            'فلتر البحث',
            fontSize: SizeConfig.text(0.043),
            fontWeight: FontWeight.w900,
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
          ),
          Spacer(),

          InkWell(
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
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomTextWidget(
      title,
      fontSize: SizeConfig.text(0.039),
      fontWeight: FontWeight.w900,
      color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,
    );
  }
}

class _FilterChipsWrap<T> extends StatelessWidget {
  final List<MyProfileTestsFilterOption<T>> items;
  final MyProfileTestsFilterOption<T>? selectedItem;
  final ValueChanged<MyProfileTestsFilterOption<T>> onSelected;
  final double? itemWidth;

  const _FilterChipsWrap({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: SizeConfig.w(0.014),
      runSpacing: SizeConfig.h(0.008),
      children: items.map((item) {
        return _FilterChipItem(
          title: item.label,
          width: itemWidth ?? SizeConfig.w(0.18),
          isSelected: selectedItem?.value == item.value,
          onTap: () {
            onSelected(item);
          },
        );
      }).toList(),
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
        constraints: BoxConstraints(minHeight: SizeConfig.h(0.032)),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.01),
          vertical: SizeConfig.h(0.004),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.primarySoftTogreyLightDark
              : isDark
              ? AppPalette.fieldColorNDark
              : AppPalette.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
          ),
        ),
        child: Center(
          child: CustomTextWidget(
            title,
            fontSize: SizeConfig.text(0.022),
            fontWeight: FontWeight.w800,
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : AppPalette.greyMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
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

  final List<MyProfileTestsFilterOption<T>> items;

  final MyProfileTestsFilterOption<T>? selectedItem;

  final ValueChanged<MyProfileTestsFilterOption<T>> onSelected;

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

    return InkWell(
      onTap: () {
        showMyProfileFilterOptionsSheet<T>(
          context: context,
          title: sheetTitle,
          items: items,
          selectedItem: selectedItem,
          onSelected: onSelected,
        );
      },
      borderRadius: BorderRadius.circular(7),
      child: Container(
        //minHeight: SizeConfig.h(0.044),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.028)),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppPalette.greyMedium,
            ),
            SizedBox(width: SizeConfig.w(0.012)),
            Expanded(
              child: CustomTextWidget(
                value ?? hintText,
                fontSize: SizeConfig.text(0.025),
                color: value == null
                    ? AppPalette.greyMedium
                    : isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
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

Future<void> showMyProfileFilterOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<MyProfileTestsFilterOption<T>> items,
  required MyProfileTestsFilterOption<T>? selectedItem,
  required ValueChanged<MyProfileTestsFilterOption<T>> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      final isDark = Theme.of(sheetContext).brightness == Brightness.dark;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.65)),
          padding: EdgeInsets.all(SizeConfig.w(0.04)),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    color: AppPalette.greyMedium,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                CustomTextWidget(title, fontSize: SizeConfig.text(0.035)),

                SizedBox(height: SizeConfig.h(0.014)),

                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: SizeConfig.h(0.008)),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = selectedItem?.value == item.value;

                      return InkWell(
                        onTap: () {
                          onSelected(item);
                          Navigator.of(sheetContext).pop();
                        },
                        child: Container(
                          //minHeight: SizeConfig.h(0.046),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(0.03),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? sheetContext.appColors.primaryToPrimaryDark
                                  : AppPalette.greyLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: isSelected
                                    ? sheetContext
                                          .appColors
                                          .primaryToPrimaryDark
                                    : AppPalette.greyMedium,
                              ),
                              SizedBox(width: SizeConfig.w(0.02)),
                              Expanded(
                                child: CustomTextWidget(
                                  item.label,
                                  textAlign: TextAlign.right,
                                  color: context.appColors.blackToGrey2Dark,
                                  fontSize: SizeConfig.text(0.03),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

class _ScientificClassificationField extends StatelessWidget {
  final String? value;

  final List<InterestCategoryEntity> categories;

  final MyProfileTestsFilterOption<int>? selectedItem;

  final ValueChanged<MyProfileTestsFilterOption<int>> onSelected;

  const _ScientificClassificationField({
    required this.value,
    required this.categories,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterDropDownField<int>(
      value: value,
      hintText: 'اختر التصنيف العلمي الذي ينتمي إليه الاختبار...',
      sheetTitle: 'التصنيف العلمي',
      items: categories.expand((category) {
        return category.interests.map((interest) {
          return MyProfileTestsFilterOption<int>(
            label: interest.name,
            value: interest.id,
          );
        });
      }).toList(),
      selectedItem: selectedItem,
      onSelected: onSelected,
    );
  }
}

class _ApplyFilterButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;

  const _ApplyFilterButton({required this.isEnabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.012),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.black
            : AppPalette.white,
        border: Border(top: BorderSide(color: AppPalette.greyLight)),
      ),
      child: SizedBox(
        height: SizeConfig.h(0.05),
        child: ElevatedButton(
          onPressed: isEnabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.primaryToPrimaryDark,
            disabledBackgroundColor: AppPalette.greyLight,
            elevation: 0,
          ),
          child: CustomTextWidget(
            'تطبيق الفلتر',
            color: isEnabled ? AppPalette.white : AppPalette.greyMedium,
          ),
        ),
      ),
    );
  }
}
