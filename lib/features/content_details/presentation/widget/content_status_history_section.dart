import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';

class ContentStatusHistorySection extends StatelessWidget {
  final List<ContentStatusHistoryUiData> history;
  final String reviewStatus;

  const ContentStatusHistorySection({
    super.key,
    required this.history,
    required this.reviewStatus,
  });

  @override
  Widget build(BuildContext context) {
    final items = history.isNotEmpty
        ? history
        : reviewStatus.trim().isEmpty
        ? const <ContentStatusHistoryUiData>[]
        : [
            ContentStatusHistoryUiData(
              id: 0,
              toStatus: reviewStatus.trim(),
              note: '',
              happenedAt: '',
            ),
          ];

    if (items.isEmpty) return const SizedBox.shrink();

    final current = items.first;
    final previous = items.skip(1).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionDivider(),
        _SectionTitle(title: 'الحالة الحالية'),
        SizedBox(height: SizeConfig.h(0.012)),
        _StatusCard(item: current, isCurrent: true),
        if (previous.isNotEmpty) ...[
          SizedBox(height: SizeConfig.h(0.022)),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.55),
          ),
          SizedBox(height: SizeConfig.h(0.010)),
          _SectionTitle(title: 'الحالات السابقة'),
          SizedBox(height: SizeConfig.h(0.012)),
          ...previous.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
              child: _StatusCard(item: item, isCurrent: false),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor.withValues(alpha: 0.8);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.020)),
      child: Row(
        children: List.generate(
          12,
          (_) => Expanded(
            child: Container(
              height: 1.4,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.006)),
              color: dividerColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppFont.elMessiriBold,
        color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,
        fontSize: SizeConfig.text(0.050).clamp(19.0, 25.0).toDouble(),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final ContentStatusHistoryUiData item;
  final bool isCurrent;

  const _StatusCard({required this.item, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = _StatusVisualStyle.fromStatus(item.toStatus);
    final fromStatus = item.fromStatus?.trim() ?? '';
    final showTransition =
        fromStatus.isNotEmpty && fromStatus != item.toStatus.trim();

    final borderColor = isCurrent
        ? style.color
        : Theme.of(context).dividerColor.withValues(alpha: 0.65);
    final backgroundColor = isCurrent
        ? style.color.withValues(alpha: isDark ? 0.15 : 0.075)
        : isDark
        ? AppPalette.fieldColorNDark.withValues(alpha: 0.55)
        : AppPalette.greyLight.withValues(alpha: 0.32);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.034),
        vertical: SizeConfig.h(0.014),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isCurrent ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.w(0.070),
                height: SizeConfig.w(0.070),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: SizeConfig.text(0.048),
                ),
              ),
              SizedBox(width: SizeConfig.w(0.022)),
              Expanded(
                child: Text(
                  item.toStatus.trim().isEmpty
                      ? 'حالة غير محددة'
                      : item.toStatus,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppFont.elMessiriBold,
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
                    fontSize: SizeConfig.text(
                      0.042,
                    ).clamp(16.0, 21.0).toDouble(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (item.happenedAt.trim().isNotEmpty) ...[
                //SizedBox(width: SizeConfig.w(0.016)),
                Spacer(),
                Icon(
                  Icons.access_time_rounded,
                  color: AppPalette.greyMedium,
                  size: SizeConfig.text(0.038),
                ),
                SizedBox(width: SizeConfig.w(0.006)),
                Flexible(
                  child: Text(
                    item.happenedAt,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: AppFont.elMessiriRegular,
                      color: AppPalette.greyMedium,
                      fontSize: SizeConfig.text(
                        0.028,
                      ).clamp(10.5, 13.0).toDouble(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (showTransition) ...[
            SizedBox(height: SizeConfig.h(0.008)),
            Text(
              'من $fromStatus إلى ${item.toStatus}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFont.elMessiriRegular,
                color: style.color,
                fontSize: SizeConfig.text(0.027).clamp(10.0, 12.5).toDouble(),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (item.note.trim().isNotEmpty) ...[
            SizedBox(height: SizeConfig.h(0.008)),
            Text(
              item.note,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFont.elMessiriRegular,
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.031).clamp(11.5, 14.0).toDouble(),
                fontWeight: FontWeight.w500,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusVisualStyle {
  final Color color;
  final IconData icon;

  const _StatusVisualStyle({required this.color, required this.icon});

  factory _StatusVisualStyle.fromStatus(String status) {
    final normalized = status.trim().toLowerCase();

    if (normalized.contains('مبلغ') || normalized.contains('report')) {
      return const _StatusVisualStyle(
        color: Color(0xFF8B2BE2),
        icon: Icons.flag_rounded,
      );
    }

    if (normalized.contains('موافق') || normalized.contains('approv')) {
      return const _StatusVisualStyle(
        color: Color(0xFF16B85A),
        icon: Icons.task_alt_rounded,
      );
    }

    if (normalized.contains('حذف') ||
        normalized.contains('رفض') ||
        normalized.contains('delet') ||
        normalized.contains('reject')) {
      return const _StatusVisualStyle(
        color: Color(0xFFE34850),
        icon: Icons.delete_outline_rounded,
      );
    }

    if (normalized.contains('مسودة') ||
        normalized.contains('جديد') ||
        normalized.contains('draft') ||
        normalized.contains('new')) {
      return const _StatusVisualStyle(
        color: Color(0xFF4E86E8),
        icon: Icons.send_rounded,
      );
    }

    if (normalized.contains('مراجعة') ||
        normalized.contains('انتظار') ||
        normalized.contains('pending') ||
        normalized.contains('review')) {
      return const _StatusVisualStyle(
        color: Color(0xFFE49A20),
        icon: Icons.hourglass_top_rounded,
      );
    }

    return const _StatusVisualStyle(
      color: Color(0xFF557FF2),
      icon: Icons.info_outline_rounded,
    );
  }
}
