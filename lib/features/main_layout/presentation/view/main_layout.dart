import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommanded_test_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_users_use_case.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/view/home_page.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/filter_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_ai_generation_daily_limit_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_lab_recommended_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/search_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/view/laboratory_page.dart';
import 'package:quiz_app_grad/features/library/presentation/view/library_page.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_state.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/widget/custom_bottom_nav_bar.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification_unread_count/notification_unread_count_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_scenario.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/views/study_plan_home_view.dart';

class MainLayoutBody extends StatelessWidget {
  const MainLayoutBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: state.currentIndex,
              children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(
                      create: (_) => HomeCubit(
                        getRecommendedTestsUseCase:
                            sl<GetRecommendedTestsUseCase>(),
                        getRecommendedInterestsUseCase:
                            sl<GetRecommendedInterestsUseCase>(),
                        getRecommendedUsersUseCase:
                            sl<GetRecommendedUsersUseCase>(),
                      )..getHomeData(),
                    ),

                    BlocProvider<NotificationUnreadCountCubit>(
                      create: (_) =>
                          sl<NotificationUnreadCountCubit>()
                            ..fetchUnreadCount(),
                    ),
                  ],
                  child: const HomePage(),
                ),
                const LibraryPage(),
                BlocProvider(
                  create: (_) =>
                      LaboratoryCubit(
                          getTestsByInterestUseCase:
                              sl<GetTestsByInterestUseCase>(),
                          searchTestsByInterestUseCase:
                              sl<SearchTestsByInterestUseCase>(),
                          getLabRecommendedTestsUseCase:
                              sl<GetLabRecommendedTestsUseCase>(),
                          getAllInterestsUseCase: sl<GetAllInterestsUseCase>(),
                          filterTestsUseCase: sl<FilterTestsUseCase>(),
                          getAiGenerationDailyLimitUseCase:
                              sl<GetAiGenerationDailyLimitUseCase>(),
                        )
                        ..initScrollListener()
                        ..getAiGenerationDailyLimit()
                        ..getInitialLabTests(tab: 'trending'),
                  child: const LaboratoryPage(),
                ),

                //const Center(child: Text('الخطة')),
                BlocProvider<StudyPlanHomeCubit>(
                  create: (_) => sl<StudyPlanHomeCubit>()
                    ..initialize(
                      mockScenario: StudyPlanHomeMockScenario.planWithTasks,
                      weekStartsOn: 'السبت',
                    ),
                  child: const StudyPlanHomeView(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
