import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class TopContainerAuth extends StatelessWidget {
//   final String title;
//   final String body;
//   const TopContainerAuth({super.key, required this.title, required this.body});

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;
//     final colorScheme = context.colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: appColors.primaryToGreyMediumDark,
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               GoRouter.of(context).pop();
//             },
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 6.0),
//                   child: Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: colorScheme.onPrimary,
//                   ),
//                 ),
//                 CustomTextWidget(
//                   'رجوع',
//                   fontSize: SizeConfig.text(0.064),
//                   color: colorScheme.onPrimary,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 18),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CustomTextWidget(
//                   title,
//                   fontSize: SizeConfig.text(0.08),
//                   color: colorScheme.onPrimary,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           Row(
//             textDirection: TextDirection.rtl,
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CustomTextWidget(
//                 body,
//                 textAlign: TextAlign.right,
//                 fontSize: SizeConfig.text(0.045),
//                 color: colorScheme.onPrimary,
//               ),
//             ],
//           ),
//           SizedBox(height: 25),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 6,
//                 width: 67,
//                 decoration: BoxDecoration(
//                   color: colorScheme.onPrimary,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
class TopContainerAuth extends StatelessWidget {
  final String title;
  final String body;
  final bool compact;

  const TopContainerAuth({
    super.key,
    required this.title,
    required this.body,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.sw(compact ? 0.04 : 0.05),
        vertical: SizeConfig.sh(compact ? 0.012 : 0.018),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appColors.primaryToGreyMediumDark,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: compact ? 22 : 24,
                  color: colorScheme.onPrimary,
                ),
                CustomTextWidget(
                  'رجوع',
                  fontSize: SizeConfig.text(compact ? 0.055 : 0.06),
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.sh(compact ? 0.014 : 0.018)),

          Align(
            alignment: Alignment.centerRight,
            child: CustomTextWidget(
              title,
              fontSize: SizeConfig.text(compact ? 0.07 : 0.078),
              color: colorScheme.onPrimary,
            ),
          ),

          SizedBox(height: SizeConfig.sh(compact ? 0.0012 : 0.016)),

          Align(
            alignment: Alignment.centerRight,
            child: CustomTextWidget(
              body,
              textAlign: TextAlign.right,
              fontSize: SizeConfig.text(compact ? 0.032 : 0.043),
              color: colorScheme.onPrimary,
            ),
          ),

          SizedBox(height: SizeConfig.sh(compact ? 0.012 : 0.025)),

          Container(
            height: compact ? 5 : 6,
            width: SizeConfig.sw(compact ? 0.14 : 0.17),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
