import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class ArrowBack extends StatelessWidget {
  final VoidCallback? onTap;
  final String? label;
  final double fontSize;
  final double iconSize;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final bool showLabel;
  final AlignmentGeometry? alignment;

  const ArrowBack({
    super.key,
    this.onTap,
    this.label,
    this.fontSize = 22,
    this.iconSize = 18,
    this.spacing = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    this.showLabel = true,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final resolvedAlignment =
        alignment ?? (isRtl ? Alignment.centerLeft : Alignment.centerLeft);

    return Align(
      alignment: resolvedAlignment,
      child: Material(
        //color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: theme.colorScheme.secondary.withOpacity(0.12),
            highlightColor: theme.colorScheme.secondary.withOpacity(0.06),
            onTap: onTap ?? () => _defaultBack(context),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRtl) ...[
                    if (showLabel)
                      CustomTextWidget(
                        label ?? 'رجوع',
                        color: AppPalette.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    if (showLabel) SizedBox(width: spacing),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: theme.colorScheme.secondary,
                      size: iconSize,
                    ),
                  ] else ...[
                    Icon(
                      Icons.arrow_back_ios,
                      color: theme.colorScheme.secondary,
                      size: iconSize,
                    ),
                    if (showLabel) SizedBox(width: spacing),
                    if (showLabel)
                      CustomTextWidget(
                        "رجوع",
                        color: AppPalette.black,
                        fontFamily: AppFont.elMessiriBold,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _defaultBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class ArrowBack extends StatelessWidget {
//   const ArrowBack({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = context.colorScheme;
//     return GestureDetector(
//       onTap: () {
//         GoRouter.of(context).pop();
//         debugPrint("backkkk ");
//       },
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 6.0),
//             child: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: colorScheme.secondary,
//             ),
//           ),
//           CustomTextWidget(
//             'رجوع',
//             fontSize: SizeConfig.text(0.064),
//             color: colorScheme.secondary,
//           ),
//         ],
//       ),
//     );
//   }
// }
