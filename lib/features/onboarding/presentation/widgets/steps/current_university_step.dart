import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
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
    return CustomTextWidget(
      title,
      color: AppPalette.black,
      fontSize: SizeConfig.text(0.045),
      fontFamily: AppFont.elMessiriSemiBold,
    );
  }
}

// class CurrentUniversityStep extends StatelessWidget {
//   const CurrentUniversityStep({super.key});

//   static const List<_UniversityOption> _universities = [
//     _UniversityOption(
//       id: 'damascus_university',
//       name: 'جامعة دمشق',
//       logoPath: null,
//       departments: [
//         _DepartmentOption(id: 'medicine', name: 'طب بشري', yearsCount: 6),
//         _DepartmentOption(id: 'dentistry', name: 'طب أسنان', yearsCount: 5),
//         _DepartmentOption(id: 'civil_engineering', name: 'الهندسة المدنية', yearsCount: 5),
//         _DepartmentOption(id: 'informatics', name: 'الهندسة المعلوماتية', yearsCount: 5),
//         _DepartmentOption(id: 'law', name: 'الحقوق', yearsCount: 4),
//       ],
//     ),
//     _UniversityOption(
//       id: 'aleppo_university',
//       name: 'جامعة حلب',
//       logoPath: null,
//       departments: [
//         _DepartmentOption(id: 'medicine', name: 'طب بشري', yearsCount: 6),
//         _DepartmentOption(id: 'dentistry', name: 'طب أسنان', yearsCount: 5),
//         _DepartmentOption(id: 'architecture', name: 'الهندسة المعمارية', yearsCount: 5),
//         _DepartmentOption(id: 'mechanical_engineering', name: 'الهندسة الميكانيكية', yearsCount: 5),
//         _DepartmentOption(id: 'commerce', name: 'التجارة والاقتصاد', yearsCount: 4),
//       ],
//     ),
//     _UniversityOption(
//       id: 'tishreen_university',
//       name: 'جامعة تشرين',
//       logoPath: null,
//       departments: [
//         _DepartmentOption(id: 'medicine', name: 'طب بشري', yearsCount: 6),
//         _DepartmentOption(id: 'dentistry', name: 'طب أسنان', yearsCount: 5),
//         _DepartmentOption(id: 'electrical_engineering', name: 'الهندسة الكهربائية', yearsCount: 5),
//         _DepartmentOption(id: 'informatics', name: 'الهندسة المعلوماتية', yearsCount: 5),
//         _DepartmentOption(id: 'arts', name: 'الآداب', yearsCount: 4),
//       ],
//     ),
//     _UniversityOption(
//       id: 'alamoun_private_university',
//       name: 'جامعة القلمون الخاصة',
//       logoPath: null,
//       departments: [
//         _DepartmentOption(id: 'medicine', name: 'طب بشري', yearsCount: 6),
//         _DepartmentOption(id: 'dentistry', name: 'طب أسنان', yearsCount: 5),
//         _DepartmentOption(id: 'informatics', name: 'الهندسة المعلوماتية', yearsCount: 5),
//         _DepartmentOption(id: 'business', name: 'إدارة الأعمال', yearsCount: 4),
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {

//     return BlocBuilder<OnboardingCubit, OnboardingState>(
//       buildWhen: (previous, current) =>
//           previous.currentUniversity != current.currentUniversity ||
//           previous.currentDepartmentAtUnivercity != current.currentDepartmentAtUnivercity ||
//           previous.currentStudyYearAtUnivercity != current.currentStudyYearAtUnivercity,
//       builder: (context, state) {
//         final selectedUniversity = _findSelectedUniversity(state.currentUniversity);
//         final availableDepartments = selectedUniversity?.departments ?? const <_DepartmentOption>[];
//         final selectedDepartment = _findSelectedDepartment(
//           departments: availableDepartments,
//           departmentId: state.currentDepartmentAtUnivercity,
//         );

//         final availableStudyYears = selectedDepartment == null
//             ? const <int>[]
//             : List.generate(selectedDepartment.yearsCount, (index) => index + 1);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             CustomTextWidget("الجامعة" , color: AppPalette.black,fontSize: SizeConfig.text(0.045),fontFamily: AppFont.elMessiriSemiBold,),
//             SizedBox(height: SizeConfig.h(0.005),),
//             OnboardingDropdownField<_UniversityOption>(
//               value: selectedUniversity,
//               items: _universities,
//               hintText: 'اختر الجامعة التي تدرس فيها',
//               labelBuilder: (item) => item.name,
//               itemBuilder: (item) => _UniversityDropdownItem(item: item),
//               selectedItemBuilder: (item) => _UniversityDropdownItem(item: item),
//               onChanged: (value) {
//                 if (value == null) return;
//                 context.read<OnboardingCubit>().currentUniversityChanged(value.id);
//               },
//             ),

//             SizedBox(height: SizeConfig.h(0.03)),

//             CustomTextWidget("القسم" , color: AppPalette.black,fontSize: SizeConfig.text(0.045),fontFamily: AppFont.elMessiriSemiBold,),
//             SizedBox(height: SizeConfig.h(0.005),),
//             OnboardingDropdownField<_DepartmentOption>(
//               value: selectedDepartment,
//               items: availableDepartments,
//               hintText: 'اختر القسم',
//               labelBuilder: (item) => item.name,
//               isEnabled: selectedUniversity != null,
//               onChanged: (value) {
//                 if (value == null) return;
//                 context.read<OnboardingCubit>().currentDepartmentAtUnivercityChanged(value.id);
//               },
//             ),

//             SizedBox(height: SizeConfig.h(0.02)),
//             CustomTextWidget("السنة الدراسية" , color: AppPalette.black,fontSize: SizeConfig.text(0.045),fontFamily: AppFont.elMessiriSemiBold,),
//             SizedBox(height: SizeConfig.h(0.005),),
//             OnboardingDropdownField<int>(
//               value: state.currentStudyYearAtUnivercity,
//               items: availableStudyYears,
//               hintText: 'اختر السنة الدراسية',
//               labelBuilder: (item) => _yearLabel(item),
//               isEnabled: selectedDepartment != null,
//               onChanged: (value) {
//                 if (value == null) return;
//                 context.read<OnboardingCubit>().currentStudyYearAtUnivercityChanged(value);
//               },
//             ),

//             SizedBox(height: SizeConfig.h(0.01)),

//             if (selectedDepartment != null)
//               CustomTextWidget(
//                 'عدد سنوات هذا القسم: ${selectedDepartment.yearsCount}',
//                 textAlign: TextAlign.right,
//                 fontSize: SizeConfig.text(0.03),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   static _UniversityOption? _findSelectedUniversity(String? universityId) {
//     if (universityId == null) return null;

//     try {
//       return _universities.firstWhere((item) => item.id == universityId);
//     } catch (_) {
//       return null;
//     }
//   }

//   static _DepartmentOption? _findSelectedDepartment({
//     required List<_DepartmentOption> departments,
//     required String? departmentId,
//   }) {
//     if (departmentId == null) return null;

//     try {
//       return departments.firstWhere((item) => item.id == departmentId);
//     } catch (_) {
//       return null;
//     }
//   }

//   static String _yearLabel(int year) {
//     switch (year) {
//       case 1:
//         return 'السنة الأولى';
//       case 2:
//         return 'السنة الثانية';
//       case 3:
//         return 'السنة الثالثة';
//       case 4:
//         return 'السنة الرابعة';
//       case 5:
//         return 'السنة الخامسة';
//       case 6:
//         return 'السنة السادسة';
//       default:
//         return 'السنة $year';
//     }
//   }
// }

// class _UniversityDropdownItem extends StatelessWidget {
//   final _UniversityOption item;

//   const _UniversityDropdownItem({
//     required this.item,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _UniversityLogo(logoPath: item.logoPath),
//         SizedBox(width: SizeConfig.w(0.02)),
//         Expanded(
//           child: CustomTextWidget(
//             item.name,
//             textAlign: TextAlign.right,
//             fontSize: SizeConfig.text(0.034),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _UniversityLogo extends StatelessWidget {
//   final String? logoPath;

//   const _UniversityLogo({
//     required this.logoPath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (logoPath == null || logoPath!.isEmpty) {
//       return CircleAvatar(
//         radius: 14,
//         child: Icon(
//           Icons.school_outlined,
//           size: 16,
//         ),
//       );
//     }

//     return CircleAvatar(
//       radius: 14,
//       backgroundImage: AssetImage(logoPath!),
//     );
//   }
// }

// class _UniversityOption {
//   final String id;
//   final String name;
//   final String? logoPath;
//   final List<_DepartmentOption> departments;

//   const _UniversityOption({
//     required this.id,
//     required this.name,
//     required this.logoPath,
//     required this.departments,
//   });
// }

// class _DepartmentOption {
//   final String id;
//   final String name;
//   final int yearsCount;

//   const _DepartmentOption({
//     required this.id,
//     required this.name,
//     required this.yearsCount,
//   });
// }
