
// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class SlidingText extends StatelessWidget {
//   const SlidingText({super.key, required this.slidingAnimation});

//   final Animation<Offset> slidingAnimation;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: slidingAnimation,
//       builder: (context, _) {
//         return SlideTransition(
//           position: slidingAnimation,
//           child: Text(
//             "اختبر حالك ونظم وقتك",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: SizeConfig.height * 0.04,
//               fontFamily: AppFont.reemKufi,
//               //color: AppColor.primary
//             ),
//           ),
//         );
//       },
//     );
//   }
// }