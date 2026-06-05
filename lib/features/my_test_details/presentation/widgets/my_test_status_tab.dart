import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';

class MyTestStatusTab extends StatelessWidget {
  final MyPublicTestStatusHistoryEntity statusHistory;

  const MyTestStatusTab({super.key, required this.statusHistory});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final currentStatus = statusHistory.currentStatus;
    final previousStatuses = statusHistory.previousStatuses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "الحالة الحالية",
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        if (currentStatus == null)
          CustomTextWidget(
            'لا توجد حالة حالية لهذا الاختبار',
            color: AppPalette.greyMedium,
            textAlign: TextAlign.center,
          )
        else
          TestStatusItemWidget(
            status: currentStatus,
            fontColor: true,
            useTypeColor: true,
          ),

        CustomDivider(height: 40, thickness: 3),

        CustomTextWidget(
          "الحالات السابقة",
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        if (previousStatuses.isEmpty)
          Center(
            child: CustomTextWidget(
              'لا توجد حالات سابقة',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          Column(
            children: previousStatuses.map((status) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
                child: TestStatusItemWidget(status: status),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class TestStatusItemWidget extends StatelessWidget {
  final MyPublicTestStatusHistoryItemEntity status;
  final bool fontColor;
  final bool useTypeColor;

  const TestStatusItemWidget({
    super.key,
    required this.status,
    this.fontColor = false,
    this.useTypeColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = useTypeColor
        ? _getBackgroundColor(status.type)
        : AppPalette.grey;
    final borderColor = useTypeColor
        ? _getBorderColor(status.type)
        : AppPalette.borderFieldColorNLight;
    final iconAsset = _getIconAsset(status.type);

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: bgColor,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.012),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      status.happenedAt,
                      fontSize: SizeConfig.text(0.026),
                      fontFamily: "ElMessiriRegular",
                      color: AppPalette.greyMediumDark,
                      textDirection: TextDirection.rtl,
                    ),
                    CustomTextWidget(
                      status.title,
                      fontSize: SizeConfig.text(0.033),
                      fontFamily: AppFont.elMessiriBold,
                      color: fontColor ? borderColor : AppPalette.black,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                if (status.description.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.h(0.002)),
                  CustomTextWidget(
                    status.description,
                    fontSize: SizeConfig.text(0.028),
                    fontFamily: AppFont.elMessiriRegular,
                    color: AppPalette.greyMedium,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ],
                if (status.type ==
                    MyPublicTestStatusType.needsModification) ...[
                  SizedBox(height: SizeConfig.h(0.002)),
                  CustomBackgroundWithChild(
                    backgroundColor: AppPalette.orange.withOpacity(0.09),
                    childHorizontalPad: SizeConfig.w(0.02),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppPalette.orange),
                    child: CustomButtonWidget(
                      onTap: () {},
                      child: CustomTextWidget(
                        "عرض قائمة التعديلات",
                        color: AppPalette.orange,
                        fontSize: SizeConfig.text(0.03),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: SizeConfig.w(0.03)),
          CustomAppImage(
            path: iconAsset,
            width: SizeConfig.w(0.04),
            height: SizeConfig.w(0.04),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(MyPublicTestStatusType type) {
    switch (type) {
      case MyPublicTestStatusType.deleted:
        return AppPalette.red.withOpacity(0.09);

      case MyPublicTestStatusType.reported:
        return AppPalette.violet.withOpacity(0.09);

      case MyPublicTestStatusType.approved:
        return AppPalette.greenSoft;

      case MyPublicTestStatusType.underReview:
        return AppPalette.yellow.withOpacity(0.09);

      case MyPublicTestStatusType.needsModification:
        return AppPalette.orange.withOpacity(0.09);

      case MyPublicTestStatusType.draft:
        return AppPalette.blueLight.withOpacity(0.09);

      case MyPublicTestStatusType.unknown:
        return AppPalette.grey;
    }
  }

  Color _getBorderColor(MyPublicTestStatusType type) {
    switch (type) {
      case MyPublicTestStatusType.deleted:
        return AppPalette.red;

      case MyPublicTestStatusType.reported:
        return AppPalette.violet;

      case MyPublicTestStatusType.approved:
        return AppPalette.green;

      case MyPublicTestStatusType.underReview:
        return AppPalette.yellow;

      case MyPublicTestStatusType.needsModification:
        return AppPalette.orange;

      case MyPublicTestStatusType.draft:
        return AppPalette.blueLight;

      case MyPublicTestStatusType.unknown:
        return AppPalette.greyMedium;
    }
  }

  String _getIconAsset(MyPublicTestStatusType type) {
    switch (type) {
      case MyPublicTestStatusType.deleted:
        return AppImage.deleteIcon;

      case MyPublicTestStatusType.reported:
        return AppImage.reportedIcon;

      case MyPublicTestStatusType.approved:
        return AppImage.approvedIcon;

      case MyPublicTestStatusType.underReview:
        return AppImage.underReviewIcon;

      case MyPublicTestStatusType.needsModification:
        return AppImage.needsModificationIcon;

      case MyPublicTestStatusType.draft:
        return AppImage.newIcon;

      case MyPublicTestStatusType.unknown:
        return AppImage.newIcon;
    }
  }
}
