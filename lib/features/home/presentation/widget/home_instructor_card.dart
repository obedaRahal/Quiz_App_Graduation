import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/data/models/home_instructor_model.dart';

class InstructorCard extends StatelessWidget {
  final InstructorModel item;

  const InstructorCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xffF2F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomAppImage(path: AppImage.carmen, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            item.name,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.035),
            color: isDark ? AppPalette.titleWhiteINDark : AppPalette.greyMedium,
          ),
        ],
      ),
    );
  }
}
