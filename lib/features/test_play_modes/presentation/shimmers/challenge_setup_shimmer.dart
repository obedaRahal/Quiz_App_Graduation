import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ChallengeSetupShimmer extends StatelessWidget {
  const ChallengeSetupShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.h(0.035)),



        SizedBox(height: SizeConfig.h(0.018)),

        AppShimmerBox(
          width: SizeConfig.w(0.86),
          height: SizeConfig.h(0.2),
          borderRadius: 20,
        ),

        SizedBox(height: SizeConfig.h(0.03)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: AppShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.48),
            borderRadius: 24,
          ),
        ),
      ],
    );
  }
}