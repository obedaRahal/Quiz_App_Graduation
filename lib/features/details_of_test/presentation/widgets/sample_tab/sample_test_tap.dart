import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_question_card.dart';

class SampleTestTab extends StatelessWidget {
  final List<SampleQuestionEntity> questions;

  const SampleTestTab({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
      buildWhen: (previous, current) =>
          previous.selectedSampleAnswers != current.selectedSampleAnswers,
      builder: (context, state) {
        return Column(
          children: questions.map((question) {
            final selectedOptionId = state.selectedSampleAnswers[question.id];

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
              child: SampleQuestionCard(
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
                  context.read<DetailsOfTestCubit>().selectSampleAnswer(
                    questionId: question.id,
                    optionId: optionId,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _optionLetter(int position) {
    const letters = ['A', 'B', 'C', 'D', 'E'];

    if (position <= 0 || position > letters.length) {
      return position.toString();
    }

    return letters[position - 1];
  }
}

class PreviewQuestionUiModel {
  final int id;
  final int number;
  final String question;
  final String? hintText;

  final List<PreviewOptionUiModel> options;

  const PreviewQuestionUiModel({
    required this.id,
    required this.number,
    required this.question,
    required this.options,
    required this.hintText,
  });
}

class PreviewOptionUiModel {
  final int id;
  final String letter;
  final String text;
  final bool isCorrect;

  const PreviewOptionUiModel({
    required this.id,
    required this.letter,
    required this.text,
    required this.isCorrect,
  });
}

