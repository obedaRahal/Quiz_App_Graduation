import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_academic_level_section.dart'
    as academic;
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_ai_media_section.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_header.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_info_section.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_publish_section.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_questions_section.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_sample_questions_section.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_scientific_classification_section.dart'
    as scientific;
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_submit_button.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';

class CreateTestBody extends StatelessWidget {
  const CreateTestBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const CreateTestHeader(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.012)),
                  BlocBuilder<CreateTestCubit, CreateTestState>(
                    buildWhen: (previous, current) {
                      return previous.creationMode != current.creationMode ||
                          previous.aiMediaFiles != current.aiMediaFiles;
                    },
                    builder: (context, state) {
                      if (!state.isAiMode) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          const CreateTestAiMediaSection(),
                          SizedBox(height: SizeConfig.h(0.022)),
                          const _SectionDivider(),
                          SizedBox(height: SizeConfig.h(0.018)),
                        ],
                      );
                    },
                  ),
                  const CreateTestTitleDescriptionSection(),

                  SizedBox(height: SizeConfig.h(0.022)),

                  const _SectionDivider(),

                  SizedBox(height: SizeConfig.h(0.018)),

                  const CreateTestInfoSection(),

                  SizedBox(height: SizeConfig.h(0.020)),

                  const CreateTestPublishSection(),

                  SizedBox(height: SizeConfig.h(0.026)),

                  const _SectionDivider(),

                  SizedBox(height: SizeConfig.h(0.018)),

                  scientific.CreateTestScientificClassificationSection(),

                  SizedBox(height: SizeConfig.h(0.026)),

                  const _SectionDivider(),

                  SizedBox(height: SizeConfig.h(0.018)),

                  academic.CreateTestAcademicLevelSection(),

                  SizedBox(height: SizeConfig.h(0.026)),

                  const _SectionDivider(),

                  SizedBox(height: SizeConfig.h(0.018)),

                  const CreateTestQuestionsSection(),

                  SizedBox(height: SizeConfig.h(0.026)),

                  const _SectionDivider(),

                  SizedBox(height: SizeConfig.h(0.018)),

                  const CreateTestSampleQuestionsSection(),

                  SizedBox(height: SizeConfig.h(0.030)),
                ],
              ),
            ),
          ),

          const CreateTestSubmitButton(),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      width: double.infinity,
      color: isDark
          ? AppPalette.borderFieldColorNDark
          : AppPalette.primaryToWhite,
    );
  }
}
