import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

class LaboratoryExamSessionCard extends StatelessWidget {
  final TestByInterestEntity item;
  final double? horizonMargin;
  const LaboratoryExamSessionCard({
    super.key,
    required this.item,
    this.horizonMargin = 0.035,
  });

  Color _difficultyColor() {
    switch (item.difficultyLevel.trim()) {
      case 'سهل':
        return AppPalette.green;
      case 'متوسط':
        return AppPalette.orange;
      case 'صعب':
        return AppPalette.red;
      default:
        return AppPalette.greyMedium;
    }
  }

  String get priceText {
    if (item.price == 0) return '0';
    return item.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRouterName.detailsOfTest,
            extra: DetailsOfTestRouteArgs(testId: item.id),
          );
        },
        child: Container(
          height: SizeConfig.h(0.17),
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(horizonMargin ?? 0.035),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipPath(
            clipper: _ExamTicketClipper(),
            child: Container(
              color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.026),
                vertical: SizeConfig.h(0.014),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _SessionPricePanel(
                      item: item,
                      priceText: priceText,
                      isDark: isDark,
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.010)),

                  _DashedVerticalDivider(isDark: isDark),

                  SizedBox(width: SizeConfig.w(0.010)),

                  Expanded(
                    flex: 7,
                    child: _SessionInfoPanel(
                      item: item,
                      isDark: isDark,
                      difficultyColor: _difficultyColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionInfoPanel extends StatelessWidget {
  final TestByInterestEntity item;
  final bool isDark;
  final Color difficultyColor;

  const _SessionInfoPanel({
    required this.item,
    required this.isDark,
    required this.difficultyColor,
  });
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _InnerLeftPanelClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.035),
          vertical: SizeConfig.h(0.012),
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF3F6FF),
          // borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomTextWidget(
                    item.title,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.text(0.038),
                    color: const Color(0xFF4F7DFF),
                  ),
                ),
                const Spacer(),
                _DifficultyBadge(
                  text: item.difficultyLevel,
                  color: difficultyColor,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.009)),
            CustomTextWidget(
              item.description,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: SizeConfig.text(0.028),
              color: isDark
                  ? AppPalette.titleWhiteINDark
                  : const Color(0xFF4E5665),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      _BlueTag(
                        text: item.interests.isEmpty
                            ? 'عام'
                            : item.interests.first.name,
                      ),

                      SizedBox(width: SizeConfig.w(0.010)),

                      if (item.interests.length > 1)
                        _BlueTag(text: item.interests[1].name),
                    ],
                  ),
                ),

                SizedBox(width: SizeConfig.w(0.010)),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _FooterInfo(
                          icon: Icons.timer_outlined,
                          iconSize: SizeConfig.text(0.032).clamp(14.0, 18.0),
                          fontSize: SizeConfig.text(0.032).clamp(12.0, 15.0),
                          text: item.publishedAgo,
                          isDark: isDark,
                        ),
                      ),

                      SizedBox(width: SizeConfig.w(0.010)),

                      Expanded(
                        flex: 2,
                        child: _FooterInfo(
                          icon: Icons.edit_note_rounded,
                          iconSize: SizeConfig.text(0.028).clamp(11.0, 16.0),
                          fontSize: SizeConfig.text(0.024).clamp(9.0, 12.0),
                          text: '${item.questionCount} سؤال',
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionPricePanel extends StatelessWidget {
  final TestByInterestEntity item;
  final String priceText;
  final bool isDark;

  const _SessionPricePanel({
    required this.item,
    required this.priceText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _InnerRightPanelClipper(),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.012),
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF7F7F7),
          //borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  priceText,
                  fontSize: SizeConfig.text(0.05),
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : const Color(0xFF26323D),
                ),
                CustomTextWidget(
                  'ليرة سورية',
                  fontSize: SizeConfig.text(0.025),
                  color: AppPalette.greyMedium,
                ),
                SizedBox(height: SizeConfig.h(0.018)),
                CustomTextWidget(
                  'التقييم',
                  fontSize: SizeConfig.text(0.034),
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : const Color(0xFF26323D),
                ),
                SizedBox(height: SizeConfig.h(0.004)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      item.averageRating.toStringAsFixed(1),
                      fontSize: SizeConfig.text(0.032),
                      color: AppPalette.greyMedium,
                    ),
                    SizedBox(width: SizeConfig.w(0.01)),
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _DifficultyBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.002),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomTextWidget(
        text,
        fontSize: SizeConfig.text(0.025),
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class _BlueTag extends StatelessWidget {
  final String text;

  const _BlueTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.018),
            vertical: SizeConfig.h(0.003),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF4F7DFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomTextWidget(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConfig.text(0.022).clamp(8.0, 11.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;
  final double iconSize;

  final bool isDark;

  const _FooterInfo({
    required this.icon,
    required this.text,
    required this.isDark,
    required this.fontSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize,
            color: isDark
                ? AppPalette.titleWhiteINDark
                : const Color(0xFF26323D),
          ),
          SizedBox(width: SizeConfig.w(0.004)),
          Icon(icon, size: iconSize, color: const Color(0xFF26323D)),
        ],
      ),
    );
  }
}

class _DashedVerticalDivider extends StatelessWidget {
  final bool isDark;

  const _DashedVerticalDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxHeight / 12).floor();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (_) => Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : const Color(0xFFB8BEC8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExamTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;
    const topCutRadius = 8.0;

    // كبّر/صغّر هذا الرقم
    final sideCutRadius = size.height * 0.15;

    final path = Path()..moveTo(corner, 0);

    final topCuts = [0.08, 0.22, 0.36, 0.50, 0.64];

    for (final ratio in topCuts) {
      final centerX = size.width * ratio;
      path.lineTo(centerX - topCutRadius, 0);
      path.arcToPoint(
        Offset(centerX + topCutRadius, 0),
        radius: const Radius.circular(topCutRadius),
        clockwise: false,
      );
    }

    path
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      );

    for (final ratio in topCuts.reversed) {
      final centerX = size.width * ratio;
      path.lineTo(centerX + topCutRadius, size.height);
      path.arcToPoint(
        Offset(centerX - topCutRadius, size.height),
        radius: const Radius.circular(topCutRadius),
        clockwise: false,
      );
    }

    path
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    // القص الجانبي اليمين
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: sideCutRadius,
      ),
    );

    // القص الجانبي اليسار
    path.addOval(
      Rect.fromCircle(
        center: Offset(0, size.height / 2),
        radius: sideCutRadius,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _InnerLeftPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;

    final path = Path()
      ..moveTo(corner, 0)
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      )
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    path.addOval(
      Rect.fromCenter(
        center: Offset(0, size.height / 2),
        width: size.width * 0.18,
        height: size.height * 0.45,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _InnerRightPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;

    final path = Path()
      ..moveTo(corner, 0)
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      )
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width, size.height / 2),
        width: size.width * 0.45,
        height: size.height * 0.45,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
