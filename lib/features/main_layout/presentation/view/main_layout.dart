import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommanded_test_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_users_use_case.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/view/home_page.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_lab_recommended_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/search_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/view/laboratory_page.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_state.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/widget/custom_bottom_nav_bar.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';

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
                BlocProvider(
                  create: (_) => HomeCubit(
                    getRecommendedTestsUseCase:
                        sl<GetRecommendedTestsUseCase>(),
                    getRecommendedInterestsUseCase:
                        sl<GetRecommendedInterestsUseCase>(),
                    getRecommendedUsersUseCase:
                        sl<GetRecommendedUsersUseCase>(),
                  )..getHomeData(),
                  child: const HomePage(),
                ),
                const Center(child: Text('المكتبة')),
                // const Center(child: Text('المختبر')),
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       //context.pushNamed(AppRouterName.detailsOfTest);
                //       context.pushNamed(
                //         AppRouterName.detailsOfTest,
                //         extra: DetailsOfTestRouteArgs(testId: 4),
                //       );
                //     },
                //     child: Text("details of test"),
                //   ),
                // ),
                BlocProvider(
                  create: (_) =>
                      LaboratoryCubit(
                          getTestsByInterestUseCase:
                              sl<GetTestsByInterestUseCase>(),
                          searchTestsByInterestUseCase:
                              sl<SearchTestsByInterestUseCase>(),
                          getLabRecommendedTestsUseCase:
                              sl<GetLabRecommendedTestsUseCase>(),
                        )
                        ..initScrollListener()
                        ..getInitialLabTests(tab: 'trending'),
                  child: const LaboratoryPage(),
                ),

                Center(
                  child: Column(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            //context.pushNamed(AppRouterName.detailsOfTest);
                            context.pushNamed(
                              AppRouterName.detailsOfTest,
                              extra: DetailsOfTestRouteArgs(testId: 100),
                            );
                          },
                          child: Text("details of test"),
                        ),
                      ),

                      SizedBox(height: 40),
                      Center(
                        child: InkWell(
                          onTap: () {
                            //context.pushNamed(AppRouterName.detailsOfTest);
                            context.pushNamed(
                              AppRouterName.myTestDetails,
                              extra: DetailsOfTestRouteArgs(testId: 799),
                            );
                          },
                          child: Text("my test detailssssssssss"),
                        ),
                      ),

                      SizedBox(height: 40),
                      Center(
                        child: InkWell(
                          onTap: () {
                            //context.pushNamed(AppRouterName.detailsOfTest);
                            context.pushNamed(
                              AppRouterName.myPrivateTestDetails,
                              extra: DetailsOfTestRouteArgs(testId: 802),
                            );
                          },
                          child: Text("my test private detailssssssssss"),
                        ),
                      ),

                      SizedBox(height: 40),
                      Center(
                        child: InkWell(
                          onTap: () {
                            //context.pushNamed(AppRouterName.detailsOfTest);
                            context.pushNamed(
                              AppRouterName.otherProfile,
                              extra: OtherProfileRouteArgs(userId: 1),
                            );
                          },
                          child: Text(" other profile "),
                        ),
                      ),
                    ],
                  ),
                ),

                //const Center(child: Text('الخطة')),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
