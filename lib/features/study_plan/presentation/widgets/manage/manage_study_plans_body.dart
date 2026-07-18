import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/manage_study_plans_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/manage_study_plans_search_field.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/managed_study_plans_list.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/study_plans_filter_section.dart';

class ManageStudyPlansBody extends StatefulWidget {
  const ManageStudyPlansBody({super.key});

  @override
  State<ManageStudyPlansBody> createState() => _ManageStudyPlansBodyState();
}

class _ManageStudyPlansBodyState extends State<ManageStudyPlansBody> {
  bool _allowPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _popWithResult();
        }
      },
      child: RefreshIndicator(
        onRefresh: context.read<ManageStudyPlansCubit>().refreshPlans,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(0.035),
            SizeConfig.h(0.018),
            SizeConfig.w(0.035),
            SizeConfig.h(0.035),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ManageStudyPlansCubit, ManageStudyPlansState>(
                buildWhen: (previous, current) {
                  return previous.plansCount != current.plansCount;
                },
                builder: (context, state) {
                  return ManageStudyPlansHeader(
                    plansCount: state.plansCount,
                    maxPlansCount: ManageStudyPlansState.maxPlansCount,
                    onBackTap: _popWithResult,
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.025)),

              BlocBuilder<ManageStudyPlansCubit, ManageStudyPlansState>(
                buildWhen: (previous, current) {
                  return previous.searchQuery != current.searchQuery;
                },
                builder: (context, state) {
                  return ManageStudyPlansSearchField(
                    value: state.searchQuery,
                    onChanged: context
                        .read<ManageStudyPlansCubit>()
                        .changeSearchQuery,
                    onClear: context.read<ManageStudyPlansCubit>().clearSearch,
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              BlocBuilder<ManageStudyPlansCubit, ManageStudyPlansState>(
                buildWhen: (previous, current) {
                  return previous.selectedTab != current.selectedTab ||
                      previous.status != current.status;
                },
                builder: (context, state) {
                  return StudyPlansFilterSection(
                    selectedTab: state.selectedTab,
                    isLoading: state.isLoading,
                    onTabSelected: (tab) {
                      context.read<ManageStudyPlansCubit>().changeTab(tab);
                    },
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.022)),

              const ManagedStudyPlansList(),
            ],
          ),
        ),
      ),
    );
  }

  void _popWithResult() {
    if (_allowPop) {
      return;
    }

    setState(() {
      _allowPop = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final hasDataChanges = context
            .read<ManageStudyPlansCubit>()
            .state
            .hasDataChanges;

        Navigator.of(context).pop(hasDataChanges);
      }
    });
  }
}
