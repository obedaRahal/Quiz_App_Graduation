import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/models/study_plan_mutation_result.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/active_study_plan_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_daily_task_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_daily_tasks_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_date_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_mock_scenario_switcher.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_motivation_banner.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_session_header_and_botton.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_week_selector.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/subjects/show_study_subjects_bottom_sheet.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_task_details_args.dart';

class StudyPlanHomeBody extends StatelessWidget {
  const StudyPlanHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyPlanHomeCubit, StudyPlanHomeState>(
      buildWhen: (previous, current) {
        return previous.overview != current.overview ||
            previous.status != current.status ||
            previous.activeMockScenario != current.activeMockScenario ||
            previous.taskUpdateStatus != current.taskUpdateStatus ||
            previous.updatingTaskId != current.updatingTaskId;
      },
      builder: (context, state) {
        final overview = state.overview;

        if (overview == null) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            SingleChildScrollView(
              //physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: SizeConfig.w(0.03),
                top: SizeConfig.h(0.01),
                right: SizeConfig.w(0.03),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StudyPlanHomeHeader(
                    onActionTap: () async {
                      debugPrint('Create study plan');
                      // context.pushNamed(AppRouterName.createStudyPlan);
                      final result = await context
                          .pushNamed<StudyPlanMutationResult>(
                            AppRouterName.createStudyPlan,
                          );

                      if (result != null && context.mounted) {
                        await context
                            .read<StudyPlanHomeCubit>()
                            .refreshOverview();
                      }
                    },
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),

                  const StudyPlanMotivationBanner(),
                  SizedBox(height: SizeConfig.h(0.02)),

                  StudyPlanDateSection(
                    selectedDate: overview.data.selectedDate,
                    onManageSubjectsTap: () async {
                      debugPrint(
                        '============ Manage Study Subjects ============',
                      );

                      await showStudySubjectsBottomSheet(context);
                    },
                  ),
                  SizedBox(height: SizeConfig.h(0.015)),

                  StudyPlanWeekSelector(
                    days: state.days,
                    selectedDate: state.selectedDate,
                    rangeStart: state.rangeStart,
                    rangeEnd: state.rangeEnd,
                    weekStartsOn: state.weekStartsOn,
                    serverToday: state.serverToday,
                    isLoading: state.isLoading,
                    onDayTap: (day) {
                      context.read<StudyPlanHomeCubit>().selectDay(day);
                    },
                    onPreviousWeek: () {
                      context.read<StudyPlanHomeCubit>().goToPreviousWeek();
                    },
                    onNextWeek: () {
                      context.read<StudyPlanHomeCubit>().goToNextWeek();
                    },
                  ),

                  SizedBox(height: SizeConfig.h(0.02)),

                  StudyPlanSectionHeader(
                    title: "الخطة الفعالة",
                    buttonTitle: 'إدارة الخطط',
                    onTap: () async {
                      debugPrint(
                        '============ Open Manage Study Plans ============',
                      );

                      final didChange = await context.pushNamed<bool>(
                        AppRouterName.manageStudyPlans,
                      );

                      debugPrint('→ manage plans result: $didChange');

                      if (didChange == true && context.mounted) {
                        debugPrint(
                          '✓ managed plans changed, refreshing home overview',
                        );

                        await context
                            .read<StudyPlanHomeCubit>()
                            .refreshOverview();
                      } else {
                        debugPrint(
                          '→ managed plans unchanged, home refresh skipped',
                        );
                      }
                    },
                  ),

                  SizedBox(height: SizeConfig.h(0.015)),

                  if (overview.data.plan != null)
                    ActiveStudyPlanCard(
                      plan: overview.data.plan!,
                      onTap: () async {
                        debugPrint('Open active plan');
                        debugPrint(
                          '============ Open Study Plan Details From Home ============',
                        );
                        debugPrint('→ planId: ${overview.data.plan!.id}');

                        final didChange = await context.pushNamed<bool>(
                          AppRouterName.studyPlanDetails,
                          extra: overview.data.plan!,
                        );

                        if (didChange == true && context.mounted) {
                          await context
                              .read<StudyPlanHomeCubit>()
                              .refreshOverview();
                        }
                      },
                      onEditTap: () async {
                        debugPrint(
                          '============ Open Update Plan From Home ============',
                        );
                        debugPrint('→ planId: ${overview.data.plan!.id}');

                        final result = await context
                            .pushNamed<StudyPlanMutationResult>(
                              AppRouterName.createStudyPlan,
                              extra: overview.data.plan!,
                            );

                        debugPrint('→ update result: $result');

                        if (result != null && context.mounted) {
                          debugPrint(
                            '✓ plan changed, refreshing home overview',
                          );

                          await context
                              .read<StudyPlanHomeCubit>()
                              .refreshOverview();
                        } else {
                          debugPrint('→ no change, home refresh skipped');
                        }
                      },
                      bottomText: context.appColors.primaryToPrimaryDark,
                      bottomBg: context.appColors.primarySoftTogreyLightDark,
                    ),
                  if (overview.data.plan == null)
                    EmptyActionBox(
                      onTap: () {
                        debugPrint('Open active plan');
                      },
                      icon: Icons.event_note_rounded,
                      title: 'لا توجد خطة دراسية',
                      description: 'أنشئ خطة جديدة وابدأ بتنظيم وقتك ومهامك',
                    ),
                  CustomDivider(height: 40, thickness: 3),

                  StudyPlanDailyTasksHeader(
                    tasksCount: state.tasks.length,
                    onShowAllTap: () {
                      debugPrint('Show all tasks');
                    },
                  ),

                  SizedBox(height: SizeConfig.h(0.015)),

                  if (state.tasks.isEmpty)
                    EmptyActionBox(
                      onTap: () {
                        debugPrint('Show all tasks');
                      },
                      icon: Icons.task_alt_rounded,
                      title: 'لا توجد مهام لهذا اليوم',
                      description: 'أضف مهمة جديدة لتبدأ يومك الدراسي',
                    ),
                  Column(
                    children: state.tasks.map((task) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
                        child: StudyPlanDailyTaskCard(
                          task: task,
                          isUpdating: state.isUpdatingTask(task.id),
                          onStatusToggle: () {
                            context.read<StudyPlanHomeCubit>().toggleTaskStatus(
                              taskId: task.id,
                            );
                          },
                          onTap: () async {
                            final activePlan = overview.data.plan;

                            debugPrint(
                              '============ Open Study Task Details From Home ============',
                            );
                            debugPrint('→ taskId: ${task.id}');
                            debugPrint('→ active planId: ${activePlan?.id}');

                            if (activePlan == null) {
                              debugPrint(
                                '✗ cannot open task details: no active study plan',
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'لا توجد خطة دراسية فعالة مرتبطة بهذه المهمة',
                                    ),
                                  ),
                                );

                              return;
                            }

                            final didChange = await context.pushNamed<bool>(
                              AppRouterName.studyTaskDetails,
                              extra: StudyTaskDetailsArgs(
                                planId: activePlan.id,
                                taskId: task.id,
                              ),
                            );

                            debugPrint('→ task details result: $didChange');

                            if (didChange == true && context.mounted) {
                              debugPrint(
                                '✓ task changed, refreshing home overview',
                              );

                              await context
                                  .read<StudyPlanHomeCubit>()
                                  .refreshOverview();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            if (state.isLoading && state.overview != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.28),
                    alignment: Alignment.topCenter,
                    child: const LinearProgressIndicator(minHeight: 2),
                  ),
                ),
              ),

            if (StudyPlanHomeCubit.useMockData)
              const Positioned(
                left: 14,
                bottom: 14,
                child: StudyPlanMockScenarioSwitcher(),
              ),
          ],
        );
      },
    );
  }
}
