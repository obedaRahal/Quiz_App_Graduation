
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
    final String? fontFamily;
    final TextDirection? textDirection ;

  const CustomTextWidget(
    this.text,  {
    super.key,
    this.fontSize = 20,
    this.fontWeight,
    this.color,
    this.textAlign = TextAlign.center,
    this.fontFamily=AppFont.elMessiriRegular,
    this.textDirection =TextDirection.rtl,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      textDirection:textDirection,
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color ??theme.colorScheme.primary,
      ),
    );
  }
}
