import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';

class ContentPublisherSection extends StatelessWidget {
  final ContentPublisherUiData publisher;
  final bool isFollowing;
  final bool isFollowLoading;
  final VoidCallback? onFollowTap;

  const ContentPublisherSection({
    super.key,
    required this.publisher,
    required this.isFollowing,
    this.isFollowLoading = false,
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        ClipOval(
          child: SizedBox(
            width: SizeConfig.w(0.105),
            height: SizeConfig.w(0.105),
            child: CustomAppImage(
              path: publisher.avatarUrl.isEmpty
                  ? AppImage.carmen
                  : publisher.avatarUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(width: SizeConfig.w(0.025)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Flexible(
                    child: CustomTextWidget(
                      publisher.name,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      fontSize: SizeConfig.text(
                        0.034,
                      ).clamp(13.0, 16.0).toDouble(),
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFont.elMessiriRegular,
                    ),
                  ),
                  if (publisher.isVerified) ...[
                    SizedBox(width: SizeConfig.w(0.010)),
                    Icon(
                      Icons.verified_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: SizeConfig.text(0.036),
                    ),
                  ],
                ],
              ),
              SizedBox(height: SizeConfig.h(0.004)),
              CustomTextWidget(
                '${_formatCount(publisher.followingCount)} يتابع • '
                '${_formatCount(publisher.followersCount)} متابع • '
                '${publisher.publishedTestsCount} اختبار',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.025).clamp(9.0, 11.0).toDouble(),
                fontWeight: FontWeight.w600,
                fontFamily: AppFont.elMessiriRegular,
              ),
            ],
          ),
        ),

        SizedBox(width: SizeConfig.w(0.020)),

        InkWell(
          onTap: isFollowLoading ? null : onFollowTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.035),
              vertical: SizeConfig.h(0.006),
            ),
            decoration: BoxDecoration(
              color: isFollowing
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.2,
              ),
            ),
            child: isFollowLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : CustomTextWidget(
                    isFollowing ? 'تتابع' : 'متابعة',
                    color: isFollowing
                        ? isDark
                              ? AppPalette.black
                              : AppPalette.white
                        : Theme.of(context).colorScheme.primary,
                    fontSize: SizeConfig.text(
                      0.028,
                    ).clamp(10.0, 12.0).toDouble(),
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toString();
  }
}
