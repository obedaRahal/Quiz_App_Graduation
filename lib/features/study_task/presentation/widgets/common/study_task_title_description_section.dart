import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';

class StudyTaskTitleDescriptionSection extends StatelessWidget {
  final String title;
  final String description;

  final int titleMaxLength;
  final int descriptionMaxLength;

  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;

  final String sectionDescription;

  const StudyTaskTitleDescriptionSection({
    super.key,
    required this.title,
    required this.description,
    required this.titleMaxLength,
    required this.descriptionMaxLength,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    this.sectionDescription =
        'أضف عنواناً واضحاً ووصفاً مختصراً يشرح المهمة الدراسية.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _SectionTitle(),

        SizedBox(height: SizeConfig.h(0.006)),

        CustomTextWidget(
          sectionDescription,
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        CreateTestCounterTextField(
          value: title,
          hintText: 'العنوان',
          image: AppImage.selfie,
          maxLength: titleMaxLength,
          currentLength: title.length,
          minLines: 1,
          maxLines: 1,
          onChanged: onTitleChanged,
        ),

        SizedBox(height: SizeConfig.h(0.014)),

        CreateTestCounterTextField(
          value: description,
          hintText: 'الوصف',
          image: AppImage.menu,
          maxLength: descriptionMaxLength,
          currentLength: description.length,
          minLines: 1,
          maxLines: 3,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomTextWidget(
          'العنوان والوصف',
          fontSize: SizeConfig.text(0.043),
          fontWeight: FontWeight.w800,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.right,
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        Icon(
          Icons.notes_outlined,
          size: SizeConfig.text(0.090),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
      ],
    );
  }
}
