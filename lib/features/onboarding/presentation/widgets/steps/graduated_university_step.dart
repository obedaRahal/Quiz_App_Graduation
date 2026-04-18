import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import '../../../../../core/theme/assets/fonts.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/utils/media_query_config.dart';
import '../onboarding_dropdown_field.dart';
import '../onboarding_image_picker_field.dart';
import 'current_university/current_university_data.dart';
import 'current_university/current_university_helpers.dart';
import 'current_university/current_university_models.dart';
import 'current_university/university_dropdown_item.dart';

class GraduatedUniversityStep extends StatelessWidget {
  const GraduatedUniversityStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.graduatedUniversity != current.graduatedUniversity ||
          previous.graduatedDepartment != current.graduatedDepartment ||
          previous.graduationCertificateImagePath !=
              current.graduationCertificateImagePath ||
          previous.personalIdentityImagePath !=
              current.personalIdentityImagePath,
      builder: (context, state) {
        final selectedUniversity = findSelectedUniversity(
          universities: currentUniversityOptions,
          university: state.graduatedUniversity,
        );

        final availableDepartments =
            selectedUniversity?.departments ?? const <DepartmentOption>[];

        final selectedDepartment = findSelectedDepartment(
          departments: availableDepartments,
          department: state.graduatedDepartment,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _SectionLabel(title: 'الجامعة'),
            SizedBox(height: SizeConfig.h(0.005)),
            OnboardingDropdownField<UniversityOption>(
              value: selectedUniversity,
              items: currentUniversityOptions,
              hintText: 'اختر الجامعة التي تخرجت منها',
              labelBuilder: (item) => item.title,
              itemBuilder: (item) => UniversityDropdownItem(item: item),
              selectedItemBuilder: (item) => UniversityDropdownItem(item: item),
              onChanged: (value) {
                if (value == null) return;
                context.read<OnboardingCubit>().graduatedUniversityChanged(
                  value.title,
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.03)),

            const _SectionLabel(title: 'القسم'),
            SizedBox(height: SizeConfig.h(0.005)),
            OnboardingDropdownField<DepartmentOption>(
              value: selectedDepartment,
              items: availableDepartments,
              hintText: 'اختر القسم الذي تخرجت منه',
              labelBuilder: (item) => item.title,
              isEnabled: selectedUniversity != null,
              onChanged: (value) {
                if (value == null) return;
                context.read<OnboardingCubit>().graduatedDepartmentChanged(
                  value.title,
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.03)),

            OnboardingImagePickerField(
              title: 'الشهادة الجامعية',
              hintText: 'يرجى إرفاق شهادتك الجامعية...',
              imagePath: state.graduationCertificateImagePath,
              onTap: () {
                _pickAndSubmitImage(
                  context,
                  onPicked: (path) {
                    context
                        .read<OnboardingCubit>()
                        .graduationCertificateImageChanged(path);
                  },
                );
              },
              // () async {
              //   final path = await _pickImagePath();
              //   if (path == null || !context.mounted) return;
              //   context
              //       .read<OnboardingCubit>()
              //       .graduationCertificateImageChanged(path);
              // },
            ),

            SizedBox(height: SizeConfig.h(0.03)),

            OnboardingImagePickerField(
              title: 'الهوية الشخصية',
              hintText: 'يرجى إرفاق الوجه الأمامي للهوية الشخصية...',
              imagePath: state.personalIdentityImagePath,
              onTap: () {
                _pickAndSubmitImage(
                  context,
                  onPicked: (path) {
                    context
                        .read<OnboardingCubit>()
                        .personalIdentityImageChanged(path);
                  },
                );
              },
              // onTap: () async {
              //   final path = await _pickImagePath();
              //   if (path == null || !context.mounted) return;
              //   context.read<OnboardingCubit>().personalIdentityImageChanged(
              //     path,
              //   );
              // },
            ),
          ],
        );
      },
    );
  }

  // static Future<String?> _pickImagePath() async {
  //   final result = await FilePicker.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );

  //   if (result == null || result.files.isEmpty) return null;

  //   return result.files.single.path;
  // }

  Future<void> _pickAndSubmitImage(
    BuildContext context, {
    required void Function(String path) onPicked,
  }) async {
    final path = await sl<FilePickerService>().pickSingleImagePath();

    if (path == null || !context.mounted) return;

    onPicked(path);
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
