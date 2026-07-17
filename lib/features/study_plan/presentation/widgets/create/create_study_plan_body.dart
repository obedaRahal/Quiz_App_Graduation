import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/select_subjects/show_select_study_subjects_dialog.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/show_study_plan_daily_hours_dialog.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_daily_hours_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_dates_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_default_switcher_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_subjects_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_title_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';

class CreateStudyPlanBody extends StatelessWidget {
  const CreateStudyPlanBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.w(0.03),
        SizeConfig.h(0.015),
        SizeConfig.w(0.03),
        SizeConfig.h(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyPlanHomeHeader(
            title: 'إنشاء خطة دراسية',
            actionIcon: Icons.close_rounded,
            onActionTap: () {
              Navigator.of(context).pop();
            },
          ),

          SizedBox(height: SizeConfig.h(0.025)),

          // StudyPlanTitleSection(
          //   title: '',
          //   emoji: '',
          //   onChanged: (value) {
          //     debugPrint('→ study plan title: $value');
          //   },
          //   onEmojiChanged: (value) {
          //     debugPrint('→ study plan emoji: $value');
          //   },
          // ),
          // const CustomDivider(height: 35, thickness: 3),
          BlocBuilder<CreateUpdateStudyPlanCubit, CreateUpdateStudyPlanState>(
            buildWhen: (previous, current) {
              return previous.title != current.title ||
                  previous.emoji != current.emoji;
            },
            builder: (context, state) {
              return StudyPlanTitleSection(
                title: state.title,
                emoji: state.emoji,
                onChanged: context
                    .read<CreateUpdateStudyPlanCubit>()
                    .changeTitle,
                onEmojiChanged: context
                    .read<CreateUpdateStudyPlanCubit>()
                    .changeEmoji,
              );
            },
          ),

          const CustomDivider(height: 35, thickness: 3),

          BlocBuilder<CreateUpdateStudyPlanCubit, CreateUpdateStudyPlanState>(
            buildWhen: (previous, current) {
              return previous.startDate != current.startDate ||
                  previous.endDate != current.endDate;
            },
            builder: (context, state) {
              return StudyPlanDatesSection(
                startDate: state.startDate,
                endDate: state.endDate,
                onStartDateTap: () async {
                  final now = DateTime.now();

                  final today = DateTime(now.year, now.month, now.day);

                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: state.startDate ?? today,
                    firstDate: today,
                    lastDate: DateTime(today.year + 5, today.month, today.day),
                    helpText: 'اختر تاريخ بداية الخطة',
                    cancelText: 'إلغاء',
                    confirmText: 'تأكيد',
                  );

                  if (selectedDate == null || !context.mounted) {
                    debugPrint('→ start date selection cancelled');
                    return;
                  }

                  debugPrint('→ selected start date: $selectedDate');

                  context.read<CreateUpdateStudyPlanCubit>().changeStartDate(
                    selectedDate,
                  );
                },
                onEndDateTap: () async {
                  final now = DateTime.now();

                  final today = DateTime(now.year, now.month, now.day);

                  final firstAllowedDate = state.startDate ?? today;

                  final initialDate = state.endDate ?? firstAllowedDate;

                  final safeInitialDate = initialDate.isBefore(firstAllowedDate)
                      ? firstAllowedDate
                      : initialDate;

                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: safeInitialDate,
                    firstDate: firstAllowedDate,
                    lastDate: DateTime(today.year + 5, today.month, today.day),
                    helpText: 'اختر تاريخ نهاية الخطة',
                    cancelText: 'إلغاء',
                    confirmText: 'تأكيد',
                  );

                  if (selectedDate == null || !context.mounted) {
                    debugPrint('→ end date selection cancelled');
                    return;
                  }

                  debugPrint('→ selected end date: $selectedDate');

                  context.read<CreateUpdateStudyPlanCubit>().changeEndDate(
                    selectedDate,
                  );
                },
              );
            },
          ),

          const CustomDivider(height: 35, thickness: 3),

          BlocBuilder<CreateUpdateStudyPlanCubit, CreateUpdateStudyPlanState>(
            buildWhen: (previous, current) {
              return previous.selectedSubjectIds !=
                      current.selectedSubjectIds ||
                  previous.subjectsStatus != current.subjectsStatus ||
                  previous.availableSubjects != current.availableSubjects;
            },
            builder: (context, state) {
              return StudyPlanSubjectsSection(
                selectedSubjectsCount: state.selectedSubjectsCount,
                maxSubjects: CreateUpdateStudyPlanState.maxSelectedSubjects,
                isLoading: state.isSubjectsLoading,
                onTap: () async {
                  debugPrint(
                    '============ Open Select Study Subjects Dialog ============',
                  );
                  debugPrint('→ subjects status: ${state.subjectsStatus}');
                  debugPrint(
                    '→ available subjects: ${state.availableSubjects.length}',
                  );
                  debugPrint('→ selected ids: ${state.selectedSubjectIds}');

                  if (state.isSubjectsLoading) {
                    debugPrint('✗ dialog ignored: subjects still loading');
                    return;
                  }

                  if (state.isSubjectsFailure) {
                    debugPrint('→ retrying available subjects request');

                    await context
                        .read<CreateUpdateStudyPlanCubit>()
                        .getAvailableSubjects();

                    if (!context.mounted) {
                      return;
                    }

                    final refreshedState = context
                        .read<CreateUpdateStudyPlanCubit>()
                        .state;

                    if (!refreshedState.isSubjectsSuccess) {
                      debugPrint(
                        '✗ cannot open dialog: subjects request failed',
                      );
                      return;
                    }
                  }

                  final currentState = context
                      .read<CreateUpdateStudyPlanCubit>()
                      .state;

                  final selectedIds = await showSelectStudySubjectsDialog(
                    context,
                    subjects: currentState.availableSubjects,
                    initiallySelectedIds: currentState.selectedSubjectIds,
                    maxSelection:
                        CreateUpdateStudyPlanState.maxSelectedSubjects,
                  );

                  if (selectedIds == null || !context.mounted) {
                    debugPrint('→ subject selection cancelled');
                    return;
                  }

                  context
                      .read<CreateUpdateStudyPlanCubit>()
                      .changeSelectedSubjects(selectedIds);
                },
              );
            },
          ),

          const CustomDivider(height: 35, thickness: 3),

          BlocBuilder<CreateUpdateStudyPlanCubit, CreateUpdateStudyPlanState>(
            buildWhen: (previous, current) {
              return previous.dailyStudyHours != current.dailyStudyHours;
            },
            builder: (context, state) {
              return StudyPlanDailyHoursSection(
                dailyHours: state.dailyStudyHours,
                onTap: () async {
                  final selectedHours = await showStudyPlanDailyHoursDialog(
                    context,
                    initialHours: state.dailyStudyHours > 0
                        ? state.dailyStudyHours
                        : 1,
                    minHours: 1,
                    maxHours: 10,
                  );

                  if (selectedHours == null || !context.mounted) {
                    debugPrint('→ daily hours selection cancelled');
                    return;
                  }

                  debugPrint('→ selected daily hours: $selectedHours');

                  context
                      .read<CreateUpdateStudyPlanCubit>()
                      .changeDailyStudyHours(selectedHours);
                },
              );
            },
          ),

          const CustomDivider(height: 35, thickness: 3),

          BlocBuilder<CreateUpdateStudyPlanCubit, CreateUpdateStudyPlanState>(
            buildWhen: (previous, current) {
              return previous.isDefault != current.isDefault;
            },
            builder: (context, state) {
              return StudyPlanDefaultSwitchCard(
                value: state.isDefault,
                onChanged: context
                    .read<CreateUpdateStudyPlanCubit>()
                    .changeDefaultStatus,
              );
            },
          ),
          SizedBox(height: SizeConfig.h(0.025)),
        ],
      ),
    );
  }
}
