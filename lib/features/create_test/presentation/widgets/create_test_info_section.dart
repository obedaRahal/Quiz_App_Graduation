import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_picker_sheets.dart';

class CreateTestInfoSection extends StatelessWidget {
  const CreateTestInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _InfoSectionHeader(),

            SizedBox(height: SizeConfig.h(0.018)),

            Row(
              children: [
                Expanded(
                  child: CreateTestInfoItem(
                    title: 'المستوى',
                    value: state.level,
                    image: AppImage.savedItems,
                    iconColor: AppPalette.primaryDark,
                    onTap: () {
                      showCreateTestOptionsSheet<String>(
                        context: context,
                        title: 'المستوى',
                        items: CreateTestCubit.levels,
                        selectedItem: state.level,
                        itemLabel: (item) => item,
                        onSelected: context.read<CreateTestCubit>().changeLevel,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: CreateTestInfoItem(
                    title: 'المدة',
                    value: _formatDuration(state.durationSeconds),
                    image: AppImage.stopwatch,
                    iconColor: AppPalette.green,
                    onTap: () {
                      context.read<CreateTestCubit>().prepareDurationPicker();
                      showCreateTestDurationDialog(context);
                    },
                  ),
                ),
                Expanded(
                  child: CreateTestInfoItem(
                    title: 'حد النجاح',
                    value: state.successLimit == null
                        ? 'اختياري'
                        : '${state.successLimit}%',
                    image: AppImage.checkDouble,
                    iconColor: AppPalette.orange,
                    onTap: () {
                      showCreateTestOptionsSheet<int?>(
                        context: context,
                        title: 'حد النجاح',
                        items: const [null, 20, 30, 40, 50, 60, 70, 80],
                        selectedItem: state.successLimit,
                        itemLabel: (item) =>
                            item == null ? 'بدون حد نجاح' : '$item%',
                        onSelected: context
                            .read<CreateTestCubit>()
                            .changeSuccessLimit,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: CreateTestInfoItem(
                    title: 'اللغة',
                    value: state.language,
                    image: AppImage.language,
                    iconColor: AppPalette.red,
                    onTap: () {
                      showCreateTestOptionsSheet<String>(
                        context: context,
                        title: 'اللغة',
                        items: CreateTestCubit.languages,
                        selectedItem: state.language,
                        itemLabel: (item) => item,
                        onSelected: context
                            .read<CreateTestCubit>()
                            .changeLanguage,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static String _formatDuration(int? totalSeconds) {
  if (totalSeconds == null) return 'اختياري';

  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  if (seconds == 0) {
    return '$minutes د';
  }

  return '$minutes د $seconds ث';
}
}

class _InfoSectionHeader extends StatelessWidget {
  const _InfoSectionHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppImage(
              path: AppImage.cubes,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            CustomTextWidget(
              'معلومات الاختبار',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.006)),
        CustomTextWidget(
          'اذكر المعلومات الأساسية للاختبار مثل: المستوى - السعر - التخصص - عدد الأسئلة - الوصف',
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
      ],
    );
  }
}

class CreateTestInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final String image;
  final Color iconColor;
  final VoidCallback onTap;

  const CreateTestInfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.image,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: SizeConfig.h(0.09),
        child: Column(
          children: [
            CustomAppImage(path: image, color: iconColor),

            SizedBox(height: SizeConfig.h(0.0066)),

            CustomTextWidget(
              title,
              fontSize: SizeConfig.text(0.036),
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),

            SizedBox(height: SizeConfig.h(0.002)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CustomTextWidget(
                    value,
                    fontSize: SizeConfig.text(0.028),
                    fontWeight: FontWeight.w600,
                    color: AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.003)),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: SizeConfig.text(0.043),
                  color: AppPalette.greyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
