import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_data.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_helpers.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/current_university_models.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/university_dropdown_item.dart';

import '../onboarding_dropdown_field.dart';

class CurrentUniversityStep extends StatelessWidget {
  const CurrentUniversityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.currentUniversity != current.currentUniversity ||
          previous.currentDepartmentAtUniversity !=
              current.currentDepartmentAtUniversity ||
          previous.currentStudyYearAtUniversity !=
              current.currentStudyYearAtUniversity,
      builder: (context, state) {
        final selectedUniversity = findSelectedUniversity(
          universities: currentUniversityOptions,
          university: state.currentUniversity,
        );

        final availableDepartments =
            selectedUniversity?.departments ?? const <DepartmentOption>[];

        final selectedDepartment = findSelectedDepartment(
          departments: availableDepartments,
          department: state.currentDepartmentAtUniversity,
        );

        final availableStudyYears = selectedDepartment == null
            ? const <int>[]
            : List.generate(
                selectedDepartment.yearsCount,
                (index) => index + 1,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _SectionLabel(title: 'الجامعة'),
            SizedBox(height: SizeConfig.h(0.005)),
            OnboardingDropdownField<UniversityOption>(
              value: selectedUniversity,
              items: currentUniversityOptions,
              hintText: 'اختر الجامعة التي تدرس فيها',
              labelBuilder: (item) => item.title,
              itemBuilder: (item) => UniversityDropdownItem(item: item),
              selectedItemBuilder: (item) => UniversityDropdownItem(item: item),
              onChanged: (value) {
                if (value == null) return;
                context.read<OnboardingCubit>().currentUniversityChanged(
                  value.title,
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.03)),

            _SectionLabel(title: 'القسم'),
            SizedBox(height: SizeConfig.h(0.005)),
            OnboardingDropdownField<DepartmentOption>(
              value: selectedDepartment,
              items: availableDepartments,
              hintText: 'اختر القسم',
              labelBuilder: (item) => item.title,
              isEnabled: selectedUniversity != null,
              onChanged: (value) {
                if (value == null) return;
                context
                    .read<OnboardingCubit>()
                    .currentDepartmentAtUniversityChanged(value.title);
              },
            ),

            SizedBox(height: SizeConfig.h(0.03)),

            _SectionLabel(title: 'السنة الدراسية'),
            SizedBox(height: SizeConfig.h(0.005)),
            OnboardingDropdownField<int>(
              value: state.currentStudyYearAtUniversity,
              items: availableStudyYears,
              hintText: 'اختر السنة الدراسية',
              labelBuilder: yearLabel,
              isEnabled: selectedDepartment != null,
              onChanged: (value) {
                if (value == null) return;
                context
                    .read<OnboardingCubit>()
                    .currentStudyYearAtUniversityChanged(value);
              },
            ),

            if (selectedDepartment != null) ...[
              SizedBox(height: SizeConfig.h(0.012)),
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextWidget(
                  'عدد سنوات هذا القسم: ${selectedDepartment.yearsCount}',
                  textAlign: TextAlign.right,
                  fontSize: SizeConfig.text(0.03),
                  color: AppPalette.greyMedium,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
        final appColors = context.appColors;

    return CustomTextWidget(
      title,
      color: appColors.blackTogreyMedium,
      fontSize: SizeConfig.text(0.045),
      fontFamily: AppFont.elMessiriSemiBold,
    );
  }
}