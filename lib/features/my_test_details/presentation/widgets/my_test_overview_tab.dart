import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_info_details_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_question_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_test_tap.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';

class MyTestOverviewTab extends StatelessWidget {
  final List<SampleQuestionEntity> questions;

  const MyTestOverviewTab({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TestInfoDetailsSection(
              questionCount: 20,
              durationSeconds: 900,
              passMarkPercentage: 60,
              publishedAt: '11/3/2026',
              lastContentUpdatedAt: '12/3/2026',
              targetLevel: 'صعب',
              language: 'العربية',
              participantsCount: 30,
              //reviewStatus: reviewStatus,
              interests: ['لبلبل', 'fgfgfgfg'],
            ),

            CustomDivider(height: 30, thickness: 3),
            CustomTextWidget(
              "عينة من الاختبار",
              color: appColors.blackTogreyMedium,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            Column(
              children: questions.map((question) {
                final selectedOptionId =
                    state.selectedSampleAnswers[question.id];

                return SampleQuestionCard(
                  question: PreviewQuestionUiModel(
                    id: question.id,
                    number: question.position,
                    question: question.questionText,
                    hintText: question.hintText,
                    options: question.options.map((option) {
                      return PreviewOptionUiModel(
                        id: option.id,
                        letter: _optionLetter(option.position),
                        text: option.optionText,
                        isCorrect: option.isCorrect,
                      );
                    }).toList(),
                  ),
                  selectedOptionId: selectedOptionId,
                  onOptionSelected: (optionId) {
                    context.read<MyTestDetailsCubit>().selectSampleAnswer(
                      questionId: question.id,
                      optionId: optionId,
                    );
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  String _optionLetter(int position) {
    const letters = ['A', 'B', 'C', 'D', 'E'];
    if (position <= 0 || position > letters.length) return position.toString();
    return letters[position - 1];
  }
}
