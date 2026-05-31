import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

class ChallengeResultPdfService {
  Future<String> generateChallengeResultPdf({
    required TestPlayInfoEntity test,
    required Map<int, TestPlayAnswerRecordEntity> answersByQuestionId,
    required int userScore,
    required int botScore,
    required String opponentName,
    required String opponentImage,
    required String playerName,
    required String playerImage,
    required int elapsedSeconds,
    required bool didUserWin,
    required bool didBotWin,
    required bool isDraw,
  }) async {
    final pdf = pw.Document();

    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/ElMessiri-Regular.ttf'),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/ElMessiri-Bold.ttf'),
    );

    final cupSvg = await rootBundle.loadString(AppImage.cup);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            _buildHeader(
              test: test,
              userScore: userScore,
              botScore: botScore,
              playerName: playerName,
              opponentName: opponentName,
              elapsedSeconds: elapsedSeconds,
              didUserWin: didUserWin,
              didBotWin: didBotWin,
              isDraw: isDraw,
              cupSvg: cupSvg,
            ),
            pw.SizedBox(height: 18),
            _sectionTitle('تفاصيل الأسئلة'),
            pw.SizedBox(height: 12),
            ...test.questions.map((question) {
              final answer = answersByQuestionId[question.questionId];

              return _buildQuestionResultCard(
                question: question,
                answer: answer,
                totalQuestions: test.questions.length,
              );
            }),
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final fileName =
        'challenge_result_${test.testId}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  pw.Widget _buildHeader({
    required TestPlayInfoEntity test,
    required int userScore,
    required int botScore,
    required String playerName,
    required String opponentName,
    required int elapsedSeconds,
    required bool didUserWin,
    required bool didBotWin,
    required bool isDraw,
    required String cupSvg,
  }) {
    final title = didUserWin
        ? 'تهانينا لقد ربحت التحدي!'
        : didBotWin
        ? 'حظ أوفر في المرة القادمة'
        : 'تعادل رائع!';

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#6A5AE0'),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  test.title,
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: pw.WrapAlignment.end,
                  children: [
                    _statBox(playerName, '$userScore'),
                    _statBox(opponentName, '$botScore'),
                    _statBox('عدد الأسئلة', '${test.questions.length}'),
                    _statBox('الوقت', _formatSeconds(elapsedSeconds)),
                  ],
                ),
              ],
            ),
          ),
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 14),
            width: 2,
            height: 105,
            color: PdfColors.white,
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.SvgImage(svg: cupSvg, width: 110, height: 110),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _statBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#6A5AE0'),
              fontSize: 9,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#6A5AE0'),
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 18,
          color: PdfColor.fromHex('#222222'),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildQuestionResultCard({
    required TestPlayQuestionEntity question,
    required TestPlayAnswerRecordEntity? answer,
    required int totalQuestions,
  }) {
    final answeredByText = _answerOwnerText(answer?.answeredBy);
    final borderColor = _answerOwnerColor(answer?.answeredBy);

    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor, width: 1),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                answeredByText,
                style: pw.TextStyle(
                  color: borderColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${question.position}/$totalQuestions',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#6A5AE0'),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            question.questionText,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromHex('#222222'),
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...question.options.map((option) {
            final isSelected = option.optionId == answer?.selectedOptionId;
            final isCorrectOption = option.isCorrect;

            final color = isCorrectOption
                ? PdfColor.fromHex('#63D64E')
                : isSelected
                ? PdfColor.fromHex('#FF5C5C')
                : PdfColor.fromHex('#777777');

            final bgColor = isCorrectOption
                ? PdfColor.fromHex('#EFFFF0')
                : isSelected
                ? PdfColor.fromHex('#FFEEEE')
                : PdfColor.fromHex('#F3F3F3');

            return pw.Container(
              width: double.infinity,
              margin: const pw.EdgeInsets.only(bottom: 6),
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: bgColor,
                border: pw.Border.all(color: color, width: 0.6),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                '${_optionLetter(option.position)}. ${option.optionText}',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(color: color, fontSize: 10),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _answerOwnerText(TestPlayAnswerOwner? owner) {
    switch (owner) {
      case TestPlayAnswerOwner.user:
        return 'أنت أجبت';
      case TestPlayAnswerOwner.bot:
      case TestPlayAnswerOwner.timeout:
        return 'الخصم أجاب';
      default:
        return 'لم تتم الإجابة';
    }
  }

  PdfColor _answerOwnerColor(TestPlayAnswerOwner? owner) {
    switch (owner) {
      case TestPlayAnswerOwner.user:
        return PdfColor.fromHex('#4A90E2');
      case TestPlayAnswerOwner.bot:
        return PdfColor.fromHex('#C06C84');
      case TestPlayAnswerOwner.timeout:
        return PdfColor.fromHex('#FF5C5C');
      default:
        return PdfColor.fromHex('#777777');
    }
  }

  String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _optionLetter(int position) {
    const letters = ['A', 'B', 'C', 'D', 'E'];

    if (position <= 0 || position > letters.length) {
      return position.toString();
    }

    return letters[position - 1];
  }
}
