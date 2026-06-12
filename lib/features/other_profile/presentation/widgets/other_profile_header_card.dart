import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileHeaderCard extends StatelessWidget {
  final OtherProfileUiModel profile;
  final VoidCallback onFollowTap;

  const OtherProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onFollowTap,
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
                      value: "${profile.testsCount}",
                    ),
                    _DotSeparator(),
                    _PublisherStat(
                      label: "يتابع",
                      value: "${profile.followingCount}",
                    ),
                    _DotSeparator(),
                    _PublisherStat(
                      label: "متابع",
                      value: "${profile.followersCount}",
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.h(0.01)),

                _OtherProfileFollowButton(
                  isFollowing: profile.isFollowing,
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
              child: coverUrl.trim().isEmpty
                  ? CustomPaint(painter: _OtherProfileCoverPainter())
                  : CustomAppImage(
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
                border: Border.all(color: AppPalette.white, width: 3),
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
        color: isFollowing ? appColors.blackToGrey2Dark : AppPalette.white,
        fontFamily: AppFont.elMessiriBold,
        fontSize: SizeConfig.text(0.026),
      ),
    );
  }
}

class _OtherProfileCoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = const Color(0xFFB8D4CF)
      ..style = PaintingStyle.fill;

    final patternPaint = Paint()
      ..color = const Color(0xFFF4F4F4)
      ..style = PaintingStyle.fill;

    final orangePaint = Paint()
      ..color = const Color(0xFFE8A236)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, basePaint);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.48, 0)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.45,
        size.width * 0.02,
        size.height * 0.55,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, patternPaint);

    final stones = [
      Offset(size.width * 0.08, size.height * 0.18),
      Offset(size.width * 0.18, size.height * 0.36),
      Offset(size.width * 0.30, size.height * 0.20),
      Offset(size.width * 0.38, size.height * 0.08),
      Offset(size.width * 0.24, size.height * 0.58),
    ];

    for (int i = 0; i < stones.length; i++) {
      final paint = i.isEven ? orangePaint : basePaint;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: stones[i],
            width: size.width * 0.045,
            height: size.height * 0.10,
          ),
          const Radius.circular(6),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PublisherStat extends StatelessWidget {
  final String label;
  final String value;

  const _PublisherStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
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
