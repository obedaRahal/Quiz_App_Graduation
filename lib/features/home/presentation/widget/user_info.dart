import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class UserInfo extends StatelessWidget {
  final bool isDark;
  final String name;

  const UserInfo({
    super.key,
    required this.isDark,
    required this.name,
  });

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
        ),
        CustomTextWidget(
          name,
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