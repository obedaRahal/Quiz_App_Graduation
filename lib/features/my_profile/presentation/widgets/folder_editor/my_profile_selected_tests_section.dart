import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_tests_picker_bottom_sheet.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/selected_folder_test_card.dart';

class MyProfileSelectedTestsSection extends StatelessWidget {
  final int userId;
  const MyProfileSelectedTestsSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileFolderEditorCubit, MyProfileFolderEditorState>(
      buildWhen: (previous, current) =>
          previous.selectedTests != current.selectedTests,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                CustomTextWidget(
                  'محتوى المجلد',
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.037),
                  color: context.appColors.blackToGrey2Dark,
                ),
                SizedBox(width: SizeConfig.w(0.015)),
                CustomBackgroundWithChild(
                  backgroundColor: context.appColors.primarySoftTogreyLightDark,
                  borderRadius: BorderRadius.circular(20),
                  childHorizontalPad: SizeConfig.w(0.025),
                  childVerticalPad: SizeConfig.h(0.002),
                  child: CustomTextWidget(
                    '${state.selectedTests.length} اختبار',
                    color: context.appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.026),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(0.006)),

            CustomTextWidget(
              'يجب الاخذ بعين الاعتبار ان محتوى المجلد يجب ان يكون اختبارات من النوع عامة في حال اخترت نشر المجلد',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.027),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            if (state.selectedTests.isEmpty)
              EmptyActionBox(
                title: 'إضافة اختبارات إلى المجلد',
                description: 'اضغط هنا لاختيار الاختبارات التي تريد إضافتها',
                onTap: () {
                  debugPrint('open choose tests bottom sheet');
                  debugPrint('and userId issssssssssss $userId');
                  showMyProfileTestsPickerBottomSheet(
                    context: context,
                    userId: userId,
                  );
                },
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.h(0.25),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: state.selectedTests.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: SizeConfig.w(0.025)),
                      itemBuilder: (context, index) {
                        final test = state.selectedTests[index];

                        return SizedBox(
                          width: SizeConfig.w(0.42),
                          child: SelectedFolderTestCard(
                            test: test,
                            onRemoveTap: () {
                              context
                                  .read<MyProfileFolderEditorCubit>()
                                  .removeSelectedTest(test.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.012)),

                  CustomButtonWidget(
                    backgroundColor:
                        context.appColors.primarySoftTogreyLightDark,
                    borderRadius: 20,
                    childHorizontalPad: SizeConfig.w(0.04),
                    childVerticalPad: SizeConfig.h(0.006),
                    onTap: () {
                      debugPrint('open choose tests bottom sheet');
                      debugPrint('and userId issssssssssss $userId');

                      showMyProfileTestsPickerBottomSheet(
                        context: context,
                        // يجب تمرير userid
                        userId: userId,
                      );
                    },
                    child: CustomTextWidget(
                      'إضافة اختبارات أخرى +',
                      color: context.appColors.primaryToPrimaryDark,
                      fontSize: SizeConfig.text(0.028),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

