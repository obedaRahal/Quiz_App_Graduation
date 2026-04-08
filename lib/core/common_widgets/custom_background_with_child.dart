import 'package:flutter/material.dart';

class CustomBackgroundWithChild extends StatelessWidget {
  final double? height;
  final double? width;
  final Color backgroundColor;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final double childHorizontalPad;
  final double childVerticalPad;
  final Widget child;

  const CustomBackgroundWithChild({
    super.key,
    this.height,
    this.width,
    required this.backgroundColor,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.childHorizontalPad = 0,
    this.childVerticalPad = 0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      height: height,
      width: width,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: childHorizontalPad,
          vertical: childVerticalPad,
        ),
        child: child,
      ),
    );

    if (width == null) {
      content = IntrinsicWidth(child: content);
    }

    return content;
  }
}
