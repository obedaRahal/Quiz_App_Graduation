import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_dropdown_field.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_data.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_helpers.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_models.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/university_dropdown_item.dart';

class AcademicLevelRules {
  static const school = 'مدرسة';
  static const university = 'جامعة';
  static const graduated = 'خريج';
  static const master = 'ماجستير';
  static const phd = 'دكتوراه';

  static const orderedLevels = [school, university, graduated, master, phd];

  static int levelIndex(String level) {
    return orderedLevels.indexOf(level);
  }

  static bool canSelectLevel({
    required String currentLevel,
    required String targetLevel,
  }) {
    final currentIndex = levelIndex(currentLevel);
    final targetIndex = levelIndex(targetLevel);

    if (currentIndex == -1 || targetIndex == -1) return false;

    return targetIndex == currentIndex || targetIndex == currentIndex + 1;
  }

  static bool isGraduateLevel(String level) {
    return level == graduated || level == master || level == phd;
  }
}

class SchoolStageRules {
  static const primary = 'ابتدائي';
  static const middle = 'اعدادي';
  static const high = 'ثانوي';

  static const orderedStages = [primary, middle, high];

  static bool canSelectStage({
    required String? currentStage,
    required String targetStage,
    required bool isSameLevel,
  }) {
    if (!isSameLevel) return true;

    final currentIndex = orderedStages.indexOf(currentStage ?? '');
    final targetIndex = orderedStages.indexOf(targetStage);

    if (currentIndex == -1 || targetIndex == -1) return true;

    return targetIndex == currentIndex || targetIndex == currentIndex + 1;
  }
}

Future<void> showMyProfileAcademicInfoBottomSheet({
  required BuildContext context,
  required MyProfileAcademicInformationEntity currentValue,
  required MyProfileAcademicInformationEntity editableValue,
  required Future<bool> Function(MyProfileAcademicInformationEntity value)
  onSave,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return MyProfileAcademicInfoBottomSheet(
        currentValue: currentValue,
        editableValue: editableValue,
        onSave: onSave,
      );
    },
  );
}

class MyProfileAcademicInfoBottomSheet extends StatefulWidget {
  final MyProfileAcademicInformationEntity currentValue;
  final MyProfileAcademicInformationEntity editableValue;
  final Future<bool> Function(MyProfileAcademicInformationEntity value) onSave;
  const MyProfileAcademicInfoBottomSheet({
    super.key,
    required this.onSave,
    required this.currentValue,
    required this.editableValue,
  });

  @override
  State<MyProfileAcademicInfoBottomSheet> createState() =>
      _MyProfileAcademicInfoBottomSheetState();
}

