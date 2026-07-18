import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/mappers/managed_study_plan_mapper.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/active_study_plan_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/managed_study_plan_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/managed_study_plans_empty_state.dart';

class ManagedStudyPlansList extends StatelessWidget {
  const ManagedStudyPlansList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageStudyPlansCubit, ManageStudyPlansState>(
      buildWhen: (previous, current) {
        return previous.status != current.status ||
            previous.plans != current.plans ||
            previous.searchQuery != current.searchQuery ||
            previous.selectedTab != current.selectedTab;
      },
      builder: (context, state) {
        if (state.isLoading && state.plans.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.08)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isFailure && state.plans.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
            child: Column(
              children: [
                CustomTextWidget(
                  state.errorMessage ?? 'تعذر جلب الخطط الدراسية',
                  color: AppPalette.red,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: SizeConfig.h(0.012)),

                TextButton(
                  onPressed: () {
                    context.read<ManageStudyPlansCubit>().retry();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final plans = state.filteredPlans;

        if (plans.isEmpty) {
          return ManagedStudyPlansEmptyState(
            selectedTab: state.selectedTab,
            isSearchEmptyResult: state.searchHasNoResults,
          );
        }

        return Column(
          children: plans.map((plan) {
            final summaryPlan = plan.toStudyPlanSummaryEntity();
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
              child: ActiveStudyPlanCard(
                plan: plan.toStudyPlanSummaryEntity(),
                bottomText: state.selectedTab == StudyPlansTab.current
                    ? context.appColors.primaryToPrimaryDark
                    : state.selectedTab == StudyPlansTab.future
                    ? Colors.yellow
                    : Colors.red,
                bottomBg: state.selectedTab == StudyPlansTab.current
                    ? context.appColors.primarySoftTogreyLightDark
                    : state.selectedTab == StudyPlansTab.future
                    ? Colors.yellow.shade100
                    : Colors.red.shade100,
                onTap: () {
                  debugPrint(
                    '============ Open Managed Study Plan ============',
                  );
                  debugPrint('→ planId: ${plan.id}');
                  debugPrint('→ title: ${plan.title}');

                  debugPrint(
                    '============ Open Study Plan Details ============',
                  );
                  debugPrint('→ planId: ${plan.id}');
                  debugPrint('→ title: ${plan.title}');

                  context.pushNamed(
                    AppRouterName.studyPlanDetails,
                    extra: summaryPlan,
                  );
                },

                // onEditTap: () {
                //   debugPrint('Open edit plan');
                //   context.pushNamed(
                //     AppRouterName.createStudyPlan,
                //     extra: summaryPlan,
                //   );
                // },
                onEditTap: () async {
                  debugPrint(
                    '============ Open Update Plan From Manage ============',
                  );
                  debugPrint('→ planId: ${summaryPlan.id}');

                  final didChange = await context.pushNamed<bool>(
                    AppRouterName.createStudyPlan,
                    extra: summaryPlan,
                  );

                  debugPrint('→ update result: $didChange');

                  if (didChange != true || !context.mounted) {
                    debugPrint('→ no change, refresh skipped');
                    return;
                  }

                  final cubit = context.read<ManageStudyPlansCubit>();

                  cubit.markDataChanged();

                  await cubit.refreshPlans();
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
