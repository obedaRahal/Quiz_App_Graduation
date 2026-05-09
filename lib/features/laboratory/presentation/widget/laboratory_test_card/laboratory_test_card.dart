import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_footer.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_header.dart' show LaboratoryTestCardHeader;
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_stats.dart' show LaboratoryTestCardStats;
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_test_card_tags.dart';

// class LaboratoryTestCard extends StatelessWidget {
//   final LabRecommendedFeaturedTestEntity item;
//   final bool isDark;
//   final dynamic appColors;
//   final dynamic colorScheme;

//   const LaboratoryTestCard({
//     super.key,
//     required this.item,
//     required this.isDark,
//     required this.appColors,
//     required this.colorScheme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           width: 1,
//           color: isDark
//               ? AppPalette.borderFieldColorNDark
//               : AppPalette.greyBorderCart,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: (isDark ? const Color(0xFF484848) : const Color(0xFFD9D9D9))
//                 .withOpacity(0.30),
//             offset: const Offset(0, 4),
//             blurRadius: 14,
//             spreadRadius: -1,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           LaboratoryTestCardHeader(isDark: isDark, item: item),
//           Divider(
//             color: isDark
//                 ? AppPalette.borderFieldColorNDark
//                 : AppPalette.greyBorderCart,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: CustomTextWidget(
//               item.title,
//               textAlign: TextAlign.right,
//               fontWeight: FontWeight.bold,
//               fontSize: SizeConfig.text(0.05).clamp(12.0, 15.3),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               color: isDark
//                   ? AppPalette.textWhiteINDark
//                   : AppPalette.textColorInHome,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: CustomTextWidget(
//               item.description,
//               fontSize: SizeConfig.diagonal * .014,
//               textAlign: TextAlign.right,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               color: AppPalette.greyMedium,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: LaboratoryTestCardTags(
//               isDark: isDark,
//               tags: item.tags,
//             ),
//           ),
//           SizedBox(height: SizeConfig.height * .005),
//           LaboratoryTestCardStats(isDark: isDark, item: item),
//           SizedBox(height: SizeConfig.height * .003),
//           Divider(
//             color: isDark
//                 ? AppPalette.borderFieldColorNDark
//                 : AppPalette.greyBorderCart,
//           ),
//           LaboratoryTestCardFooter(
//             isDark: isDark,
//             appColors: appColors,
//             colorScheme: colorScheme,
//             price: item.price,
//           ),
//         ],
//       ),
//     );
//   }
// } 
class LaboratoryTestCard extends StatelessWidget {
  final LabRecommendedFeaturedTestEntity item;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const LaboratoryTestCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final test = item.test;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.greyBorderCart,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF484848) : const Color(0xFFD9D9D9))
                .withOpacity(0.30),
            offset: const Offset(0, 4),
            blurRadius: 14,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LaboratoryTestCardHeader(isDark: isDark, item: item),

          Divider(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomTextWidget(
              test.title,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.text(0.05).clamp(12.0, 15.3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: CustomTextWidget(
              test.description,
              fontSize: SizeConfig.diagonal * .014,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: AppPalette.greyMedium,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: LaboratoryTestCardTags(
              isDark: isDark,
              tags: test.interestNames,
            ),
          ),

          SizedBox(height: SizeConfig.height * .005),

          LaboratoryTestCardStats(
            isDark: isDark,
            test: test,
          ),

          SizedBox(height: SizeConfig.height * .003),

          Divider(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.greyBorderCart,
          ),

          LaboratoryTestCardFooter(
            isDark: isDark,
            appColors: appColors,
            colorScheme: colorScheme,
            price: test.price,
          ),
        ],
      ),
    );
  }
}