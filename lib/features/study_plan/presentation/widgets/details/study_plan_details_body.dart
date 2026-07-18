import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/models/study_plan_mutation_result.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_overview_content.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_tabs_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_tasks_content.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/active_study_plan_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';

class StudyPlanDetailsBody extends StatefulWidget {
  final StudyPlanSummaryEntity plan;

  const StudyPlanDetailsBody({super.key, required this.plan});

  @override
  State<StudyPlanDetailsBody> createState() => _StudyPlanDetailsBodyState();
}

class _StudyPlanDetailsBodyState extends State<StudyPlanDetailsBody> {
  late StudyPlanSummaryEntity _plan;
  bool _hasDataChanges = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;
  }

  @override
  void didUpdateWidget(covariant StudyPlanDetailsBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.plan != widget.plan && !_hasDataChanges) {
      _plan = widget.plan;
    }
  }

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
        onRefresh: context.read<StudyPlanDetailsCubit>().refreshCurrentTab,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(0.03),
            SizeConfig.h(0.014),
            SizeConfig.w(0.03),
            SizeConfig.h(0.04),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StudyPlanHomeHeader(
                title: 'تفاصيل خطة',
                onActionTap: _popWithResult,
                actionIcon: Icons.arrow_back_ios,
              ),

              SizedBox(height: SizeConfig.h(0.018)),

              ActiveStudyPlanCard(
                plan: _plan,
                onTap: null,
                bottomBg: AppPalette.primarySoft,
                bottomText: AppPalette.primary,
                onEditTap: _editPlan,
              ),

              SizedBox(height: SizeConfig.h(0.022)),

              BlocBuilder<StudyPlanDetailsCubit, StudyPlanDetailsState>(
                buildWhen: (previous, current) {
                  return previous.selectedTab != current.selectedTab;
                },
                builder: (context, state) {
                  return StudyPlanDetailsTabsSection(
                    selectedTab: state.selectedTab,
                    onTabSelected: (tab) {
                      context.read<StudyPlanDetailsCubit>().changeTab(tab);
                    },
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.025)),

              BlocBuilder<StudyPlanDetailsCubit, StudyPlanDetailsState>(
                buildWhen: (previous, current) {
                  return previous.selectedTab != current.selectedTab;
                },
                builder: (context, state) {
                  switch (state.selectedTab) {
                    case StudyPlanDetailsTab.overview:
                      return StudyPlanDetailsOverviewContent(plan: _plan);

                    case StudyPlanDetailsTab.tasks:
                      return const StudyPlanDetailsTasksContent();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editPlan() async {
    debugPrint('Open edit plan');

    final result = await context.pushNamed<StudyPlanMutationResult>(
      AppRouterName.createStudyPlan,
      extra: _plan,
    );

    if (result == null || !mounted) {
      return;
    }

    final updatedPlan = result.updatedPlan;

    setState(() {
      _hasDataChanges = true;

      if (updatedPlan != null) {
        _plan = updatedPlan;
      }
    });

    await context.read<StudyPlanDetailsCubit>().refreshAfterPlanUpdate();
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
        Navigator.of(context).pop(_hasDataChanges);
      }
    });
  }
}
