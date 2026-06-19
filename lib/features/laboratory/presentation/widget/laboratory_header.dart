import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/create_test_bottom_sheet.dart';

class LaboratoryHeader extends StatelessWidget {
  const LaboratoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return BlocBuilder<LaboratoryCubit, LaboratoryState>(
      buildWhen: (previous, current) {
        return previous.isAiDailyLimitLoading != current.isAiDailyLimitLoading ||
            previous.aiDailyLimitData != current.aiDailyLimitData ||
            previous.aiDailyLimitError != current.aiDailyLimitError;
      },
      builder: (context, state) {
        final attemptsLabel = state.isAiDailyLimitLoading
            ? '...'
            : state.aiAttemptsLabel;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.04),
            vertical: SizeConfig.h(0.01),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              height: SizeConfig.h(0.055),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      'المختبر',
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.text(0.052),
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AiAttemptsBadge(
                        attemptsLabel: attemptsLabel,
                        isLimitReached: state.hasReachedAiDailyLimit,
                      ),

                      SizedBox(width: SizeConfig.w(0.018)),

                      InkWell(
                        onTap: () {
                          showCreateTestBottomSheet(
                            context,
                            hasReachedAiDailyLimit:
                                state.hasReachedAiDailyLimit,
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: SizeConfig.w(0.095),
                          height: SizeConfig.w(0.095),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppPalette.fieldColorNDark
                                : const Color(0xFFF6F6F6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppPalette.borderFieldColorNDark
                                  : AppPalette.borderFieldColorNLight,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            size: SizeConfig.text(0.045),
                            color: isDark
                                ? AppPalette.textWhiteINDark
                                : AppPalette.textColorInHome,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AiAttemptsBadge extends StatelessWidget {
  final String attemptsLabel;
  final bool isLimitReached;

  const _AiAttemptsBadge({
    required this.attemptsLabel,
    required this.isLimitReached,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final badgeColor = isLimitReached
        ? AppPalette.red.withOpacity(isDark ? 0.18 : 0.10)
        : isDark
            ? AppPalette.fieldColorNDark
            : AppPalette.primarySoft;

    final borderColor = isLimitReached
        ? AppPalette.red
        : isDark
            ? AppPalette.borderFieldColorNDark
            : appColors.primaryToPrimaryDark.withOpacity(0.35);

    final textColor = isLimitReached
        ? AppPalette.red
        : appColors.primaryToPrimaryDark;

    return Container(
      height: SizeConfig.h(0.030),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: SizeConfig.text(0.030),
            color: textColor,
          ),
          SizedBox(width: SizeConfig.w(0.008)),
          CustomTextWidget(
            attemptsLabel,
            fontSize: SizeConfig.text(0.024),
            fontWeight: FontWeight.w900,
            color: textColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}