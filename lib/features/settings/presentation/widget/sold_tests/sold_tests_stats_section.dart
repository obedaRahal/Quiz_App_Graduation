import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';

class SoldTestsStatsSection extends StatelessWidget {
  final SoldTestsStatsEntity stats;

  const SoldTestsStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Row(
        children: [
          Expanded(
            child: _StatsCard(
              icon: Icons.shopping_bag_outlined,
              title: 'إجمالي المبيعات',
              value: stats.totalSalesCount.toString(),
              suffix: 'عملية',
            ),
          ),
          SizedBox(width: SizeConfig.w(0.025)),
          Expanded(
            child: _StatsCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'صافي الأرباح',
              value: _formatAmount(stats.totalSellerNetAmountSyp),
              suffix: 'ل.س',
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int value) {
    final valueText = value.toString();
    final buffer = StringBuffer();

    for (int index = 0; index < valueText.length; index++) {
      final positionFromEnd = valueText.length - index;

      buffer.write(valueText[index]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}

class _StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String suffix;

  const _StatsCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.015),
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: appColors.borderFieldColorNLightToborderFieldColorNDark,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.w(0.018)),
              decoration: BoxDecoration(
                color: appColors.primaryToPrimaryDark.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: appColors.primaryToPrimaryDark,
                size: SizeConfig.text(0.052),
              ),
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppPalette.greyMedium,
                    fontFamily: AppFont.elMessiriRegular,
                    fontSize: SizeConfig.text(0.027),
                  ),
                  SizedBox(height: SizeConfig.h(0.003)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        CustomTextWidget(
                          value,
                          color: appColors.blackTogreyMedium,
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.04),
                        ),
                        SizedBox(width: SizeConfig.w(0.008)),
                        CustomTextWidget(
                          suffix,
                          color: AppPalette.greyMedium,
                          fontSize: SizeConfig.text(0.025),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
