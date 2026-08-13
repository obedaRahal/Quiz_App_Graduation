import 'dart:convert';
import 'dart:typed_data';

import 'package:quiz_app_grad/features/create_test/presentation/utils/create_test_question_constraints.dart';

class ImportedManualQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const ImportedManualQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class ManualQuestionsJsonImportResult {
  final List<ImportedManualQuestion> questions;
  final String? error;

  const ManualQuestionsJsonImportResult._({
    required this.questions,
    required this.error,
  });

  const ManualQuestionsJsonImportResult.success(
    List<ImportedManualQuestion> questions,
  ) : this._(questions: questions, error: null);

  const ManualQuestionsJsonImportResult.failure(String error)
    : this._(questions: const [], error: error);

  bool get isSuccess => error == null;
}

ManualQuestionsJsonImportResult parseManualQuestionsJson(Uint8List bytes) {
  const maxFileSizeInBytes = 1024 * 1024;

  if (bytes.isEmpty) {
    return const ManualQuestionsJsonImportResult.failure(
      'الملف فارغ. اختر ملف JSON يحتوي على أسئلة.',
    );
  }

  if (bytes.length > maxFileSizeInBytes) {
    return const ManualQuestionsJsonImportResult.failure(
      'حجم ملف الأسئلة يجب ألا يتجاوز 1 ميغابايت.',
    );
  }

  final String content;
  try {
    content = utf8.decode(bytes);
  } on FormatException {
    return const ManualQuestionsJsonImportResult.failure(
      'تعذر قراءة الملف. يجب أن يكون ملف JSON بترميز UTF-8.',
    );
  }

  String normalizedContent = content
      .replaceAll('“', '"')
      .replaceAll('”', '"')
      .replaceAll('‘', "'")
      .replaceAll('’', "'")
      .replaceAll('\u00A0', ' ');

  normalizedContent = normalizedContent.replaceFirst('\uFEFF', '');

  final Object? decoded;

  try {
    decoded = jsonDecode(normalizedContent);
  } on FormatException {
    return const ManualQuestionsJsonImportResult.failure(
      'تعذر قراءة JSON.\n\n'
      'إذا أنشأت الملف بواسطة ChatGPT أو Gemini فتأكد من حفظه بصيغة JSON وليس كنص منسق.',
    );
  }

  late final List<dynamic> rawQuestions;

  if (decoded is List) {
    rawQuestions = decoded;
  } else if (decoded is Map<String, dynamic>) {
    final questions =
        decoded['questions'] ?? decoded['Questions'] ?? decoded['QUESTIONS'];

    if (questions is! List) {
      return const ManualQuestionsJsonImportResult.failure(
        'الحقل questions مفقود أو لا يحتوي على قائمة أسئلة.',
      );
    }

    rawQuestions = questions;
  } else {
    return const ManualQuestionsJsonImportResult.failure(
      'صيغة الملف غير صحيحة.',
    );
  }

  if (rawQuestions.isEmpty) {
    return const ManualQuestionsJsonImportResult.failure(
      'ملف الأسئلة لا يحتوي على أي سؤال.',
    );
  }

  if (rawQuestions.length > CreateTestQuestionConstraints.maxQuestionsCount) {
    return const ManualQuestionsJsonImportResult.failure(
      'لا يمكن أن يحتوي الملف على أكثر من 100 سؤال.',
    );
  }

  // if (decoded is! Map<String, dynamic>) {
  //   return const ManualQuestionsJsonImportResult.failure(
  //     'يجب أن يبدأ الملف بكائن يحتوي على قائمة questions.',
  //   );
  // }

  // final rawQuestions =
  //     decoded['questions'] ?? decoded['Questions'] ?? decoded['QUESTIONS'];

  // if (rawQuestions is! List) {
  //   return const ManualQuestionsJsonImportResult.failure(
  //     'الحقل questions مفقود أو لا يحتوي على قائمة أسئلة.',
  //   );
  // }

  // if (rawQuestions.isEmpty) {
  //   return const ManualQuestionsJsonImportResult.failure(
  //     'ملف الأسئلة لا يحتوي على أي سؤال.',
  //   );
  // }

  // if (rawQuestions.length > CreateTestQuestionConstraints.maxQuestionsCount) {
  //   return const ManualQuestionsJsonImportResult.failure(
  //     'لا يمكن أن يحتوي الملف على أكثر من 100 سؤال.',
  //   );
  // }

  final importedQuestions = <ImportedManualQuestion>[];

  for (var index = 0; index < rawQuestions.length; index++) {
    final questionNumber = index + 1;
    final rawQuestion = rawQuestions[index];

    if (rawQuestion is! Map<String, dynamic>) {
      return ManualQuestionsJsonImportResult.failure(
        'السؤال رقم $questionNumber يجب أن يكون كائن JSON صالحًا.',
      );
    }

    final rawQuestionText =
        rawQuestion['question'] ??
        rawQuestion['Question'] ??
        rawQuestion['QUESTION'];

    if (rawQuestionText is! String) {
      return ManualQuestionsJsonImportResult.failure(
        'السؤال رقم $questionNumber لا يحتوي على حقل question نصي.',
      );
    }

    final questionText = rawQuestionText.trim();
    if (questionText.length < CreateTestQuestionConstraints.questionMinLength ||
        questionText.length > CreateTestQuestionConstraints.questionMaxLength) {
      return ManualQuestionsJsonImportResult.failure(
        'نص السؤال رقم $questionNumber يجب أن يكون بين 10 و500 حرف.',
      );
    }

    final rawOptions = rawQuestion['options'];
    if (rawOptions is! List ||
        rawOptions.length < CreateTestQuestionConstraints.minOptionsCount ||
        rawOptions.length > CreateTestQuestionConstraints.maxOptionsCount) {
      return ManualQuestionsJsonImportResult.failure(
        'السؤال رقم $questionNumber يجب أن يحتوي على خيارين إلى خمسة خيارات.',
      );
    }

    final options = <String>[];
    for (final rawOption in rawOptions) {
      if (rawOption is! String) {
        return ManualQuestionsJsonImportResult.failure(
          'كل خيارات السؤال رقم $questionNumber يجب أن تكون نصوصًا.',
        );
      }

      final option = rawOption.trim();
      if (option.isEmpty ||
          option.length > CreateTestQuestionConstraints.optionMaxLength) {
        return ManualQuestionsJsonImportResult.failure(
          'كل خيار في السؤال رقم $questionNumber يجب أن يكون بين 1 و150 حرفًا.',
        );
      }

      options.add(option);
    }

    final rawCorrectIndex = rawQuestion['correctOptionIndex'];

    final int? correctOptionIndex = rawCorrectIndex is int
        ? rawCorrectIndex
        : int.tryParse(rawCorrectIndex.toString());

    if (correctOptionIndex == null ||
        correctOptionIndex < 0 ||
        correctOptionIndex >= options.length) {
      return ManualQuestionsJsonImportResult.failure(
        'correctOptionIndex في السؤال رقم $questionNumber غير صالح.',
      );
    }

    final rawExplanation = rawQuestion['explanation'];
    if (rawExplanation != null && rawExplanation is! String) {
      return ManualQuestionsJsonImportResult.failure(
        'explanation في السؤال رقم $questionNumber يجب أن يكون نصًا.',
      );
    }

    final explanation = (rawExplanation as String? ?? '').trim();
    if (explanation.length >
        CreateTestQuestionConstraints.explanationMaxLength) {
      return ManualQuestionsJsonImportResult.failure(
        'شرح السؤال رقم $questionNumber يجب ألا يتجاوز 1000 حرف.',
      );
    }

    importedQuestions.add(
      ImportedManualQuestion(
        questionText: questionText,
        options: options,
        correctOptionIndex: correctOptionIndex,
        explanation: explanation,
      ),
    );
  }

  return ManualQuestionsJsonImportResult.success(importedQuestions);
}
