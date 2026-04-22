import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class UserInfo extends StatelessWidget {
  final bool isDark;

  const UserInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "مرحبا",
          fontSize: SizeConfig.diagonal * .018,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          fontWeight: FontWeight.bold,
        ),
        CustomTextWidget(
          "محمد هيثم منصور",
          fontSize: SizeConfig.diagonal * .018,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}