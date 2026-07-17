import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_scenario.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_state.dart';

class StudyPlanMockScenarioSwitcher
    extends StatelessWidget {
  const StudyPlanMockScenarioSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        StudyPlanHomeCubit,
        StudyPlanHomeState>(
      buildWhen: (previous, current) {
        return previous.activeMockScenario !=
                current.activeMockScenario ||
            previous.isLoading != current.isLoading;
      },
      builder: (context, state) {
        return Material(
          color: const Color(0xff23252D),
          borderRadius: BorderRadius.circular(30),
          elevation: 5,
          child: PopupMenuButton<
              StudyPlanHomeMockScenario>(
            enabled: !state.isLoading,
            tooltip: 'تغيير حالة الاختبار',
            initialValue:
                state.activeMockScenario,
            onSelected: (scenario) {
              context
                  .read<StudyPlanHomeCubit>()
                  .changeMockScenario(scenario);
            },
            itemBuilder: (context) {
              return StudyPlanHomeMockScenario
                  .values
                  .map(
                (scenario) {
                  return PopupMenuItem(
                    value: scenario,
                    child: Row(
                      children: [
                        Icon(
                          _iconForScenario(scenario),
                          size: 19,
                          color: scenario ==
                                  state
                                      .activeMockScenario
                              ? const Color(
                                  0xff2F80ED,
                                )
                              : const Color(
                                  0xff70737D,
                                ),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          scenario.title,
                        ),
                      ],
                    ),
                  );
                },
              ).toList();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.science_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Mock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _iconForScenario(
    StudyPlanHomeMockScenario scenario,
  ) {
    switch (scenario) {
      case StudyPlanHomeMockScenario.noPlan:
        return Icons.event_busy_outlined;

      case StudyPlanHomeMockScenario
            .planWithoutTasks:
        return Icons.event_note_outlined;

      case StudyPlanHomeMockScenario.planWithTasks:
        return Icons.task_alt_rounded;
    }
  }
}