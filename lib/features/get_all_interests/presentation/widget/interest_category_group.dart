import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/widget/interest_card.dart';

class InterestCategoryGroup extends StatelessWidget {
  final InterestCategoryEntity category;

  const InterestCategoryGroup({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.h(0.01),
            right: SizeConfig.w(0.015),
            bottom: SizeConfig.h(0.012),
          ),
          child: CustomTextWidget(
            category.title,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.text(0.045),
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
            textAlign: TextAlign.right,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.interests.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: SizeConfig.h(0.014),
            crossAxisSpacing: SizeConfig.w(0.035),
            childAspectRatio: 3.2,
          ),
          itemBuilder: (context, index) {
            return InterestCard(interest: category.interests[index]);
          },
        ),
      ],
    );
  }
}
