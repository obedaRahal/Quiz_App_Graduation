import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/user_local_storage.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/shimmers/home_page_shimmer.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/builed_filter_item.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/card_widgets/home_slider_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_categories_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_header_widget.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_popular_instructors_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_top_banner/home_top_banner_section.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification_unread_count/notification_unread_count_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/manager/study_alarm/study_alarm_cubit.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/manager/study_alarm/study_alarm_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _topBannerController;
  late final PageController _testsSliderController;

  @override
  void initState() {
    super.initState();
    _topBannerController = PageController(viewportFraction: 0.95);
    _testsSliderController = PageController(viewportFraction: 0.74);
  }

  @override
  void dispose() {
    _topBannerController.dispose();
    _testsSliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final hasInitialLoaded = context.select<HomeCubit, bool>(
      (cubit) => cubit.state.hasInitialLoaded,
    );

    if (!hasInitialLoaded) {
      return const HomePageShimmer();
    }

    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double circleSize = SizeConfig.w(0.35);
    double imageSize = SizeConfig.w(0.25);
    double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    double actionSize = SizeConfig.text(0.045).clamp(12.0, 16.0);

    return BlocListener<StudyAlarmCubit, StudyAlarmState>(
      listenWhen: (previous, current) =>
          current.hasError &&
          (previous.errorMessage != current.errorMessage || !previous.hasError),
      listener: (context, state) {
        showValidationTopSnackBar(
          context,
          title: state.errorTitle ?? 'تعذر إعداد منبهات الدراسة',
          message:
              state.errorMessage ??
              'تعذر مزامنة منبهات الدراسة على هذا الجهاز.',
          type: AppValidationSnackBarType.error,
        );
        context.read<StudyAlarmCubit>().clearError();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: SizeConfig.h(0.03)),
            child: Column(
              textDirection: TextDirection.rtl,
              children: [
                HomeHeader(
                  onProfileTap: () async {
                    await _openMyProfile(context);
                  },
                  onNotificationTap: () async {
                    debugPrint('Open notifications');

                    final unreadCountCubit = context
                        .read<NotificationUnreadCountCubit>();
                    unreadCountCubit.clearUnreadCount();

                    await context.pushNamed(AppRouterName.notifications);

                    if (!context.mounted) return;

                    await unreadCountCubit.fetchUnreadCount();
                  },
                ),
                SizedBox(height: SizeConfig.h(0.03)),
                HomeTopBannerSection(
                  controller: _topBannerController,
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
                      controller2: _testsSliderController,
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

                SizedBox(height: SizeConfig.h(0.03)),

                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: InstructorsSection(state: state),
                    );
                  },
                ),

                SizedBox(height: SizeConfig.h(0.01)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMyProfile(BuildContext context) async {
    final userId = await UserLocalStorage.getUserId();

    if (!context.mounted) {
      return;
    }

    if (userId == null) {
      showValidationTopSnackBar(
        context,
        title: 'تعذر فتح الملف الشخصي',
        message: 'لم يتم العثور على معرّف المستخدم. يرجى تسجيل الدخول مجددًا.',
        type: AppValidationSnackBarType.error,
      );
      return;
    }

    debugPrint('Open my profile for stored user id: $userId');

    await context.pushNamed(
      AppRouterName.myProfile,
      extra: OtherProfileRouteArgs(userId: userId),
    );
  }
}
