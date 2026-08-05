import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_instructor_card.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';

class InstructorsSection extends StatelessWidget {
  final HomeState state;

  const InstructorsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);

    final sectionHeight = SizeConfig.h(0.12).clamp(105.0, 135.0);

    if (state.isRecommendedUsersLoading) {
      return SizedBox(
        height: sectionHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.recommendedUsersError != null) {
      return SizedBox(
        height: sectionHeight,
        child: Center(
          child: CustomTextWidget(
            'حدث خطأ أثناء جلب أصحاب المعلومات',
            color: AppPalette.greyMedium,
            textAlign: TextAlign.center,
            fontSize: SizeConfig.text(0.035),
          ),
        ),
      );
    }

    if (state.recommendedUsers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: EmptyActionBox(
          icon: Icons.people_outline_rounded,
          title: 'لا يوجد ناشرون مقترحون',
          description: 'لا يوجد ناشرون مقترحون لعرضهم حالياً',
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
          child: CustomTextWidget(
            'أشهر أصحاب المعلومات',
            fontSize: titleSize,
            color: colorScheme.secondary,
            textAlign: TextAlign.right,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: SizeConfig.h(0.008)),

        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.recommendedUsers.length,
            separatorBuilder: (_, __) {
              return SizedBox(width: SizeConfig.w(0.035));
            },
            itemBuilder: (context, index) {
              final item = state.recommendedUsers[index];

              return InstructorCard(
                item: item,
                onProfileTap: () {
                  debugPrint(
                    '============ InstructorsSection.onProfileTap ============',
                  );
                  debugPrint('→ userId: ${item.id}');

                  context.pushNamed(
                    AppRouterName.otherProfile,
                    extra: OtherProfileRouteArgs(userId: item.id),
                  );
                },
              );
            },
          ),
        ),

        SizedBox(height: SizeConfig.h(0.008)),
      ],
    );
  }
}
