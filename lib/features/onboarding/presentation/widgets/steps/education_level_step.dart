import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_dropdown_field.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_option_selected_card.dart';


class EducationLevelStep extends StatelessWidget {
  const EducationLevelStep({super.key});

  static const List<_GovernorateOption> _governorates = [
    _GovernorateOption(value: 'damascus', label: 'دمشق'),
    _GovernorateOption(value: 'damascus_countryside', label: 'ريف دمشق'),
    _GovernorateOption(value: 'aleppo', label: 'حلب'),
    _GovernorateOption(value: 'homs', label: 'حمص'),
    _GovernorateOption(value: 'hama', label: 'حماة'),
    _GovernorateOption(value: 'latakia', label: 'اللاذقية'),
    _GovernorateOption(value: 'tartus', label: 'طرطوس'),
    _GovernorateOption(value: 'idlib', label: 'إدلب'),
    _GovernorateOption(value: 'daraa', label: 'درعا'),
    _GovernorateOption(value: 'sweida', label: 'السويداء'),
    _GovernorateOption(value: 'quneitra', label: 'القنيطرة'),
    _GovernorateOption(value: 'deir_ez_zor', label: 'دير الزور'),
    _GovernorateOption(value: 'raqqa', label: 'الرقة'),
    _GovernorateOption(value: 'hasakah', label: 'الحسكة'),
  ];

  static const List<_EducationLevelOption> _studentOptions = [
    _EducationLevelOption(
      value: OnboardingCubit.schoolLevel,
      label: 'مدرسة',
      icon: FontAwesomeIcons.school,
    ),
    _EducationLevelOption(
      value: OnboardingCubit.universityLevel,
      label: 'جامعة',
      icon: FontAwesomeIcons.buildingColumns,
    ),
  ];

  static const List<_EducationLevelOption> _knowledgeOwnerOptions = [
    _EducationLevelOption(
      value: OnboardingCubit.mastersLevel,
      label: 'ماجستير',
      icon: FontAwesomeIcons.userGraduate,
    ),
    _EducationLevelOption(
      value: OnboardingCubit.doctorateLevel,
      label: 'دكتوراه',
      icon: FontAwesomeIcons.bookOpenReader,
    ),
    _EducationLevelOption(
      value: OnboardingCubit.graduatedLevel,
      label: 'خريج',
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

        _GovernorateOption? selectedGovernorate;

        if (state.governorate != null) {
          try {
            selectedGovernorate = _governorates.firstWhere(
              (item) => item.value == state.governorate,
            );
          } catch (_) {
            selectedGovernorate = null;
          }
        }

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
            OnboardingDropdownField<_GovernorateOption>(
              value: selectedGovernorate,
              items: _governorates,
              hintText: 'اختر المحافظة التي تسكن فيها',
              labelBuilder: (item) => item.label,
              onChanged: (value) {
                if (value == null) return;
                context.read<OnboardingCubit>().governorateChanged(value.value);
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
    return options.any((option) => option.value == selectedValue);
  }

  static List<Widget> _buildEducationOptionCards({
    required BuildContext context,
    required OnboardingState state,
    required List<_EducationLevelOption> options,
  }) {
    return options.map((option) {
      final isSelected = state.educationLevel == option.value;

      return OnboardingOptionSelectedCard(
        label: option.label,
        icon: option.icon,
        isSelected: isSelected,
        onTap: () {
          context.read<OnboardingCubit>().educationLevelChanged(option.value);
        },
        backgroundColor: isSelected ? AppPalette.primarySoft : AppPalette.grey,
        borderColor: isSelected ? AppPalette.primary : AppPalette.greyLight,
        textColor: isSelected ? AppPalette.primary : AppPalette.black,
      );
    }).toList();
  }
}

// class _GovernorateDropdown extends StatelessWidget {
//   final String? value;
//   final List<_GovernorateOption> items;
//   final ValueChanged<String?> onChanged;

//   const _GovernorateDropdown({
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: DropdownButtonFormField<String>(
//         value: value,
//         isExpanded: true,
//         icon: const Icon(Icons.keyboard_arrow_down_rounded),
//         hint: CustomTextWidget(
//           'اختر المحافظة التي تسكن فيها',
//           fontSize: 13,
//           color: AppPalette.greyMedium,
//           textAlign: TextAlign.right,
//         ),
//         decoration: _buildDropdownDecoration(),
//         items: items.map((item) {
//           return DropdownMenuItem<String>(
//             alignment: Alignment.centerRight,
//             value: item.value,
//             child: CustomTextWidget(
//               item.label,
//               textAlign: TextAlign.right,
//               fontSize: SizeConfig.text(0.036),
//             ),
//           );
//         }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   InputDecoration _buildDropdownDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: AppPalette.grey,
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.w(0.04),
//         vertical: SizeConfig.h(0.01),
//       ),
//       border: _outlineBorder(),
//       enabledBorder: _outlineBorder(width: 2),
//       focusedBorder: _outlineBorder(width: 1.4),
//       errorBorder: _outlineBorder(color: Colors.red, width: 1.4),
//       focusedErrorBorder: _outlineBorder(color: Colors.red, width: 1.6),
//     );
//   }

//   OutlineInputBorder _outlineBorder({Color? color, double width = 1.4}) {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: color ?? AppPalette.greyLight,
//         width: width,
//       ),
//     );
//   }
// }

class _GovernorateOption {
  final String value;
  final String label;

  const _GovernorateOption({required this.value, required this.label});
}

class _EducationLevelOption {
  final String value;
  final String label;
  final FaIconData icon;

  const _EducationLevelOption({
    required this.value,
    required this.label,
    required this.icon,
  });
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
    final currentBorderColor = isGroupSelected
        ? AppPalette.primary
        : AppPalette.greyLight;

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
                color: AppPalette.grey,
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
