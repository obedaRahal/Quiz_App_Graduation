import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestTitleDescriptionSection extends StatelessWidget {
  const CreateTestTitleDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _SectionTitle(),

            SizedBox(height: SizeConfig.h(0.006)),

            CustomTextWidget(
              'أضف معلومات اختبارك بوضوح، عنوان مناسب ووصف مختصر يشرح به وصف المحتوى لتسهيل فهمه.',
              fontSize: SizeConfig.text(0.033),
              fontWeight: FontWeight.w500,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.right,
              maxLines: 2,
            ),

            SizedBox(height: SizeConfig.h(0.016)),

            CreateTestCounterTextField(
              hintText: 'العنوان',
              image: AppImage.selfie,
              maxLength: CreateTestCubit.titleMaxLength,
              currentLength: state.title.length,
              minLines: 1,
              maxLines: 1,
              onChanged: context.read<CreateTestCubit>().changeTitle,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            CreateTestCounterTextField(
              hintText: 'الوصف',
              image: AppImage.menu,
              maxLength: CreateTestCubit.descriptionMaxLength,
              currentLength: state.description.length,
              minLines: 1,
              maxLines: 3,
              height: SizeConfig.h(0.075),
              onChanged: context.read<CreateTestCubit>().changeDescription,
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.notes_outlined,
          size: SizeConfig.text(0.090),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
        SizedBox(width: SizeConfig.w(0.018)),
        CustomTextWidget(
          'العنوان و الوصف',
          fontSize: SizeConfig.text(0.043),
          fontWeight: FontWeight.w800,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class CreateTestCounterTextField extends StatelessWidget {
  final String hintText;
  final String image;
  final int maxLength;
  final int currentLength;
  final int minLines;
  final int maxLines;
  final double? height;
  final ValueChanged<String> onChanged;

  const CreateTestCounterTextField({
    super.key,
    required this.hintText,
    required this.image,
    required this.maxLength,
    required this.currentLength,
    required this.minLines,
    required this.maxLines,
    required this.onChanged,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: SizeConfig.h(0.057),
          child: TextField(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
            onChanged: onChanged,
            style: TextStyle(
              fontSize: SizeConfig.text(0.038),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              fontFamily: AppFont.elMessiriRegular,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(
                fontSize: SizeConfig.text(0.038),
                fontWeight: FontWeight.w500,
                color: AppPalette.greyMedium,
                fontFamily: AppFont.elMessiriRegular,
              ),
              filled: true,
              fillColor: isDark ? AppPalette.fieldColorNDark : AppPalette.white,

              contentPadding: EdgeInsets.only(
                right: SizeConfig.w(0.030),
                left: SizeConfig.w(0.020),
                top: SizeConfig.h(0.012),
                bottom: SizeConfig.h(0.012),
              ),

              suffixIcon: SizedBox(
                width: SizeConfig.w(0.105),
                child: Center(child: CustomAppImage(path: image)),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: appColors.primaryToPrimaryDark,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.003)),

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.w(0.010)),
            child: CustomTextWidget(
              '$maxLength/$currentLength',
              fontSize: SizeConfig.text(0.028),
              fontWeight: FontWeight.w700,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
