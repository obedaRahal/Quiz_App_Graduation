import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_info_details_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_publisher_card.dart';

class TestOverviewTab extends StatelessWidget {
  final String creatorName;
  final String creatorProfilePicture;
  final bool isCreatorVerified;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final bool isFollowingCreator;

  final int questionCount;
  final int? durationSeconds;
  final int? passMarkPercentage;
  final String publishedAt;
  final String lastContentUpdatedAt;
  final String targetLevel;
  final String language;
  final int participantsCount;
  final VoidCallback onFollowTap;

  //final String reviewStatus;
  final List<String> interests;

  const TestOverviewTab({
    super.key,
    required this.creatorName,
    required this.creatorProfilePicture,
    required this.isCreatorVerified,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.isFollowingCreator,
    required this.questionCount,
    this.durationSeconds,
    this.passMarkPercentage,
    required this.publishedAt,
    required this.lastContentUpdatedAt,
    required this.targetLevel,
    required this.language,
    required this.participantsCount,
    //required this.reviewStatus,
    required this.interests,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isCreatorVerified) ...[
          Center(
            child: CustomBackgroundWithChild(
              backgroundColor: AppPalette.red.withOpacity(0.12),
              childHorizontalPad: SizeConfig.w(0.02),
              childVerticalPad: SizeConfig.h(0.01),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppPalette.red),
              child: CustomTextWidget(
                "هذا المحتوى طلابي وليس من صاحب معلومة موثق",
                color: AppPalette.red,
                fontSize: SizeConfig.text(0.04),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.h(.02),)

        ],
        TestPublisherCard(
          name: creatorName,
          profilePicture: creatorProfilePicture,
          isVerified: isCreatorVerified,
          followersCount: followersCount,
          followingCount: followingCount,
          publishedTestsCount: publishedTestsCount,
          isFollowing: isFollowingCreator,
          onFollowTap: onFollowTap,
        ),

        CustomDivider(height: 30, thickness: 3),

        TestInfoDetailsSection(
          questionCount: questionCount,
          durationSeconds: durationSeconds,
          passMarkPercentage: passMarkPercentage,
          publishedAt: publishedAt,
          lastContentUpdatedAt: lastContentUpdatedAt,
          targetLevel: targetLevel,
          language: language,
          participantsCount: participantsCount,
          //reviewStatus: reviewStatus,
          interests: interests,
        ),
      ],
    );
  }
}
