import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TopContainerAuth extends StatelessWidget {
  final String title;
  final String body;
  const TopContainerAuth({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appColors.primaryToGreyMediumDark,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: colorScheme.onPrimary,
                  ),
                ),
                CustomTextWidget(
                  'رجوع',
                  fontSize: SizeConfig.text(0.064),
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  fontSize: SizeConfig.text(0.08),
                  color: colorScheme.onPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            textDirection: TextDirection.rtl,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextWidget(
                body,
                textAlign: TextAlign.right,
                fontSize: SizeConfig.text(0.045),
                color: colorScheme.onPrimary,
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6,
                width: 67,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
