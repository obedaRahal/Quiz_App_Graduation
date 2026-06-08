// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class ExitTestPlayModeDialog extends StatelessWidget {
//   final VoidCallback onCancel;
//   final VoidCallback onExit;

//   const ExitTestPlayModeDialog({
//     super.key,
//     required this.onCancel,
//     required this.onExit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final appColors = context.appColors;

//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.055)),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxHeight: SizeConfig.h(0.32)),
//         child: CustomBackgroundWithChild(
//           width: double.infinity,
//           backgroundColor: appColors.whiteToblack,
//           borderRadius: BorderRadius.circular(18),
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.w(0.045),
//            // vertical: SizeConfig.h(0.022),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               CustomBackgroundWithChild(
//                 width: SizeConfig.w(0.12),
//                 height: SizeConfig.w(0.12),
//                 alignment: Alignment.center,
//                 backgroundColor: appColors.primarySoftTogreyLightDark,
//                 borderRadius: BorderRadius.circular(40),
//                 child: Icon(
//                   Icons.exit_to_app_rounded,
//                   color: appColors.primaryToPrimaryDark,
//                   size: SizeConfig.h(0.0365),
//                 ),
//               ),

//               SizedBox(height: SizeConfig.h(0.015)),

//               CustomTextWidget(
//                 'هل تريد مغادرة الاختبار حقاً ؟',
//                 color: appColors.blackToGrey2Dark,
//                 fontFamily: AppFont.elMessiriBold,
//                 fontSize: SizeConfig.text(0.04),
//                 textAlign: TextAlign.center,
//                 textDirection: TextDirection.rtl,
//               ),

//               SizedBox(height: SizeConfig.h(0.008)),

//               CustomTextWidget(
//                 'في حال غادرت الاختبار ستخسر تقدمك، ولن يتم تسجيل نتيجتك في قائمة سجل الاختبارات التي قمت بإجرائها',
//                 color: AppPalette.greyMedium,
//                 fontFamily: AppFont.elMessiriMedium,
//                 fontSize: SizeConfig.text(0.028),
//                 textAlign: TextAlign.right,
//                 textDirection: TextDirection.rtl,
//               ),

//               SizedBox(height: SizeConfig.h(0.024)),

//               Row(
//                 textDirection: TextDirection.rtl,
//                 children: [
//                   Expanded(
//                     child: CustomButtonWidget(
//                       borderRadius: 8,
//                       childVerticalPad: SizeConfig.h(0.015),
//                       backgroundColor: appColors.primaryToPrimaryDark,
//                       onTap: onExit,
//                       child: CustomTextWidget(
//                         'مغادرة',
//                         color: appColors.whiteToblack,
//                         fontFamily: AppFont.elMessiriBold,
//                         fontSize: SizeConfig.text(0.03),
//                       ),
//                     ),
//                   ),

//                   SizedBox(width: SizeConfig.w(0.04)),

//                   Expanded(
//                     child: CustomButtonWidget(
//                       borderRadius: 8,
//                       backgroundColor: appColors.greyToGreyMediumDark,
//                       childVerticalPad: SizeConfig.h(0.015),
                      
//                       // borderColor:
//                       //     appColors.borderFieldColorNLightToborderFieldColorNDark,
//                       onTap: onCancel,
//                       child: CustomTextWidget(
//                         'إلغاء',
//                         color: appColors.blackToGrey2Dark,
//                         fontFamily: AppFont.elMessiriBold,
//                         fontSize: SizeConfig.text(0.03),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<void> showExitTestPlayModeDialog({
//   required BuildContext context,
//   required VoidCallback onExitConfirmed,
// }) async {
//   await showDialog(
//     context: context,

//     barrierDismissible: false,
//     builder: (dialogContext) {
//       return ExitTestPlayModeDialog(
//         onCancel: () => Navigator.of(dialogContext).pop(),
//         onExit: () {
//           Navigator.of(dialogContext).pop();
//           onExitConfirmed();
//         },
//       );
//     },
//   );
// }
