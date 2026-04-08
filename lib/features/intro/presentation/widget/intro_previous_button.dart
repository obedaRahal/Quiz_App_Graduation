import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class IntroPreviousButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const IntroPreviousButton({
    super.key,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : .35,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColor.greyToDark,
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(.023)),
              child: Icon(
                Icons.arrow_back,
                color: AppColor.greyToDark,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}