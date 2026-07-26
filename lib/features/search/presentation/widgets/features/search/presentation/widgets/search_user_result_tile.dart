import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SearchUserResultTile extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final String academicLevel;
  final bool isVerified;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback onUserTap;
  final VoidCallback onFollowTap;

  const SearchUserResultTile({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.academicLevel,
    required this.isVerified,
    required this.isFollowing,
    required this.isFollowLoading,
    required this.onUserTap,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onUserTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.025),
            vertical: SizeConfig.h(0.012),
          ),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : appColors.whiteToblack,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SearchUserAvatar(
                avatarUrl: avatarUrl,
              ),

              SizedBox(width: SizeConfig.w(0.03)),

              Expanded(
                child: _SearchUserInformation(
                  userName: userName,
                  academicLevel: academicLevel,
                  isVerified: isVerified,
                ),
              ),

              SizedBox(width: SizeConfig.w(0.025)),

              _SearchFollowButton(
                isFollowing: isFollowing,
                isLoading: isFollowLoading,
                onTap: onFollowTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchUserInformation extends StatelessWidget {
  final String userName;
  final String academicLevel;
  final bool isVerified;

  const _SearchUserInformation({
    required this.userName,
    required this.academicLevel,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CustomTextWidget(
                userName,
                color: appColors.blackToGrey2Dark,
                fontFamily: AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.034)
                    .clamp(13.0, 16.0)
                    .toDouble(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),

            if (isVerified) ...[
              SizedBox(width: SizeConfig.w(0.01)),
              Icon(
                Icons.verified_rounded,
                color: appColors.primaryToPrimaryDark,
                size: SizeConfig.text(0.041)
                    .clamp(16.0, 20.0)
                    .toDouble(),
              ),
            ],
          ],
        ),

        if (academicLevel.trim().isNotEmpty) ...[
          SizedBox(height: SizeConfig.h(0.005)),

          Align(
            alignment: Alignment.centerRight,
            child: CustomBackgroundWithChild(
              childHorizontalPad: SizeConfig.w(0.018),
              childVerticalPad: SizeConfig.h(0.004),
              borderRadius: BorderRadius.circular(5),
              backgroundColor:
                  appColors.primarySoftTogreyLightDark,
              child: CustomTextWidget(
                academicLevel,
                color: appColors.primaryToPrimaryDark,
                fontFamily: AppFont.elMessiriRegular,
                fontSize: SizeConfig.text(0.025)
                    .clamp(10.0, 12.0)
                    .toDouble(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ],
    );
  }
}


class _SearchUserAvatar extends StatelessWidget {
  final String avatarUrl;

  const _SearchUserAvatar({
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final hasAvatar =
        avatarUrl.trim().isNotEmpty;

    return Container(
      width: SizeConfig.w(0.13),
      height: SizeConfig.w(0.13),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.grey,
        border: Border.all(
          color: appColors
              .borderFieldColorNLightToborderFieldColorNDark,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: hasAvatar
            ? CustomAppImage(
                width: double.infinity,
                fit: BoxFit.cover,
                path: avatarUrl,
              )
            : Icon(
                Icons.person_rounded,
                color: AppPalette.greyMedium,
                size: SizeConfig.w(0.065),
              ),
      ),
    );
  }
}



class _SearchFollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onTap;

  const _SearchFollowButton({
    required this.isFollowing,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      onTap: isLoading ? (){} : onTap,
      backgroundColor: isFollowing
          ? appColors.borderFieldColorNLightToborderFieldColorNDark
          : appColors.primaryToPrimaryDark,
      borderRadius: 16,
      childHorizontalPad: SizeConfig.w(0.028),
      childVerticalPad: SizeConfig.h(0.0065),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? SizedBox(
                key: const ValueKey('loading'),
                width: SizeConfig.w(0.035),
                height: SizeConfig.w(0.035),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isFollowing
                      ? appColors.blackToGrey2Dark
                      : AppPalette.white,
                ),
              )
            : CustomTextWidget(
                key: ValueKey(isFollowing),
                isFollowing
                    ? 'إلغاء المتابعة'
                    : 'متابعة',
                color: isFollowing
                    ? appColors.blackToGrey2Dark
                    : AppPalette.white,
                fontFamily:
                    AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.027)
                    .clamp(10.0, 13.0)
                    .toDouble(),
                maxLines: 1,
              ),
      ),
    );
  }
}