class _MyProfileAcademicInfoBottomSheetState
    extends State<MyProfileAcademicInfoBottomSheet> {
  late String selectedLevel;
  String? selectedSchoolStage;

  UniversityOption? selectedUniversity;
  DepartmentOption? selectedDepartment;
  int? selectedUniversityYear;

  UniversityOption? selectedGraduatedUniversity;
  DepartmentOption? selectedGraduatedDepartment;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    selectedLevel = widget.editableValue.educationLevel.trim().isEmpty
        ? 'جامعة'
        : widget.editableValue.educationLevel;

    selectedSchoolStage = widget.editableValue.schoolStage;
    selectedUniversity = findSelectedUniversity(
      universities: currentUniversityOptions,
      university: widget.editableValue.universityName,
    );

    selectedDepartment = findSelectedDepartment(
      departments: selectedUniversity?.departments ?? [],
      department: widget.editableValue.department,
    );

    selectedUniversityYear = _parseUniversityYear(
      widget.editableValue.universityYear,
    );

    selectedGraduatedUniversity = findSelectedUniversity(
      universities: currentUniversityOptions,
      university: widget.editableValue.universityName,
    );

    selectedGraduatedDepartment = findSelectedDepartment(
      departments: selectedGraduatedUniversity?.departments ?? [],
      department: widget.editableValue.department,
    );
  }

  int? _parseUniversityYear(String? value) {
    if (value == null) return null;

    final clean = value.trim();

    if (clean.isEmpty) return null;

    final directNumber = int.tryParse(clean);
    if (directNumber != null) return directNumber;

    if (clean.contains('الأولى')) return 1;
    if (clean.contains('الثانية')) return 2;
    if (clean.contains('الثالثة')) return 3;
    if (clean.contains('الرابعة')) return 4;
    if (clean.contains('الخامسة')) return 5;
    if (clean.contains('السادسة')) return 6;

    return null;
  }

  MyProfileAcademicInformationEntity get _selectedAcademicInfo {
    return MyProfileAcademicInformationEntity(
      educationLevel: selectedLevel,
      universityName: selectedLevel == AcademicLevelRules.university
          ? selectedUniversity?.title ?? ''
          : selectedGraduatedUniversity?.title ?? '',
      department: selectedLevel == AcademicLevelRules.university
          ? selectedDepartment?.title ?? ''
          : selectedGraduatedDepartment?.title ?? '',
      universityYear:
          selectedLevel == AcademicLevelRules.university &&
              selectedUniversityYear != null
          ? selectedUniversityYear.toString()
          : null,
      schoolStage: selectedLevel == AcademicLevelRules.school
          ? selectedSchoolStage
          : null,
    );
  }

  bool get hasAcademicChanges {
    final current = widget.currentValue;
    final selected = _selectedAcademicInfo;

    return current.educationLevel.trim() != selected.educationLevel.trim() ||
        current.universityName.trim() != selected.universityName.trim() ||
        current.department.trim() != selected.department.trim() ||
        (current.universityYear ?? '').trim() !=
            (selected.universityYear ?? '').trim() ||
        (current.schoolStage ?? '').trim() !=
            (selected.schoolStage ?? '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSave = hasAcademicChanges && !isSaving;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1F1F) : AppPalette.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(0.012)),
                Container(
                  width: SizeConfig.w(0.12),
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppPalette.greyMedium.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
      
                SizedBox(height: SizeConfig.h(0.018)),
      
                CustomTextWidget(
                  'المعلومات الدراسية',
                  color: context.appColors.blackTogreyMedium,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.04),
                ),
      
                CustomDivider(height: 20, thickness: 3, isDashed: true),
      
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.045),
                      vertical: SizeConfig.h(0.012),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _SectionTitle(title: 'المستوى الدراسي'),
      
                        SizedBox(height: SizeConfig.h(0.012)),
      
                        _EducationLevelGrid(
                          selectedLevel: selectedLevel,
                          onChanged: _onLevelChanged,
                          currentLevel: widget.currentValue.educationLevel,
                        ),
      
                        SizedBox(height: SizeConfig.h(0.025)),
      
                        if (selectedLevel == 'مدرسة')
                          _SchoolStageSection(
                            selectedStage: selectedSchoolStage,
                            currentStage: widget.currentValue.schoolStage,
                            isSameSchoolLevel:
                                widget.currentValue.educationLevel ==
                                AcademicLevelRules.school,
                            onChanged: (value) {
                              setState(() => selectedSchoolStage = value);
                            },
                          ),
      
                        if (selectedLevel == 'جامعة')
                          _UniversityFieldsSection(
                            selectedUniversity: selectedUniversity,
                            selectedDepartment: selectedDepartment,
                            selectedYear: selectedUniversityYear,
                            onUniversityChanged: (value) {
                              setState(() {
                                selectedUniversity = value;
                                selectedDepartment = null;
                                selectedUniversityYear = null;
                              });
                            },
                            onDepartmentChanged: (value) {
                              setState(() {
                                selectedDepartment = value;
                                selectedUniversityYear = null;
                              });
                            },
                            onYearChanged: (value) {
                              setState(() {
                                selectedUniversityYear = value;
                              });
                            },
                          ),
      
                        if (AcademicLevelRules.isGraduateLevel(selectedLevel))
                          _GraduateDocumentsSection(
                            selectedUniversity: selectedGraduatedUniversity,
                            selectedDepartment: selectedGraduatedDepartment,
                            onUniversityChanged: (value) {
                              setState(() {
                                selectedGraduatedUniversity = value;
                                selectedGraduatedDepartment = null;
                              });
                            },
                            onDepartmentChanged: (value) {
                              setState(() {
                                selectedGraduatedDepartment = value;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
      
                CustomBackgroundWithChild(
                  childVerticalPad: SizeConfig.h(0.01),
                  childHorizontalPad: SizeConfig.w(0.03),
                  backgroundColor: context.appColors.whiteToblack,
                  width: double.infinity,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppPalette.greyMediumDark
                          : AppPalette.greyBorderCart,
                      blurRadius: 4,
                      offset: const Offset(0, -4),
                    ),
                  ],
      
                  child: CustomButtonWidget(
                    width: double.infinity,
                    backgroundColor: canSave
                        ? context.appColors.primaryToPrimaryDark
                        : AppPalette.greyMedium.withOpacity(0.45),
                    childHorizontalPad: SizeConfig.w(0.04),
                    childVerticalPad: SizeConfig.w(0.013),
                    borderRadius: 6,
                    onTap: canSave ? _save : () {},
                    child: isSaving
                        ? SizedBox(
                            width: SizeConfig.w(0.05),
                            height: SizeConfig.w(0.05),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppPalette.white,
                            ),
                          )
                        : CustomTextWidget(
                            'حفظ',
                            fontSize: SizeConfig.text(0.03),
                            color: AppPalette.white,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    if (!hasAcademicChanges || isSaving) return;

    final error = _validateBeforeSave();

    if (error != null) {
      showValidationTopSnackBar(
        context,
        title: 'تنبيه',
        message: error,
        type: AppValidationSnackBarType.hint,
      );
      return;
    }

    setState(() => isSaving = true);

    final success = await widget.onSave(_selectedAcademicInfo);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context);
    }
  }

  String? _validateBeforeSave() {
    final currentLevel = widget.currentValue.educationLevel;
    final isLevelTransition = selectedLevel != currentLevel;

    if (selectedLevel == AcademicLevelRules.school) {
      if (isLevelTransition &&
          (selectedSchoolStage == null ||
              selectedSchoolStage!.trim().isEmpty)) {
        return 'يرجى اختيار المرحلة المدرسية';
      }
    }

    if (selectedLevel == AcademicLevelRules.university) {
      if (isLevelTransition) {
        if (selectedUniversity == null) {
          return 'يرجى اختيار الجامعة';
        }

        if (selectedDepartment == null) {
          return 'يرجى اختيار الاختصاص';
        }

        if (selectedUniversityYear == null) {
          return 'يرجى اختيار السنة الدراسية';
        }
      }
    }

    if (AcademicLevelRules.isGraduateLevel(selectedLevel)) {
      if (isLevelTransition) {
        if (selectedGraduatedUniversity == null) {
          return 'يرجى اختيار الجامعة التي تخرجت منها';
        }

        if (selectedGraduatedDepartment == null) {
          return 'يرجى اختيار القسم الذي تخرجت منه';
        }
      }
    }

    return null;
  }

  void _onLevelChanged(String value) {
    setState(() {
      selectedLevel = value;

      if (value != AcademicLevelRules.school) {
        selectedSchoolStage = null;
      }

      if (value != AcademicLevelRules.university) {
        selectedUniversity = null;
        selectedDepartment = null;
        selectedUniversityYear = null;
      }

      if (!AcademicLevelRules.isGraduateLevel(value)) {
        selectedGraduatedUniversity = null;
        selectedGraduatedDepartment = null;
      }
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      title,
      color: context.appColors.blackTogreyMedium,
      fontFamily: AppFont.elMessiriBold,
      fontSize: SizeConfig.text(0.035),
    );
  }
}

class _EducationLevelGrid extends StatelessWidget {
  final String selectedLevel;
  final ValueChanged<String> onChanged;
  final String currentLevel;

  const _EducationLevelGrid({
    required this.selectedLevel,
    required this.onChanged,
    required this.currentLevel,
  });

  static const levels = [
    _LevelItem(title: 'مدرسة', icon: Icons.account_balance_outlined),
    _LevelItem(title: 'جامعة', icon: Icons.school_outlined),
    _LevelItem(title: 'ماجستير', icon: Icons.article_outlined),
    _LevelItem(title: 'دكتوراه', icon: Icons.work_outline_rounded),
    _LevelItem(title: 'خريج', icon: Icons.category_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      textDirection: TextDirection.rtl,
      spacing: SizeConfig.w(0.025),
      runSpacing: SizeConfig.h(0.012),
      children: levels.map((item) {
        final isEnabled = AcademicLevelRules.canSelectLevel(
          currentLevel: currentLevel,
          targetLevel: item.title,
        );

        return _LevelCard(
          title: item.title,
          icon: item.icon,
          isSelected: selectedLevel == item.title,
          isEnabled: isEnabled,
          onTap: () => onChanged(item.title),
        );
      }).toList(),
    );
  }
}

class _LevelItem {
  final String title;
  final IconData icon;

  const _LevelItem({required this.title, required this.icon});
}

class _LevelCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  const _LevelCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = !isEnabled
        ? AppPalette.greyLight
        : isSelected
        ? appColors.primaryToPrimaryDark
        : isDark
        ? AppPalette.fieldColorNDark
        : AppPalette.white;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: SizeConfig.w(0.38),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.012),
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorder,
            width: 1.3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppPalette.white
                  : appColors.primaryToPrimaryDark,
              size: SizeConfig.w(0.052),
            ),
            //SizedBox(height: SizeConfig.w(0.02)),
            CustomTextWidget(
              title,
              color: isSelected
                  ? AppPalette.white
                  : context.appColors.blackTogreyMedium,
              fontSize: SizeConfig.text(0.032),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchoolStageSection extends StatelessWidget {
  final String? selectedStage;
  final ValueChanged<String> onChanged;
  final String? currentStage;
  final bool isSameSchoolLevel;

  _SchoolStageSection({
    required this.selectedStage,
    required this.onChanged,
    this.currentStage,
    required this.isSameSchoolLevel,
  });

  final stages = [
    _StageItem(
      title: 'ابتدائي',
      description: 'يشمل الصفوف من الصف الأول إلى السادس الأساسي',
      icon: AppImage.number1Onboarding,
    ),
    _StageItem(
      title: 'اعدادي',
      description: 'يشمل الصفوف من السابع إلى التاسع',
      icon: AppImage.number2Onboarding,
    ),
    _StageItem(
      title: 'ثانوي',
      description: 'يشمل الصفوف من العاشر إلى البكالوريا',
      icon: AppImage.number3Onboarding,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SectionTitle(title: 'تفاصيل المستوى الدراسي'),
        SizedBox(height: SizeConfig.h(0.012)),

        ...stages.map((stage) {
          final isEnabled = SchoolStageRules.canSelectStage(
            currentStage: currentStage,
            targetStage: stage.title,
            isSameLevel: isSameSchoolLevel,
          );

          return Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
            child: _StageCard(
              title: stage.title,
              description: stage.description,
              icon: stage.icon,
              isSelected: selectedStage == stage.title,
              onTap: () => onChanged(stage.title),
              isEnabled: isEnabled,
            ),
          );
        }),
      ],
    );
  }
}

