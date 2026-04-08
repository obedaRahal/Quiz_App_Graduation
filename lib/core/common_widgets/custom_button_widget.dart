import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color backgroundColor;
  final double borderRadius;
  final double childHorizontalPad;
  final double childVerticalPad;
  final VoidCallback onTap;
  final Widget child;

  const CustomButtonWidget({
    super.key,
    this.height,
    this.width,
    required this.backgroundColor,
    this.borderRadius = 0,
    this.childHorizontalPad = 0,
    this.childVerticalPad = 0,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContent = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: childHorizontalPad,
        vertical: childVerticalPad,
      ),
      child: Center(child: child),
    );

    final childWidget = width == null
        ? IntrinsicWidth(child: buttonContent)
        : buttonContent;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: childWidget,
      ),
    );
  }
}
