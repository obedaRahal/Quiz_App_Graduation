import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';

class SoldTestSaleCard extends StatelessWidget {
  final SoldTestSaleEntity sale;

  const SoldTestSaleCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.014),
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.045) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PurchaseInformationSection(sale: sale, isDark: isDark),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.018)),
              child: _DashedVerticalDivider(
                isDark: isDark,
                height: SizeConfig.h(0.23),
              ),
            ),

            Expanded(
              child: _TestInformationSection(sale: sale, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseInformationSection extends StatelessWidget {
  final SoldTestSaleEntity sale;
  final bool isDark;

  const _PurchaseInformationSection({required this.sale, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'معلومات الشراء'),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuyerImage(imageUrl: sale.purchase.buyerAvatarUrl),

            SizedBox(width: SizeConfig.w(0.018)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextWidget(
                          sale.purchase.buyerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: isDark
                              ? AppPalette.textWhiteINDark
                              : const Color(0xFF303640),
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.033),
                        ),
                      ),

                      if (sale.purchase.buyerIsAcademicallyVerified) ...[
                        SizedBox(width: SizeConfig.w(0.008)),
                        Icon(
                          Icons.verified_rounded,
                          color: const Color(0xFF5F89FF),
                          size: SizeConfig.text(0.038),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: SizeConfig.h(0.004)),

                  _PurchaseDetailText(
                    title: 'تاريخ الشراء',
                    value: sale.purchase.purchasedDate,
                    isDark: isDark,
                  ),

                  SizedBox(height: SizeConfig.h(0.002)),

                  _PurchaseDetailText(
                    title: 'الساعة',
                    value: sale.purchase.purchasedTime,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        Row(
          children: [
            Expanded(
              child: _FinancialInfoItem(
                icon: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFFFFC15A),
                title: 'السعر',
                value: _formatAmount(sale.purchase.grossAmount),
              ),
            ),
            Expanded(
              child: _FinancialInfoItem(
                icon: Icons.percent_rounded,
                iconColor: const Color(0xFFFF6262),
                title: 'الضريبة',
                value: _formatAmount(sale.purchase.platformFeeAmount),
              ),
            ),
            Expanded(
              child: _FinancialInfoItem(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF62DC69),
                title: 'الربح',
                value: _formatAmount(sale.purchase.sellerNetAmount),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TestInformationSection extends StatelessWidget {
  final SoldTestSaleEntity sale;
  final bool isDark;

  const _TestInformationSection({required this.sale, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: 'معلومات الاختبار'),

        SizedBox(height: SizeConfig.h(0.012)),

        CustomTextWidget(
          sale.test.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: isDark ? AppPalette.textWhiteINDark : const Color(0xFF303640),
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.036),
          textAlign: TextAlign.right,
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        CustomTextWidget(
          sale.test.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: AppPalette.greyMedium,
          fontFamily: AppFont.elMessiriRegular,
          fontSize: SizeConfig.text(0.026),
          textAlign: TextAlign.right,
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        _InterestsRow(interests: sale.test.interests),

        SizedBox(height: SizeConfig.h(0.018)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TestInfoItem(
                title: 'المستوى',
                value: sale.test.targetLevel,
                valueColor: _levelColor(sale.test.targetLevel),
              ),
            ),
            _SmallVerticalDivider(isDark: isDark),
            Expanded(
              child: _TestInfoItem(
                title: 'الأسئلة',
                value: sale.test.questionCount.toString(),
              ),
            ),
            _SmallVerticalDivider(isDark: isDark),
            _RatingInfoItem(rating: sale.test.averageRating),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextWidget(
          title,
          color: const Color(0xFF5F89FF),
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.038),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        Container(
          height: 1,
          color: const Color(0xFF5F89FF).withValues(alpha: 0.22),
        ),
      ],
    );
  }
}

class _BuyerImage extends StatelessWidget {
  final String imageUrl;

  const _BuyerImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: SizeConfig.w(0.105),
        height: SizeConfig.w(0.105),
        color: AppPalette.grey,
        child: imageUrl.trim().isEmpty
            ? Icon(
                Icons.person_rounded,
                color: AppPalette.greyMedium,
                size: SizeConfig.text(0.07),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.07),
                  );
                },
              ),
      ),
    );
  }
}

