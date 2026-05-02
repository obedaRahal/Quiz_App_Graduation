import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tap/test_info_details_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tap/test_publisher_card.dart';

class TestOverviewTab extends StatelessWidget {
  const TestOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const TestPublisherCard(),

        Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),

        const TestInfoDetailsSection(),
      ],
    );
  }
}



