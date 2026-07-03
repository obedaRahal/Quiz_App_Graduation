import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/acadimic_info/my_profile_academic_info_bottom_sheet.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/scientific_interests/my_profile_scientific_interests_bottom_sheet.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/chips_secion.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_birth_date_field.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_dropdown_field.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_edit_small_button.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_editable_field.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_gender_selector.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_read_only_field.dart';

const List<String> _governorates = [
  'دمشق',
  'ريف دمشق',
  'حلب',
  'حمص',
  'حماة',
  'اللاذقية',
  'طرطوس',
  'ادلب',
  'درعا',
  'السويداء',
  'القنيطرة',
  'دير الزور',
  'الرقة',
  'الحسكة',
];

class MyProfilePersonalInfoTab extends StatelessWidget {
  final MyProfileEntity profile;

  const MyProfilePersonalInfoTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      buildWhen: (previous, current) =>
          previous.editableProfile != current.editableProfile ||
          previous.updateStatus != current.updateStatus,
      builder: (context, state) {
        final editable = state.editableProfile ?? profile;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyProfileEditableField(
              title: "الاسم",
              value: editable.name,
              hintText: 'الاسم',
              icon: Icons.person_outline_rounded,
              maxLength: 60,
              onChanged: context.read<MyProfileCubit>().updateName,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            MyProfileReadOnlyField(
              title: 'البريد الإلكتروني',
              value: editable.email,
              icon: Icons.mail_outline_rounded,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            CustomTextWidget(
              "المحافظة",
              color: context.appColors.blackTogreyMedium,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.034),
            ),
            SizedBox(height: SizeConfig.h(0.01)),
            MyProfileDropdownField(
              value: editable.governorate,
              hintText: 'اختر المحافظة',
              icon: Icons.location_on_outlined,
              items: _governorates,
              onChanged: (value) {
                if (value == null) return;
                context.read<MyProfileCubit>().updateGovernorate(value);
              },
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            MyProfileEditableField(
              title: 'رقم الهاتف',
              value: editable.phone,
              hintText: 'الرقم',
              icon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
              onChanged: context.read<MyProfileCubit>().updatePhone,
              maxLength: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.02)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextWidget(
                    "يجب ان يبدأ رقم الهاتف ب 09 وان لا يزيد عن عشرة ارقام",
                    color: context.appColors.blackTogreyMedium,
                    fontSize: SizeConfig.text(0.02),
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Icon(Icons.warning_amber_rounded, size: SizeConfig.h(0.02)),
                ],
              ),
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            SizedBox(height: SizeConfig.h(0.006)),
            MyProfileBirthDateField(
              value: editable.birthDate,
              onChanged: context.read<MyProfileCubit>().updateBirthDate,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            MyProfileGenderSelector(
              value: editable.gender,
              onChanged: context.read<MyProfileCubit>().updateGender,
            ),

            SizedBox(height: SizeConfig.h(0.024)),

            ChipsSection(
              title: 'المعلومات الدراسية',
              chips: editable.academicInformation.displayItems,
              chipColor: AppPalette.purple.withOpacity(0.2),
              textColor: AppPalette.purple,
            ),
            SizedBox(height: SizeConfig.h(0.01)),

            ProfileEditSmallButton(
              title: 'تعديل المعلومات الدراسية',
              onTap: () {
                showMyProfileAcademicInfoBottomSheet(
                  context: context,

                  currentValue: profile.academicInformation,

                  editableValue: editable.academicInformation,

                  onSave: (value) {
                    return context
                        .read<MyProfileCubit>()
                        .saveAcademicInfoChanges(value);
                  },
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.022)),

            ChipsSection(
              title: 'الاهتمامات العلمية',
              chips: editable.scientificInterestNames,
              chipColor: context.appColors.primarySoftTogreyLightDark,
              textColor: context.appColors.primaryToPrimaryDark,
            ),
            SizedBox(height: SizeConfig.h(0.01)),
            ProfileEditSmallButton(
              title: 'تعديل الاهتمامات العلمية',
              onTap: () {
                showMyProfileScientificInterestsBottomSheet(
                  context: context,
                  cubit: sl<AllInterestsCubit>(),
                  initialSelected: editable.scientificInterests,
                  onSave: (selectedInterests) {
                    return context
                        .read<MyProfileCubit>()
                        .saveScientificInterestsChanges(selectedInterests);
                  },
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.028)),

            _SaveChangesButton(
              enabled: state.hasChanges,
              isLoading: state.isUpdateLoading,
              onTap: () {
                context.read<MyProfileCubit>().savePersonalInfoChanges();
              },
            ),
          ],
        );
      },
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _SaveChangesButton({
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      width: double.infinity,
      backgroundColor: enabled
          ? appColors.primaryToPrimaryDark
          : AppPalette.greyMedium.withOpacity(0.45),
      borderRadius: 10,
      childVerticalPad: SizeConfig.h(0.012),
      onTap: enabled && !isLoading ? onTap : () {},
      child: isLoading
          ? SizedBox(
              width: SizeConfig.w(0.05),
              height: SizeConfig.w(0.05),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppPalette.white,
              ),
            )
          : CustomTextWidget(
              'حفظ التعديلات',
              color: AppPalette.white,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.034),
            ),
    );
  }
}
