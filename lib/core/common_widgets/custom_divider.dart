import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

// class CustomDivider extends StatelessWidget {
//   final double height;
//   final double thickness;
//   const CustomDivider({
//     super.key,
//     required this.height,
//     required this.thickness,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Divider(
//       height: height,
//       thickness: thickness,
//       color: isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey,
//     );
//   }
// }

class CustomDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final bool isDashed;
  final double dashWidth;
  final double dashGap;

  const CustomDivider({
    super.key,
    required this.height,
    required this.thickness,
    this.isDashed = false,
    this.dashWidth = 8,
    this.dashGap = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey;

    if (!isDashed) {
      return Divider(height: height, thickness: thickness, color: color);
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dashCount = (constraints.maxWidth / (dashWidth + dashGap))
                .floor();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(dashCount, (_) {
                return Container(
                  width: dashWidth,
                  height: thickness,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(thickness),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
