import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  return Column(
                    children: [
                      if (!state.isSearchMode) ...[
                        const LaboratoryTabsSection(),

                        LaboratoryTestsSliderSection(
                          controller: controller,
                          isDark: isDark,
                          appColors: appColors,
                          colorScheme: colorScheme,
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
