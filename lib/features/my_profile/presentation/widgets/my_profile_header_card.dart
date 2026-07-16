import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';

class MyProfileHeaderCard extends StatelessWidget {
  final MyProfileEntity profile;
  final VoidCallback? onChangeAvatarTap;
  final VoidCallback? onChangeCoverTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onShowSavedTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const MyProfileHeaderCard({
    super.key,
    required this.profile,
    this.onChangeAvatarTap,
    this.onChangeCoverTap,
    this.onShareTap,
    this.onShowSavedTap,
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.h(0.16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        onTap: onChangeCoverTap,
                        borderRadius: BorderRadius.circular(14),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                            bottom: Radius.circular(14),
                          ),
                          child: profile.coverUrl.trim().isEmpty
                              ? Container(
                                  color: AppPalette.greyLight,
                                  child: Center(
                                    child: CustomTextWidget(
                                      'أضف صورة غلاف خاصة بك +',
                                      color: AppPalette.greyMedium,
                                      fontSize: SizeConfig.text(0.028),
                                    ),
                                  ),
                                )
                              : CustomAppImage(
                                  path: profile.coverUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: SizeConfig.w(0.04),
                      bottom: -SizeConfig.w(0.095),
                      child: IgnorePointer(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: SizeConfig.w(0.19),
                              height: SizeConfig.w(0.19),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppPalette.grey,
                                border: Border.all(
                                  color: appColors.whiteToblack,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: profile.avatarUrl.trim().isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: SizeConfig.w(0.09),
                                        color: AppPalette.greyMedium,
                                      )
                                    : CustomAppImage(
                                        path: profile.avatarUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(SizeConfig.w(0.008)),
                                decoration: BoxDecoration(
                                  color: appColors.primaryToPrimaryDark,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: appColors.whiteToblack,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: appColors.whiteToblack,
                                  size: SizeConfig.w(0.032),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Transform.translate(
                offset: Offset(-SizeConfig.w(0.25), SizeConfig.h(0.005)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: SizeConfig.w(0.6),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: CustomTextWidget(
                                profile.name,
                                color: appColors.blackToGrey2Dark,
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
                        if (profile.isAcademicallyVerified) ...[
                          SizedBox(width: SizeConfig.w(0.012)),
                          Icon(
                            Icons.verified_rounded,
                            color: appColors.primaryToPrimaryDark,
                            size: SizeConfig.w(0.045),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: SizeConfig.h(0.004)),

                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        _ProfileStat(
                          label: 'اختبار',
                          value: profile.testsCount,
                        ),
                        const _DotSeparator(),
                        _ProfileStat(
                          label: 'يتابع',
                          value: profile.followingCount,
                          onTap: onFollowingTap,
                        ),
                        const _DotSeparator(),
                        _ProfileStat(
                          label: 'متابع',
                          value: profile.followersCount,
                          onTap: onFollowersTap,
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.h(0.01)),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        _HeaderSmallButton(
                          title: 'مشاركة الملف',
                          backgroundColor: appColors.primaryToPrimaryDark,
                          textColor: appColors.whiteToblack,
                          onTap: onShareTap,
                        ),
                        SizedBox(width: SizeConfig.w(0.018)),
                        _HeaderSmallButton(
                          title: 'قائمة المحفوظات',
                          backgroundColor: appColors.greyToGreyMediumDark,
                          textColor: appColors.greyMediumTogrey,
                          onTap: onShowSavedTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            right: SizeConfig.w(0.04),
            top: SizeConfig.h(0.16) - SizeConfig.w(0.095),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onChangeAvatarTap,
              child: SizedBox(
                width: SizeConfig.w(0.18),
                height: SizeConfig.w(0.18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ProfileStat({required this.label, required this.value, this.onTap});

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
      '•',
      color: AppPalette.greyMedium,
      fontSize: SizeConfig.text(0.035),
    );
  }
}

class _HeaderSmallButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const _HeaderSmallButton({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.0045),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: CustomTextWidget(
          title,
          color: textColor,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.024),
        ),
      ),
    );
  }
}
