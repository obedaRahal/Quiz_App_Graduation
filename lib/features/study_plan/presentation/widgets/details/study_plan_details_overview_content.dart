import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_progress_card.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_statistics_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_subjects_section.dart';

class StudyPlanDetailsOverviewContent extends StatelessWidget {
  final StudyPlanSummaryEntity plan;

  const StudyPlanDetailsOverviewContent({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyPlanDetailsCubit, StudyPlanDetailsState>(
      buildWhen: (previous, current) {
        return previous.overviewStatus != current.overviewStatus ||
            previous.overview != current.overview;
      },
      builder: (context, state) {
        if (state.isOverviewLoading && !state.hasOverview) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.08)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isOverviewFailure && !state.hasOverview) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.h(0.05),
              horizontal: SizeConfig.w(0.04),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppPalette.red,
                  size: SizeConfig.text(0.12),
                ),

                SizedBox(height: SizeConfig.h(0.012)),

                CustomTextWidget(
                  state.errorMessage ?? 'تعذر جلب تفاصيل الخطة',
                  color: AppPalette.red,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),

                SizedBox(height: SizeConfig.h(0.012)),

                TextButton(
                  onPressed: () {
                    context.read<StudyPlanDetailsCubit>().retryOverview();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final overview = state.overview;

        if (overview == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyPlanDetailsSubjectsSection(subjects: overview.subjects),

            SizedBox(height: SizeConfig.h(0.025)),

            const CustomDivider(height: 1, thickness: 1),

            SizedBox(height: SizeConfig.h(0.025)),

            StudyPlanDetailsStatisticsSection(
              plan: plan,
              totalTasksImage: AppImage.oldTask,
              completedTasksImage:  AppImage.doneTask,
              pendingTasksImage:  AppImage.currentTask,
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            StudyPlanDetailsProgressCard(progress: overview.progress),
          ],
        );
      },
    );
  }
}
