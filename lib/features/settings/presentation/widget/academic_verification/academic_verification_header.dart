import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_header.dart';

class AcademicVerificationHeader extends StatelessWidget {
  const AcademicVerificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoldTestsHeader(title: "تأكيد المستوى العلمي"),

        SizedBox(height: SizeConfig.h(0.02)),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                color: theme.colorScheme.primary,
                size: 30,
              ),

              SizedBox(height: SizeConfig.h(0.02)),

              CustomTextWidget(
                'لماذا يجب تأكيد المستوى العلمي؟',
                fontWeight: FontWeight.w700,
              ),

              SizedBox(height: SizeConfig.h(0.01)),

              CustomTextWidget(
                'يساعد تأكيد المستوى العلمي على تعزيز موثوقية حسابك وإظهار مؤهلاتك الأكاديمية للمستخدمين.',
                color: context.appColors.blackTogreyMedium,
                fontSize: SizeConfig.text(0.04),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
