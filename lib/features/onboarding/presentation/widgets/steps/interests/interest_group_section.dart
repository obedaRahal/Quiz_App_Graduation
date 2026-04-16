import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../../../../../../core/theme/assets/fonts.dart';
import '../../../../../../core/theme/color/app_colors.dart';
import '../../../../../../core/utils/media_query_config.dart';
import 'interest_chip_item.dart';
import 'interests_models.dart';

class InterestGroupSection extends StatelessWidget {
  final InterestGroupOption group;
  final List<int> selectedInterestIds;
  final ValueChanged<InterestOption> onToggle;

  const InterestGroupSection({
    super.key,
    required this.group,
    required this.selectedInterestIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (group.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          group.title,
          color: AppPalette.black,
          fontSize: SizeConfig.text(0.045),
          fontFamily: AppFont.elMessiriSemiBold,
        ),
        SizedBox(height: SizeConfig.h(0.012)),
        Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: SizeConfig.w(0.02),
          runSpacing: SizeConfig.h(0.012),
          children: group.items.map((item) {
            final isSelected = selectedInterestIds.contains(item.id);

            return InterestChipItem(
              label: item.name,
              isSelected: isSelected,
              onTap: () => onToggle(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}