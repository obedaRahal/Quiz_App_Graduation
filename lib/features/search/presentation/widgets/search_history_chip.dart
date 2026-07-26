import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SearchHistoryChip extends StatelessWidget {
  final int historyId;
  final String query;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryChip({
    super.key,
    required this.historyId,
    required this.query,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: SizeConfig.h(0.035),
        maxWidth: SizeConfig.w(0.52),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.greyToGreyMediumDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Flexible(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: SizeConfig.w(0.035),
                      end: SizeConfig.w(0.018),
                      top: SizeConfig.h(0.009),
                      bottom: SizeConfig.h(0.009),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: SizeConfig.text(
                            0.038,
                          ).clamp(15.0, 19.0).toDouble(),
                          color: appColors.primaryToPrimaryDark,
                        ),

                        SizedBox(width: SizeConfig.w(0.014)),

                        Flexible(
                          child: Text(
                            query,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: appColors.blackToGrey2Dark,
                              fontSize: SizeConfig.text(
                                0.031,
                              ).clamp(12.0, 14.0).toDouble(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: SizeConfig.w(0.012),
                  end: SizeConfig.w(0.012),
                ),
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(20),
                  child: Icon(
                    Icons.close_rounded,
                    size: SizeConfig.text(0.036).clamp(14.0, 18.0).toDouble(),
                    color: context
                        .appColors
                        .borderFieldColorNLightToborderFieldColorNDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