class _PurchaseDetailText extends StatelessWidget {
  final String title;
  final String value;
  final bool isDark;

  const _PurchaseDetailText({
    required this.title,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextWidget(
          '$title: ',
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.024),
        ),
        Expanded(
          child: CustomTextWidget(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: isDark
                ? AppPalette.titleWhiteINDark
                : const Color(0xFF626975),
            fontSize: SizeConfig.text(0.024),
          ),
        ),
      ],
    );
  }
}

class _FinancialInfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _FinancialInfoItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.w(0.012)),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: SizeConfig.text(0.038)),
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        CustomTextWidget(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: isDark ? AppPalette.textWhiteINDark : const Color(0xFF343A45),
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.027),
        ),

        SizedBox(height: SizeConfig.h(0.001)),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomTextWidget(
            value,
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.024),
          ),
        ),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomTextWidget(
            ' ل.س',
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.024),
          ),
        ),
      ],
    );
  }
}

class _InterestsRow extends StatelessWidget {
  final List<String> interests;

  const _InterestsRow({required this.interests});

  @override
  Widget build(BuildContext context) {
    final visibleInterests = interests.take(2).toList();
    final remainingCount = interests.length - visibleInterests.length;

    if (interests.isEmpty) {
      return const _InterestChip(text: '# عام');
    }

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: SizeConfig.w(0.012),
      runSpacing: SizeConfig.h(0.005),
      children: [
        ...visibleInterests.map((interest) {
          return _InterestChip(text: '# $interest');
        }),
        if (remainingCount > 0) _InterestChip(text: '...'),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String text;

  const _InterestChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.w(0.18)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.018),
        vertical: SizeConfig.h(0.004),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5F89FF).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomTextWidget(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: const Color(0xFF5F89FF),
        fontSize: SizeConfig.text(0.022),
      ),
    );
  }
}

class _TestInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _TestInfoItem({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        CustomTextWidget(
          title,
          color: isDark ? AppPalette.textWhiteINDark : const Color(0xFF343A45),
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.027),
        ),
        SizedBox(height: SizeConfig.h(0.002)),
        CustomTextWidget(
          value.trim().isEmpty ? 'غير محدد' : value,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          color: valueColor ?? AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.024),
        ),
      ],
    );
  }
}

class _RatingInfoItem extends StatelessWidget {
  final num rating;

  const _RatingInfoItem({required this.rating});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        CustomTextWidget(
          'التقييم',
          color: isDark ? AppPalette.textWhiteINDark : const Color(0xFF343A45),
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.027),
        ),
        SizedBox(height: SizeConfig.h(0.002)),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
              SizedBox(width: SizeConfig.w(0.005)),
              CustomTextWidget(
                rating.toStringAsFixed(1),
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.024),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallVerticalDivider extends StatelessWidget {
  final bool isDark;

  const _SmallVerticalDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: SizeConfig.h(0.043),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.012)),
      color: isDark
          ? AppPalette.borderFieldColorNDark
          : const Color(0xFFD9DCE2),
    );
  }
}

class _DashedVerticalDivider extends StatelessWidget {
  final bool isDark;
  final double height;

  const _DashedVerticalDivider({required this.isDark, required this.height});

  @override
  Widget build(BuildContext context) {
    const dashHeight = 7.0;
    const dashSpace = 5.0;

    final dashCount = (height / (dashHeight + dashSpace)).floor();

    return SizedBox(
      width: 2,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (index) {
          return Container(
            width: 2,
            height: dashHeight,
            decoration: BoxDecoration(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : const Color(0xFFD6D9DF),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
      ),
    );
  }
}

String _formatAmount(num amount) {
  final value = amount.round().toString();
  final buffer = StringBuffer();

  for (int index = 0; index < value.length; index++) {
    final positionFromEnd = value.length - index;

    buffer.write(value[index]);

    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }

  return buffer.toString();
}

Color _levelColor(String level) {
  switch (level.trim()) {
    case 'مبتدئ':
    case 'سهل':
      return AppPalette.green;

    case 'متوسط':
      return AppPalette.orange;

    case 'متقدم':
    case 'صعب':
      return AppPalette.red;

    default:
      return AppPalette.greyMedium;
  }
}
