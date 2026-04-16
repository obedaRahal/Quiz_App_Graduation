import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../../../../../../core/theme/assets/fonts.dart';
import '../../../../../../core/theme/color/app_colors.dart';
import '../../../../../../core/utils/media_query_config.dart';
import 'interest_chip_item.dart';
import 'interests_models.dart';

class SelectedInterestsWrap extends StatelessWidget {
  final List<InterestOption> selectedItems;
  final ValueChanged<InterestOption> onRemove;

  const SelectedInterestsWrap({
    super.key,
    required this.selectedItems,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'الاهتمامات المختارة',
          color: AppPalette.black,
          fontSize: SizeConfig.text(0.04),
          fontFamily: AppFont.elMessiriSemiBold,
        ),
        SizedBox(height: SizeConfig.h(0.012)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.012),
          ),
          decoration: BoxDecoration(
            color: AppPalette.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: SizeConfig.w(0.02),
            runSpacing: SizeConfig.h(0.012),
            children: selectedItems.map((item) {
              return InterestChipItem(
                label: item.name,
                isSelected: true,
                onTap: () => onRemove(item),
                onRemove: () => onRemove(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}