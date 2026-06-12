import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_exam_sessions_section.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_header.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_search_field.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_tabs_section.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_test_card/laboratory_tests_slider_section.dart';

class LaboratoryPage extends StatelessWidget {
  const LaboratoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.78);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final scrollController = context.read<LaboratoryCubit>().scrollController;
    final searchController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: const LaboratoryHeader(),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.045),
              vertical: SizeConfig.h(0.012),
            ),
            child: LaboratorySearchField(
              controller: searchController,
              onChanged: (value) {
                context.read<LaboratoryCubit>().onSearchChanged(value);
              },
              onClear: () {
                searchController.clear();

                context.read<LaboratoryCubit>().exitSearchMode();
              },
              onTap: () {
                context.read<LaboratoryCubit>().enterSearchMode();
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: BlocBuilder<LaboratoryCubit, LaboratoryState>(
                builder: (context, state) {
                  final shouldShowTopCards =
                      !state.isSearchMode && !state.isFilterMode;

                  return Column(
                    children: [
                      if (shouldShowTopCards) ...[
                        const LaboratoryTabsSection(),

                        LaboratoryTestsSliderSection(
                          controller: controller,
                          isDark: isDark,
                          appColors: appColors,
                          colorScheme: colorScheme,
                        ),
                      ],

                      if (state.isFilterMode) ...[
                        Padding(
                          padding: EdgeInsets.only(
                            right: SizeConfig.w(0.045),
                            left: SizeConfig.w(0.045),
                            bottom: SizeConfig.h(0.010),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<LaboratoryCubit>().clearFilter();
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: SizeConfig.h(0.034),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.w(0.026),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppPalette.fieldColorNDark
                                        : AppPalette.primarySoft,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isDark
                                          ? AppPalette.borderFieldColorNDark
                                          : AppPalette.primary,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.close_rounded,
                                        size: SizeConfig.text(0.034),
                                        color: appColors.primaryToPrimaryDark,
                                      ),
                                      SizedBox(width: SizeConfig.w(0.008)),
                                      CustomTextWidget(
                                        'إلغاء ',
                                        fontSize: SizeConfig.text(0.026),
                                        fontWeight: FontWeight.w800,
                                        color: appColors.primaryToPrimaryDark,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Spacer(),

                              CustomTextWidget(
                                'نتائج البحث',
                                fontSize: SizeConfig.text(0.034),
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? AppPalette.textWhiteINDark
                                    : AppPalette.textColorInHome,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],

                      const LaboratoryExamSessionsSection(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
