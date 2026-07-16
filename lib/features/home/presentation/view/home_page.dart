import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/builed_filter_item.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/card_widgets/home_slider_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_categories_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_header_widget.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_popular_instructors_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_top_banner/home_top_banner_section.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.95);
    final PageController controller2 = PageController(viewportFraction: 0.74);
    SizeConfig.init(context);
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double circleSize = SizeConfig.w(0.35);
    double imageSize = SizeConfig.w(0.25);
    double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    double actionSize = SizeConfig.text(0.045).clamp(12.0, 16.0);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 46),
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              HomeHeader(),
              SizedBox(height: 20),
              HomeTopBannerSection(
                controller: controller,
                isDark: isDark,
                colorScheme: colorScheme,
                circleSize: circleSize,
                imageSize: imageSize,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.036),
                  vertical: SizeConfig.h(0.02),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        "قائمة الاختبارات",
                        fontSize: titleSize,
                        color: colorScheme.secondary,
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.rtl,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<BottomNavCubit>().changeTab(2);
                          },
                          child: CustomTextWidget(
                            "عرض الكل",
                            fontSize: actionSize,
                          ),
                        ),
                        SizedBox(width: SizeConfig.w(0.01)),
                        Icon(
                          Icons.keyboard_arrow_left,
                          size: actionSize + 2,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.036),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            FilterItem(
                              title: "رائج",
                              index: 0,
                              state: state,
                              onTap: () =>
                                  context.read<HomeCubit>().changeFilter(0),
                            ),
                            SizedBox(width: SizeConfig.w(0.03)),

                            FilterItem(
                              title: "مجاني",
                              index: 3,
                              state: state,
                              onTap: () =>
                                  context.read<HomeCubit>().changeFilter(3),
                            ),
                            SizedBox(width: SizeConfig.w(0.03)),

                            FilterItem(
                              title: "جديد",
                              index: 1,
                              state: state,
                              onTap: () =>
                                  context.read<HomeCubit>().changeFilter(1),
                            ),
                            SizedBox(width: SizeConfig.w(0.03)),

                            FilterItem(
                              title: "الأكثر تقدما",
                              index: 2,
                              state: state,
                              onTap: () =>
                                  context.read<HomeCubit>().changeFilter(2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return HomeSliderSection(
                    controller2: controller2,
                    isDark: isDark,
                    appColors: appColors,
                    colorScheme: colorScheme,
                    state: state,
                  );
                },
              ),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: CategoriesSection(state: state),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: InstructorsSection(state: state),
                  );
                },
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

                    SizedBox(height: 40),
                    Center(
                      child: InkWell(
                        onTap: () {
                          //context.pushNamed(AppRouterName.detailsOfTest);
                          context.pushNamed(
                            AppRouterName.myTestDetails,
                            extra: DetailsOfTestRouteArgs(testId: 11),
                          );
                        },
                        child: Text("my test detailssssssssss"),
                      ),
                    ),

                    SizedBox(height: 40),
                    SizedBox(height: 40),
                    Center(
                      child: InkWell(
                        onTap: () {
                          //context.pushNamed(AppRouterName.detailsOfTest);
                          context.pushNamed(
                            AppRouterName.myPrivateTestDetails,
                            extra: DetailsOfTestRouteArgs(testId: 805),
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
                            //extra: OtherProfileRouteArgs(userId: 815),
                            extra: OtherProfileRouteArgs(userId: 811),
                          );
                        },
                        child: Text(" other profile "),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(
                            AppRouterName.otherContentDetails,
                            extra: const ContentDetailsRouteArgs(
                              contentId: 2,
                              isMyContent: true,
                            ),
                          );
                        },
                        child: const Text('عرض محتواي'),
                      ),
                    ),
                    CustomButtonWidget(
                      onTap: () {
                        debugPrint("change mode ");
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      child: ThemedAppImage(
                        darkPath: AppImage.logoDark,
                        lightPath: AppImage.logoLight,
                      ),
                    ),

                    SizedBox(height: 40),
                    Center(
                      child: InkWell(
                        onTap: () {
                          //context.pushNamed(AppRouterName.detailsOfTest);
                          context.pushNamed(
                            AppRouterName.myProfile,
                            //extra: OtherProfileRouteArgs(userId: 815),
                            extra: OtherProfileRouteArgs(userId: 828),
                          );
                        },
                        child: Text(" my profile "),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
