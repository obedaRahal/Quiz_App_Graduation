import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/data/models/home_instructor_model.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_instructor_card.dart';

class InstructorsSection extends StatelessWidget {
  final List<InstructorModel> instructors;

  const InstructorsSection({super.key, required this.instructors});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.036),
            vertical: SizeConfig.h(0.01),
          ),
          child: Expanded(
            // 🔥 مهم لتجنب overflow
            child: CustomTextWidget(
              "اشهر أصحاب المعلومات",
              fontSize: titleSize,
              color: colorScheme.secondary,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 112,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: instructors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = instructors[index];
              return InstructorCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}
