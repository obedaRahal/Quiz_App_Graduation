import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_test_modifications_entity.dart';

void showTestModificationBottomSheet({
  required BuildContext context,
  required List<MyTestModificationItemEntity> items,
}) {
  debugPrint("============ showTestModificationBottomSheet ============");
  debugPrint("→ items count: ${items.length}");
  debugPrint("=========================================================");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          final appColors = context.appColors;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1F1F) : AppPalette.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.018)),

                  Container(
                    width: SizeConfig.w(0.12),
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppPalette.greyMedium.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.018)),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.045),
                    ),
                    child: CustomTextWidget(
                      'قائمة التعديلات',
                      color: appColors.blackTogreyMedium,
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.055),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  CustomDivider(height: 20, thickness: 3, isDashed: true),

                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: CustomTextWidget(
                              'لا توجد تعديلات مطلوبة',
                              color: AppPalette.greyMedium,
                              textAlign: TextAlign.center,
                              fontSize: SizeConfig.text(0.034),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.h(0.02),
                            ),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: SizeConfig.h(0.01)),
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return ModificationRequiredItemCard(
                                revisionType: item.revisionType,
                                questionNumber: item.questionNumber,
                                revisionNumber: _formatRevisionNumber(
                                  item.optionNumber,
                                ),
                                problemNote: item.problemNote,
                                userHasModified: item.userHasModified,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String _formatRevisionNumber(String value) {
  final text = value.trim();

  if (text.isEmpty || text == '-') {
    return '-';
  }

  return '$text#';
}

class ModificationRequiredItemCard extends StatelessWidget {
  final String revisionType;
  final String revisionNumber;
  final String questionNumber;
  final String problemNote;
  final bool userHasModified;

  const ModificationRequiredItemCard({
    super.key,
    required this.revisionType,
    required this.revisionNumber,
    required this.questionNumber,
    required this.problemNote,
    required this.userHasModified,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.045),
        vertical: SizeConfig.h(0.005),
      ),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
          width: 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.045),
          vertical: SizeConfig.h(0.01),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                revisionType,
                color: appColors.primaryToPrimaryDark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.035),
                textAlign: TextAlign.right,
              ),

              CustomDivider(height: 10, thickness: 3),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NumbersColumn(
                    revisionNumber: revisionNumber,
                    questionNumber: questionNumber,
                  ),

                  SizedBox(width: SizeConfig.w(0.04)),

                  Expanded(
                    child: _ProblemColumn(
                      problemNote: problemNote,
                      userHasModified: userHasModified,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumbersColumn extends StatelessWidget {
  final String revisionNumber;
  final String questionNumber;

  const _NumbersColumn({
    required this.revisionNumber,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      width: SizeConfig.w(0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            'رقم التعديل',
            color: appColors.blackTogreyMedium,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: SizeConfig.h(0.001)),
          CustomTextWidget(
            revisionNumber,
            color: appColors.primaryToPrimaryDark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          CustomTextWidget(
            'رقم السؤال',
            color: appColors.blackTogreyMedium,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: SizeConfig.h(0.001)),
          CustomTextWidget(
            questionNumber,
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.026),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _ProblemColumn extends StatelessWidget {
  final String problemNote;
  final bool userHasModified;

  const _ProblemColumn({
    required this.problemNote,
    required this.userHasModified,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          'المشكلة',
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.03),
          textAlign: TextAlign.right,
        ),

        SizedBox(height: SizeConfig.h(0.003)),

        CustomTextWidget(
          problemNote,
          color: AppPalette.greyMedium,
          fontFamily: AppFont.elMessiriRegular,
          fontSize: SizeConfig.text(0.026),
          textAlign: TextAlign.right,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        if (!userHasModified) ...[
          SizedBox(height: SizeConfig.h(0.007)),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.018),
                vertical: SizeConfig.h(0.003),
              ),
              decoration: BoxDecoration(
                color: AppPalette.green.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.green),
              ),
              child: CustomTextWidget(
                'تم التعديل',
                color: AppPalette.green,
                fontFamily: AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.024),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
