import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_dropdown_field.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_option_selected_card.dart';

class EducationLevelStep extends StatelessWidget {
  const EducationLevelStep({super.key});

  static const List<String> _governorates = [
    'دمشق',
    'ريف دمشق',
    'حلب',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'إدلب',
    'درعا',
    'السويداء',
    'القنيطرة',
    'دير الزور',
    'الرقة',
    'الحسكة',
  ];

  static const List<_EducationLevelOption> _studentOptions = [
    _EducationLevelOption(
      title: EducationLevelValues.schoolLevel,
      icon: FontAwesomeIcons.school,
    ),
    _EducationLevelOption(
      title: EducationLevelValues.universityLevel,
      icon: FontAwesomeIcons.buildingColumns,
    ),
  ];

  static const List<_EducationLevelOption> _knowledgeOwnerOptions = [
    _EducationLevelOption(
      title: EducationLevelValues.mastersLevel,
      icon: FontAwesomeIcons.userGraduate,
    ),
    _EducationLevelOption(
      title: EducationLevelValues.doctorateLevel,
      icon: FontAwesomeIcons.bookOpenReader,
    ),
    _EducationLevelOption(
      title: EducationLevelValues.graduatedLevel,
      icon: FontAwesomeIcons.graduationCap,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.governorate != current.governorate ||
          previous.educationLevel != current.educationLevel,
      builder: (context, state) {
        final isStudentGroupSelected = _isAnySelectedFromGroup(
          selectedValue: state.educationLevel,
          options: _studentOptions,
        );

        final isKnowledgeOwnerGroupSelected = _isAnySelectedFromGroup(
          selectedValue: state.educationLevel,
          options: _knowledgeOwnerOptions,
        );

        //_GovernorateOption? selectedGovernorate;

        // if (state.governorate != null) {
        //   try {
        //     selectedGovernorate = _governorates.firstWhere(
        //       (item) => item.value == state.governorate,
        //     );
        //   } catch (_) {
        //     selectedGovernorate = null;
        //   }
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _GovernorateDropdown(
            //   value: state.governorate,
            //   items: _governorates,
            //   onChanged: (value) {
            //     if (value == null) return;
            //     context.read<OnboardingCubit>().governorateChanged(value);
            //     //debugPrint(value);
            //   },
            // ),
            OnboardingDropdownField<String>(
              value: state.governorate,
              items: _governorates,
              hintText: 'اختر المحافظة التي تسكن فيها',
              labelBuilder: (item) => item,
              onChanged: (value) {
                if (value == null) return;
                context.read<OnboardingCubit>().governorateChanged(value);
              },
            ),
            SizedBox(height: SizeConfig.h(0.02)),
            _EducationGroupContainer(
              title: 'طالب',
              icon: Icons.info_outline_rounded,
              isGroupSelected: isStudentGroupSelected,
              children: _buildEducationOptionCards(
                context: context,
                state: state,
                options: _studentOptions,
              ),
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            _EducationGroupContainer(
              title: 'صاحب معلومة',
              icon: Icons.info_outline_rounded,
              isGroupSelected: isKnowledgeOwnerGroupSelected,
              children: _buildEducationOptionCards(
                context: context,
                state: state,
                options: _knowledgeOwnerOptions,
              ),
            ),
          ],
        );
      },
    );
  }

  static bool _isAnySelectedFromGroup({
    required String? selectedValue,
    required List<_EducationLevelOption> options,
  }) {
    return options.any((option) => option.title == selectedValue);
  }

  static List<Widget> _buildEducationOptionCards({
    required BuildContext context,
    required OnboardingState state,
    required List<_EducationLevelOption> options,
  }) {
    return options.map((option) {
      final isSelected = state.educationLevel == option.title;

      return OnboardingOptionSelectedCard(
        label: option.title,
        icon: option.icon,
        isSelected: isSelected,
        onTap: () {
          context.read<OnboardingCubit>().educationLevelChanged(option.title);
        },
        // backgroundColor: isSelected ? AppPalette.primarySoft : AppPalette.grey,
        // borderColor: isSelected ? AppPalette.primary : AppPalette.greyLight,
        // textColor: isSelected ? AppPalette.primary : AppPalette.black,
      );
    }).toList();
  }
}

// class _GovernorateOption {
//   final String value;
//   final String label;

//   const _GovernorateOption({required this.value, required this.label});
// }

class _EducationLevelOption {
  final String title;
  final FaIconData icon;

  const _EducationLevelOption({required this.title, required this.icon});
}

class _EducationGroupContainer extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final IconData icon;
  final bool isGroupSelected;

  const _EducationGroupContainer({
    required this.children,
    required this.title,
    required this.icon,
    required this.isGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
        final appColors = context.appColors;

    final currentBorderColor = isGroupSelected
        ? appColors.primaryToPrimaryDark
        : appColors.borderFieldColorNLightToborderFieldColorNDark;

    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.h(0.018)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              SizeConfig.w(0.03),
              SizeConfig.h(0.03),
              SizeConfig.w(0.03),
              SizeConfig.h(0.012),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: currentBorderColor, width: 1.6),
            ),
            child: Column(
              children: [
                ...children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  final isLast = index == children.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : SizeConfig.h(0.01),
                    ),
                    child: child,
                  );
                }),
              ],
            ),
          ),
          PositionedDirectional(
            top: -SizeConfig.h(0.014),
            end: SizeConfig.w(0.07),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.025),
                vertical: SizeConfig.h(0.004),
              ),
              decoration: BoxDecoration(
                color: appColors.whiteToblack,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: currentBorderColor, width: 1.4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: currentBorderColor),
                  SizedBox(width: SizeConfig.w(0.015)),
                  CustomTextWidget(
                    title,
                    color: currentBorderColor,
                    fontSize: SizeConfig.text(0.03),
                    fontWeight: FontWeight.w700,
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