class _StageItem {
  final String title;
  final String description;
  final String icon;

  const _StageItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _StageCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  const _StageCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.01),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.primaryToPrimaryDark.withOpacity(0.12)
              : appColors.greyToGreyMediumDark,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : AppPalette.greyBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            CustomAppImage(
              path: icon,
              height: SizeConfig.h(0.05),
              color: isSelected
                  ? appColors.primaryToPrimaryDark
                  : appColors.blackTogreyMedium,
            ),
            SizedBox(width: SizeConfig.w(0.025)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextWidget(
                    title,
                    color: isSelected
                        ? appColors.primaryToPrimaryDark
                        : appColors.blackTogreyMedium,
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.032),
                  ),
                  CustomTextWidget(
                    description,
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.022),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UniversityFieldsSection extends StatelessWidget {
  final UniversityOption? selectedUniversity;
  final DepartmentOption? selectedDepartment;
  final int? selectedYear;

  final ValueChanged<UniversityOption?> onUniversityChanged;
  final ValueChanged<DepartmentOption?> onDepartmentChanged;
  final ValueChanged<int?> onYearChanged;

  const _UniversityFieldsSection({
    required this.selectedUniversity,
    required this.selectedDepartment,
    required this.selectedYear,
    required this.onUniversityChanged,
    required this.onDepartmentChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final departments = selectedUniversity?.departments ?? [];

    final availableStudyYears = selectedDepartment == null
        ? <int>[]
        : List.generate(selectedDepartment!.yearsCount, (index) => index + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SectionTitle(title: 'الجامعة'),
        SizedBox(height: SizeConfig.h(0.01)),

        OnboardingDropdownField<UniversityOption>(
          value: selectedUniversity,
          items: currentUniversityOptions,
          hintText: 'اختر الجامعة التي تدرس فيها...',
          labelBuilder: (item) => item.title,
          itemBuilder: (item) => UniversityDropdownItem(item: item),
          selectedItemBuilder: (item) => UniversityDropdownItem(item: item),
          onChanged: onUniversityChanged,
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        _SectionTitle(title: 'الاختصاص'),
        SizedBox(height: SizeConfig.h(0.01)),

        OnboardingDropdownField<DepartmentOption>(
          value: selectedDepartment,
          items: departments,
          hintText: 'اختر الاختصاص الذي تدرسه...',
          labelBuilder: (item) => item.title,
          isEnabled: selectedUniversity != null,
          onChanged: onDepartmentChanged,
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        _SectionTitle(title: 'السنة الدراسية'),
        SizedBox(height: SizeConfig.h(0.01)),

        OnboardingDropdownField<int>(
          value: selectedYear,
          items: availableStudyYears,
          hintText: 'اختر السنة الدراسية...',
          labelBuilder: yearLabel,
          isEnabled: selectedDepartment != null,
          onChanged: onYearChanged,
        ),
      ],
    );
  }
}

class _GraduateDocumentsSection extends StatelessWidget {
  final UniversityOption? selectedUniversity;
  final DepartmentOption? selectedDepartment;

  final ValueChanged<UniversityOption?> onUniversityChanged;
  final ValueChanged<DepartmentOption?> onDepartmentChanged;


  const _GraduateDocumentsSection({
    required this.selectedUniversity,
    required this.selectedDepartment,
    required this.onUniversityChanged,
    required this.onDepartmentChanged,

  });

  @override
  Widget build(BuildContext context) {
    final departments = selectedUniversity?.departments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SectionTitle(title: 'الجامعة'),
        SizedBox(height: SizeConfig.h(0.01)),

        OnboardingDropdownField<UniversityOption>(
          value: selectedUniversity,
          items: currentUniversityOptions,
          hintText: 'اختر الجامعة التي تخرجت منها...',
          labelBuilder: (item) => item.title,
          itemBuilder: (item) => UniversityDropdownItem(item: item),
          selectedItemBuilder: (item) => UniversityDropdownItem(item: item),
          onChanged: onUniversityChanged,
        ),

        SizedBox(height: SizeConfig.h(0.018)),

        _SectionTitle(title: 'القسم'),
        SizedBox(height: SizeConfig.h(0.01)),

        OnboardingDropdownField<DepartmentOption>(
          value: selectedDepartment,
          items: departments,
          hintText: 'اختر القسم الذي تخرجت منه...',
          labelBuilder: (item) => item.title,
          isEnabled: selectedUniversity != null,
          onChanged: onDepartmentChanged,
        ),

        
      ],
    );
  }
}

