import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_tests_response_entity.dart';

// class HomeSliderCardStats extends StatelessWidget {
//   final bool isDark;

//   const HomeSliderCardStats({
//     super.key,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Column(
//               children: [
//                 CustomTextWidget(
//                   'المستوى',
//                   fontSize: SizeConfig.diagonal * .014,
//                   color: isDark
//                       ? AppPalette.textWhiteINDark
//                       : AppPalette.textColorInHome,
//                 ),
//                 CustomTextWidget(
//                   'صعب',
//                   fontSize: SizeConfig.diagonal * .014,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 28,
//             width: 1.5,
//             color: Colors.grey,
//           ),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Column(
//               children: [
//                 CustomTextWidget(
//                   'الأسئلة',
//                   fontSize: SizeConfig.diagonal * .014,
//                   color: isDark
//                       ? AppPalette.textWhiteINDark
//                       : AppPalette.textColorInHome,
//                 ),
//                 CustomTextWidget(
//                   '135',
//                   fontSize: SizeConfig.diagonal * .014,
//                   color: AppPalette.greyMedium,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 28,
//             width: 1.5,
//             color: Colors.grey,
//           ),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Column(
//               children: [
//                 CustomTextWidget(
//                   'التقييم',
//                   fontSize: SizeConfig.diagonal * .014,
//                   color: isDark
//                       ? AppPalette.textWhiteINDark
//                       : AppPalette.textColorInHome,
//                 ),
//                 Row(
//                   children: [
//                     CustomTextWidget(
//                       '4.5',
//                       fontSize: SizeConfig.diagonal * .014,
//                       color: AppPalette.greyMedium,
//                     ),
//                     SizedBox(
//                       width: SizeConfig.width * .006,
//                     ),
//                     Icon(
//                       Icons.star,
//                       color: Colors.yellow,
//                       size: 16,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class HomeSliderCardStats extends StatelessWidget {
  final bool isDark;
  final RecommendedTestEntity test;

  const HomeSliderCardStats({
    super.key,
    required this.isDark,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            title: 'المستوى',
            value: test.difficultyLevel,
            isDark: isDark,
            isDifficulty: true,
          ),
          Container(height: 28, width: 1.5, color: Colors.grey),
          _StatItem(
            title: 'الأسئلة',
            value: test.questionCount.toString(),
            isDark: isDark,
          ),
          Container(height: 28, width: 1.5, color: Colors.grey),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                CustomTextWidget(
                  'التقييم',
                  fontSize: SizeConfig.diagonal * .014,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                ),
                Row(
                  children: [
                    CustomTextWidget(
                      test.averageRating.toStringAsFixed(1),
                      fontSize: SizeConfig.diagonal * .014,
                      color: AppPalette.greyMedium,
                    ),
                    SizedBox(width: SizeConfig.width * .006),
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isDark;
  final bool isDifficulty;

  const _StatItem({
    required this.title,
    required this.value,
    required this.isDark,
    this.isDifficulty = false,
  });

  Color _getValueColor() {
    if (!isDifficulty) return AppPalette.greyMedium;

    switch (value.trim()) {
      case 'سهل':
        return AppPalette.green;
      case 'متوسط':
        return AppPalette.orange;
      case 'صعب':
        return AppPalette.red;
      default:
        return AppPalette.greyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        children: [
          CustomTextWidget(
            title,
            fontSize: SizeConfig.diagonal * .014,
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
          ),
          CustomTextWidget(
            value,
            fontSize: SizeConfig.diagonal * .014,
            fontWeight: FontWeight.bold,
            color: _getValueColor(),
          ),
        ],
      ),
    );
  }
}
