// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/laboratory/data/models/laboratory_test_model.dart';

// class LaboratoryTestCardHeader extends StatelessWidget {
//   final bool isDark;
//   final LaboratoryTestModel item;

//   const LaboratoryTestCardHeader({
//     super.key,
//     required this.isDark,
//     required this.item,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//             top: 10,
//             bottom: 4,
//             left: SizeConfig.w(0.02),
//             right: SizeConfig.w(0.03),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: CustomAppImage(
//               height: SizeConfig.w(0.12),
//               width: SizeConfig.w(0.12),
//               path: AppImage.carmen,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             textDirection: TextDirection.rtl,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomTextWidget(
//                       item.ownerName,
//                       fontSize: SizeConfig.text(0.04),
//                       color: isDark
//                           ? AppPalette.textWhiteINDark
//                           : AppPalette.textColorInHome,
//                       fontWeight: FontWeight.bold,
//                       textAlign: TextAlign.right,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (item.isVerified)
//                     const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 4,
//                         horizontal: 8,
//                       ),
//                       child: Icon(
//                         Icons.verified_rounded,
//                         color: Colors.blue,
//                         size: 16,
//                       ),
//                     ),
//                 ],
//               ),
//               SizedBox(height: SizeConfig.h(0.005)),
//               Row(
//                 children: [
//                   CustomAppImage(
//                     height: SizeConfig.w(0.03),
//                     width: SizeConfig.w(0.03),
//                     path: AppImage.feather,
//                   ),
//                   SizedBox(width: SizeConfig.w(0.01)),
//                   Flexible(
//                     child: CustomTextWidget(
//                       "اختبار ${item.publishedTestsCount}",
//                       fontSize: SizeConfig.text(0.032),
//                       overflow: TextOverflow.ellipsis,
//                       color: isDark
//                           ? AppPalette.titleWhiteINDark
//                           : AppPalette.greyMedium,
//                     ),
//                   ),
//                   SizedBox(width: SizeConfig.w(0.02)),
//                   CustomAppImage(
//                     height: SizeConfig.w(0.03),
//                     width: SizeConfig.w(0.03),
//                     path: AppImage.handshake,
//                   ),
//                   SizedBox(width: SizeConfig.w(0.01)),
//                   Flexible(
//                     child: CustomTextWidget(
//                       "متابع ${item.followersCount}",
//                       fontSize: SizeConfig.text(0.032),
//                       overflow: TextOverflow.ellipsis,
//                       color: isDark
//                           ? AppPalette.titleWhiteINDark
//                           : AppPalette.greyMedium,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// } 
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';

class LaboratoryTestCardHeader extends StatelessWidget {
  final bool isDark;
  final LabRecommendedFeaturedTestEntity item;

  const LaboratoryTestCardHeader({
    super.key,
    required this.isDark,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final owner = item.owner;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 4,
            left: SizeConfig.w(0.02),
            right: SizeConfig.w(0.03),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomAppImage(
              height: SizeConfig.w(0.12),
              width: SizeConfig.w(0.12),
              path: AppImage.carmen,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      owner.name,
                      fontSize: SizeConfig.text(0.04),
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (owner.isVerified)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Icon(
                        Icons.verified_rounded,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.005)),
              Row(
                children: [
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.feather,
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Flexible(
                    child: CustomTextWidget(
                      "اختبار ${owner.publishedTestsCount}",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(0.02)),
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.handshake,
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Flexible(
                    child: CustomTextWidget(
                      "متابع ${owner.followersCount}",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}