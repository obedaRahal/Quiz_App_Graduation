import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/data/models/home_category_model.dart';
import 'package:quiz_app_grad/features/home/data/models/home_instructor_model.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_state.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/builed_filter_item.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/card_widgets/home_slider_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_categories_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_header_widget.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_popular_instructors_section.dart';
import 'package:quiz_app_grad/features/home/presentation/widget/home_top_banner/home_top_banner_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(viewportFraction: 0.90);
    final PageController controller2 = PageController(viewportFraction: 0.70);
    SizeConfig.init(context);
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double circleSize = SizeConfig.w(0.35);
    double imageSize = SizeConfig.w(0.25);
    double titleSize = SizeConfig.text(0.06).clamp(16.0, 22.0);
    double actionSize = SizeConfig.text(0.045).clamp(12.0, 16.0);
    final categories = [
      CategoryModel(
        title: 'البرمجة',
        subtitle: '124 اختبار',
        icon: Icons.code_rounded,
      ),
      CategoryModel(
        title: 'الرياضيات',
        subtitle: '124 اختبار',
        icon: Icons.calculate_outlined,
      ),
      CategoryModel(
        title: 'الكيمياء',
        subtitle: '124 اختبار',
        icon: Icons.science_outlined,
      ),
      CategoryModel(
        title: 'العمارة',
        subtitle: '124 اختبار',
        icon: Icons.design_services_outlined,
      ),
    ];

    final instructors = [
      InstructorModel(
        name: 'كاثرين بيشر',
        image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      ),
      InstructorModel(
        name: 'أمل غراية',
        image: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df',
      ),
      InstructorModel(
        name: 'صبا ربيع',
        image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      ),
      InstructorModel(
        name: 'قمر خالد',
        image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      ),
      InstructorModel(
        name: 'شعيب جلبي',
        image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
      ),
    ];
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
                      // 🔥 مهم لتجنب overflow
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
                        CustomTextWidget("عرض الكل", fontSize: actionSize),
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
              HomeSliderSection(
                controller2: controller2,
                isDark: isDark,
                appColors: appColors,
                colorScheme: colorScheme,
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: CategoriesSection(categories: categories),
              ),
              const SizedBox(height: 24),
              Directionality(
                textDirection: TextDirection.rtl,
                child: InstructorsSection(instructors: instructors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
