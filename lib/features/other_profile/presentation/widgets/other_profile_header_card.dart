import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_overview_entity.dart';

class OtherProfileHeaderCard extends StatelessWidget {
  final OtherProfileHeaderEntity profile;
  final VoidCallback onFollowTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;
  const OtherProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onFollowTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: BorderRadius.circular(14),
      // boxShadow: [
      //   BoxShadow(
      //     color: AppPalette.greyBorderCart.withOpacity(0.7),
      //     blurRadius: 5,
      //     offset: const Offset(0, 2),
      //   ),
      // ],
      child: Column(
        children: [
          _OtherProfileCoverAndAvatar(
            avatarUrl: profile.avatarUrl,
            coverUrl: profile.coverUrl,
          ),

          Transform.translate(
            offset: Offset(-SizeConfig.w(0.25), SizeConfig.h(0.005)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                _OtherProfileNameRow(
                  name: profile.name,
                  isAcademicallyVerified: profile.isAcademicallyVerified,
                ),

                SizedBox(height: SizeConfig.h(0.004)),

                // _OtherProfileStatsText(
                //   testsCount: profile.testsCount,
                //   listsCount: profile.followingCount,
                //   followersCount: profile.followersCount,
                // ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    _PublisherStat(
                      label: "اختبار",
                      value: "${profile.publishedTestsCount}",
                    ),
                    _DotSeparator(),
                    _PublisherStat(
                      label: "يتابع",
                      value: "${profile.followingCount}",
                      onTap: onFollowingTap,
                    ),
                    _DotSeparator(),
                    _PublisherStat(
                      label: "متابع",
                      value: "${profile.followersCount}",
                      onTap: onFollowersTap,
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.h(0.01)),

                _OtherProfileFollowButton(
                  isFollowing: profile.viewerIsFollowing,
                  onTap: onFollowTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherProfileCoverAndAvatar extends StatelessWidget {
  final String avatarUrl;
  final String coverUrl;

  const _OtherProfileCoverAndAvatar({
    required this.avatarUrl,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
        final appColors = context.appColors;

    return SizedBox(
      height: SizeConfig.h(0.16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
                bottom: Radius.circular(14),
              ),
              child:
                  // coverUrl.trim().isEmpty
                  //     ? CustomPaint(painter: _OtherProfileCoverPainter())
                  //     :
                  CustomAppImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    path: coverUrl,
                  ),
            ),
          ),

          Positioned(
            right: SizeConfig.w(0.04),
            bottom: -SizeConfig.w(0.095),
            child: Container(
              width: SizeConfig.w(0.19),
              height: SizeConfig.w(0.19),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.grey,
                border: Border.all(color: appColors.whiteToblack, width: 3),
              ),
              child: ClipOval(
                child: avatarUrl.trim().isEmpty
                    ? Icon(
                        Icons.person,
                        size: SizeConfig.w(0.09),
                        color: AppPalette.greyMedium,
                      )
                    : CustomAppImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        path: avatarUrl,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherProfileNameRow extends StatelessWidget {
  final String name;
  final bool isAcademicallyVerified;

  const _OtherProfileNameRow({
    required this.name,
    required this.isAcademicallyVerified,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      //mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConfig.w(0.6)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: CustomTextWidget(
                name,
                color: appColors.blackTogreyMedium,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.037),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),

        if (isAcademicallyVerified) ...[
          SizedBox(width: SizeConfig.w(0.012)),
          Icon(
            Icons.verified_rounded,
            color: appColors.primaryToPrimaryDark,
            size: SizeConfig.w(0.045),
          ),
        ],
      ],
    );
  }
}

class _OtherProfileFollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;

  const _OtherProfileFollowButton({
    required this.isFollowing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      onTap: onTap,
      backgroundColor: isFollowing
          ? appColors.greyToGreyMediumDark
          : appColors.primaryToPrimaryDark,
      borderRadius: 6,
      childHorizontalPad: SizeConfig.w(0.06),
      childVerticalPad: SizeConfig.h(0.0055),
      child: CustomTextWidget(
        isFollowing ? 'إلغاء المتابعة' : 'متابعة',
        color: isFollowing ? appColors.blackToGrey2Dark :appColors.whiteToblack,
        fontFamily: AppFont.elMessiriBold,
        fontSize: SizeConfig.text(0.026),
      ),
    );
  }
}


class _PublisherStat extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _PublisherStat({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          CustomTextWidget(
            value,
            color: appColors.blackToGrey2Dark,
            fontSize: SizeConfig.text(0.035),
            fontFamily: AppFont.elMessiriBold,
          ),
          SizedBox(width: 3),
          CustomTextWidget(
            label,
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.032),
          ),
        ],
      ),
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      "•",
      color: AppPalette.greyMedium,
      fontSize: SizeConfig.text(0.035),
    );
  }
}
