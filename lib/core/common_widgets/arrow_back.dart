import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pop();
        debugPrint("backkkk ");
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorScheme.secondary,
            ),
          ),
          CustomTextWidget(
            'رجوع',
            fontSize: SizeConfig.text(0.064),
            color: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
