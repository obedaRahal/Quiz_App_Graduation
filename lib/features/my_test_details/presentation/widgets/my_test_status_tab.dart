import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

enum TestStatusType {
  deleted,
  reported,
  approved,
  underReview,
  needsModification,
  newOne,
}

class TestStatusEntity {
  final TestStatusType type;
  final String title;
  final String description;
  final String happenedAt;

  const TestStatusEntity({
    required this.type,
    required this.title,
    required this.description,
    required this.happenedAt,
  });
}

class MyTestStatusTab extends StatelessWidget {
  const MyTestStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final appColors = context.appColors;

    // Mock Data من JSON المثال
    final List<TestStatusEntity> statuses = [
      TestStatusEntity(
        type: TestStatusType.reported,
        title: "مبلغ عنه",
        description: "هذا الاختبار حصل على الكثير من الابلاغات",
        happenedAt: "2025/10/21",
      ),
      TestStatusEntity(
        type: TestStatusType.approved,
        title: "تمت الموافقة عليه",
        description:
            "تم الموافقة على نشر اختبارك للعامة واصبح بإمكان الجميع رؤيته والاطلاع عليه",
        happenedAt: "2025/10/20",
      ),
      TestStatusEntity(
        type: TestStatusType.underReview,
        title: "قيد المراجعة",
        description:
            "الاختبار في حالة مراجعة من قبل مركز الاشراف للتأكد من التعديلات",
        happenedAt: "2025/10/19",
      ),
      TestStatusEntity(
        type: TestStatusType.needsModification,
        title: "يحتاج تعديل",
        description: "الاختبار الخاص بك يحتاج الى تعديل محتواه وفقا للتعليمات",
        happenedAt: "2025/10/18",
      ),
      TestStatusEntity(
        type: TestStatusType.newOne,
        title: "جديد",
        description:
            "هذا الاختبار في حالة مسودة الان ولن يظهر للعامة الا بعد المراجعة",
        happenedAt: "2025/10/17",
      ),
    ];

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

        TestStatusItemWidget(
          status: TestStatusEntity(
            type: TestStatusType.deleted,
            title: "تم حذفه",
            description: "تم حذف الاختبار لانه مسيء وقبيح",
            happenedAt: "2025/10/22",
          ),
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

        Column(
          children: statuses.map((status) {
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
  final TestStatusEntity status;
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

  Color _getBackgroundColor(TestStatusType type) {
    switch (type) {
      case TestStatusType.deleted:
        return AppPalette.red.withOpacity(0.09);
      case TestStatusType.reported:
        return AppPalette.green.withOpacity(0.09);
      case TestStatusType.approved:
        return AppPalette.greenSoft;
      case TestStatusType.underReview:
        return AppPalette.yellow.withOpacity(0.09);
      case TestStatusType.needsModification:
        return AppPalette.orange.withOpacity(0.09);
      case TestStatusType.newOne:
        return AppPalette.blueLight.withOpacity(0.09);
    }
  }

  Color _getBorderColor(TestStatusType type) {
    switch (type) {
      case TestStatusType.deleted:
        return AppPalette.red;
      case TestStatusType.reported:
        return AppPalette.green;
      case TestStatusType.approved:
        return AppPalette.green;
      case TestStatusType.underReview:
        return AppPalette.yellow;
      case TestStatusType.needsModification:
        return AppPalette.orange;
      case TestStatusType.newOne:
        return AppPalette.blueLight;
    }
  }

  String _getIconAsset(TestStatusType type) {
    switch (type) {
      case TestStatusType.deleted:
        return AppImage.deleteIcon;
      case TestStatusType.reported:
        return AppImage.reportedIcon;
      case TestStatusType.approved:
        return AppImage.approvedIcon;
      case TestStatusType.underReview:
        return AppImage.underReviewIcon;
      case TestStatusType.needsModification:
        return AppImage.needsModificationIcon;
      case TestStatusType.newOne:
        return AppImage.newIcon;
    }
  }
}
