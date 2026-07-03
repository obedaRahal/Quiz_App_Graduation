import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/bottom_sheet/scientific_interests/my_profile_interest_card.dart';

class MyProfileInterestCategoryGroup extends StatelessWidget {
  final InterestCategoryEntity category;
  final Set<int> selectedIds;
  final ValueChanged<InterestItemEntity> onInterestTap;

  const MyProfileInterestCategoryGroup({
    super.key,
    required this.category,
    required this.selectedIds,
    required this.onInterestTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: SizeConfig.w(0.015),
            bottom: SizeConfig.h(0.012),
          ),
          child: CustomTextWidget(
            category.title,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.text(0.042),
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
            final interest = category.interests[index];

            return MyProfileInterestCard(
              interest: interest,
              isSelected: selectedIds.contains(interest.id),
              onTap: () => onInterestTap(interest),
            );
          },
        ),
      ],
    );
  }
}