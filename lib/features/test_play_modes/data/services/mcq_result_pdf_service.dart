import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

class McqResultPdfService {
  Future<String> generateMcqResultPdf({
    required TestPlayInfoEntity test,
    required Map<int, TestPlayAnswerRecordEntity> answersByQuestionId,
    required int correctAnswersCount,
    required int wrongAnswersCount,
    required int scorePercentage,
    required int elapsedSeconds,
    required bool hasPassed,
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
              scorePercentage: scorePercentage,
              hasPassed: hasPassed,
              correctAnswersCount: correctAnswersCount,
              wrongAnswersCount: wrongAnswersCount,
              elapsedSeconds: elapsedSeconds,
              cupSvg: cupSvg,
            ),

            pw.SizedBox(height: 18),

            _sectionTitle('إجاباتك'),

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
        'mcq_result_${test.testId}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  pw.Widget _buildHeader({
    required TestPlayInfoEntity test,
    required int scorePercentage,
    required bool hasPassed,
    required int correctAnswersCount,
    required int wrongAnswersCount,
    required int elapsedSeconds,
    required String cupSvg,
  }) {
    final mainColor = hasPassed
        ? PdfColor.fromHex('#63D64E')
        : PdfColor.fromHex('#FF5C5C');

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
                  hasPassed
                      ? 'تهانينا لقد أنجزت الاختبار!'
                      : 'أحسنت، أكملت الاختبار!',
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
                    _statBox('النسبة', '$scorePercentage%'),
                    _statBox('إجابات صحيحة', '$correctAnswersCount'),
                    _statBox('إجابات خاطئة', '$wrongAnswersCount'),
                    _statBox('الوقت المستغرق', _formatSeconds(elapsedSeconds)),
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
        color: PdfColor.fromHex('#FFFFFF').shade(0.18),
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
    final isCorrect = answer?.isCorrect == true;
    final borderColor = isCorrect
        ? PdfColor.fromHex('#63D64E')
        : PdfColor.fromHex('#FF5C5C');

    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor, width: 1),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                isCorrect ? 'صحيح' : 'خاطئ',
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



// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
// import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

// class McqResultPdfService {
//   static final PdfColor _primary = PdfColor.fromHex('#123E8A');
//   static final PdfColor _primarySoft = PdfColor.fromHex('#EEF4FF');
//   static final PdfColor _border = PdfColor.fromHex('#DDE6F2');
//   static final PdfColor _text = PdfColor.fromHex('#1F2937');
//   static final PdfColor _muted = PdfColor.fromHex('#6B7280');
//   static final PdfColor _green = PdfColor.fromHex('#17A34A');
//   static final PdfColor _greenSoft = PdfColor.fromHex('#EFFFF0');
//   static final PdfColor _red = PdfColor.fromHex('#D93636');
//   static final PdfColor _redSoft = PdfColor.fromHex('#FFEEEE');
//   static final PdfColor _yellowSoft = PdfColor.fromHex('#FFF8DF');
//   static final PdfColor _yellowBorder = PdfColor.fromHex('#F1D889');

//   Future<String> generateMcqResultPdf({
//     required TestPlayInfoEntity test,
//     required Map<int, TestPlayAnswerRecordEntity> answersByQuestionId,
//     required int correctAnswersCount,
//     required int wrongAnswersCount,
//     required int scorePercentage,
//     required int elapsedSeconds,
//     required bool hasPassed,
//   }) async {
//     final pdf = pw.Document();

//     final regularFont = pw.Font.ttf(
//       await rootBundle.load('assets/fonts/ElMessiri-Regular.ttf'),
//     );

//     final boldFont = pw.Font.ttf(
//       await rootBundle.load('assets/fonts/ElMessiri-Bold.ttf'),
//     );

//     final cupSvg = await rootBundle.loadString(AppImage.cup);

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(22),
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(
//           base: regularFont,
//           bold: boldFont,
//         ),
//         footer: (context) {
//           return pw.Align(
//             alignment: pw.Alignment.center,
//             child: pw.Text(
//               'page ${context.pageNumber}',
//               style: pw.TextStyle(
//                 fontSize: 8,
//                 color: _muted,
//               ),
//             ),
//           );
//         },
//         build: (context) {
//           return [
//             _buildHeader(
//               test: test,
//               scorePercentage: scorePercentage,
//               hasPassed: hasPassed,
//               correctAnswersCount: correctAnswersCount,
//               wrongAnswersCount: wrongAnswersCount,
//               elapsedSeconds: elapsedSeconds,
//               cupSvg: cupSvg,
//             ),
//             pw.SizedBox(height: 14),
//             _sectionTitle('إجاباتك'),
//             pw.SizedBox(height: 10),
//             ...test.questions.map((question) {
//               final answer = answersByQuestionId[question.questionId];

//               return _buildQuestionResultCard(
//                 question: question,
//                 answer: answer,
//                 totalQuestions: test.questions.length,
//               );
//             }),
//             pw.SizedBox(height: 16),
//             _sectionTitle('جدول نتائجك'),
//             pw.SizedBox(height: 10),
//             _buildResultTable(
//               test: test,
//               answersByQuestionId: answersByQuestionId,
//             ),
//             pw.SizedBox(height: 20),
//             pw.Center(
//               child: pw.Text(
//                 'ملف PDF صادر عن Nerd، مهيأ للطباعة والمراجعة والأرشفة.',
//                 style: pw.TextStyle(
//                   fontSize: 9,
//                   color: _muted,
//                 ),
//               ),
//             ),
//           ];
//         },
//       ),
//     );

//     final directory = await getApplicationDocumentsDirectory();

//     final fileName =
//         'mcq_result_${test.testId}_${DateTime.now().millisecondsSinceEpoch}.pdf';

//     final file = File('${directory.path}/$fileName');

//     await file.writeAsBytes(await pdf.save());

//     return file.path;
//   }

//   pw.Widget _buildHeader({
//     required TestPlayInfoEntity test,
//     required int scorePercentage,
//     required bool hasPassed,
//     required int correctAnswersCount,
//     required int wrongAnswersCount,
//     required int elapsedSeconds,
//     required String cupSvg,
//   }) {
//     final resultColor = hasPassed ? _green : _red;

//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(
//         color: _primary,
//         borderRadius: pw.BorderRadius.circular(10),
//       ),
//       child: pw.Column(
//         children: [
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(14),
//             child: pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 pw.Expanded(
//                   flex: 3,
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         hasPassed
//                             ? 'تهانينا لقد أنجزت الاختبار!'
//                             : 'أحسنت، أكملت الاختبار!',
//                         textAlign: pw.TextAlign.right,
//                         style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontSize: 18,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 4),
//                       pw.Text(
//                         test.title,
//                         textAlign: pw.TextAlign.right,
//                         style: const pw.TextStyle(
//                           color: PdfColors.white,
//                           fontSize: 11,
//                         ),
//                       ),
//                       pw.SizedBox(height: 10),
//                       pw.Wrap(
//                         spacing: 7,
//                         runSpacing: 7,
//                         alignment: pw.WrapAlignment.end,
//                         children: [
//                           _statBox('النسبة', '$scorePercentage%'),
//                           _statBox('إجابات صحيحة', '$correctAnswersCount'),
//                           _statBox('إجابات خاطئة', '$wrongAnswersCount'),
//                           _statBox('الوقت المستغرق', _formatSeconds(elapsedSeconds)),
//                           _statBox('الحالة', hasPassed ? 'ناجح' : 'لم ينجح'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 pw.Container(
//                   margin: const pw.EdgeInsets.symmetric(horizontal: 14),
//                   width: 2,
//                   height: 105,
//                   decoration: pw.BoxDecoration(
//                     color: PdfColors.white,
//                     borderRadius: pw.BorderRadius.circular(4),
//                   ),
//                 ),
//                 pw.Expanded(
//                   flex: 2,
//                   child: pw.Center(
//                     child: pw.SvgImage(
//                       svg: cupSvg,
//                       width: 100,
//                       height: 100,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           pw.Container(
//             height: 5,
//             width: double.infinity,
//             decoration: pw.BoxDecoration(
//               color: resultColor,
//               borderRadius: const pw.BorderRadius.only(
//                 bottomLeft: pw.Radius.circular(10),
//                 bottomRight: pw.Radius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _statBox(String label, String value) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: pw.BoxDecoration(
//         color: PdfColor.fromHex('#FFFFFF'),
//         borderRadius: pw.BorderRadius.circular(5),
//       ),
//       child: pw.Column(
//         children: [
//           pw.Text(
//             label,
//             style: pw.TextStyle(
//               color: _primary,
//               fontSize: 8,
//             ),
//           ),
//           pw.Text(
//             value,
//             style: pw.TextStyle(
//               color: _primary,
//               fontSize: 12,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _sectionTitle(String title) {
//     return pw.Row(
//       children: [
//         pw.Container(
//           width: 5,
//           height: 20,
//           color: _primary,
//         ),
//         pw.SizedBox(width: 6),
//         pw.Text(
//           title,
//           style: pw.TextStyle(
//             fontSize: 15,
//             color: _text,
//             fontWeight: pw.FontWeight.bold,
//           ),
//         ),
//         pw.Expanded(
//           child: pw.Container(
//             margin: const pw.EdgeInsets.only(right: 8),
//             height: 1,
//             color: _border,
//           ),
//         ),
//       ],
//     );
//   }

//   pw.Widget _buildQuestionResultCard({
//     required TestPlayQuestionEntity question,
//     required TestPlayAnswerRecordEntity? answer,
//     required int totalQuestions,
//   }) {
//     final isCorrect = answer?.isCorrect == true;
//     final resultColor = isCorrect ? _green : _red;
//     final resultSoft = isCorrect ? _greenSoft : _redSoft;

//     return pw.Container(
//       width: double.infinity,
//       margin: const pw.EdgeInsets.only(bottom: 10),
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: _border, width: 0.8),
//         borderRadius: pw.BorderRadius.circular(8),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: pw.BoxDecoration(
//               color: _primarySoft,
//               borderRadius: const pw.BorderRadius.only(
//                 topLeft: pw.Radius.circular(8),
//                 topRight: pw.Radius.circular(8),
//               ),
//             ),
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   'السؤال ${question.position}',
//                   style: pw.TextStyle(
//                     color: _primary,
//                     fontSize: 11,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.Container(
//                   padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: pw.BoxDecoration(
//                     color: resultSoft,
//                     border: pw.Border.all(color: resultColor, width: 0.6),
//                     borderRadius: pw.BorderRadius.circular(20),
//                   ),
//                   child: pw.Text(
//                     '${question.position}/$totalQuestions - ${isCorrect ? 'صحيح' : 'خاطئ'}',
//                     style: pw.TextStyle(
//                       color: resultColor,
//                       fontSize: 9,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(10),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text(
//                   question.questionText,
//                   textAlign: pw.TextAlign.right,
//                   style: pw.TextStyle(
//                     fontSize: 11,
//                     color: _text,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 if (question.hintText != null &&
//                     question.hintText!.trim().isNotEmpty) ...[
//                   pw.SizedBox(height: 7),
//                   _hintBox(question.hintText!.trim()),
//                 ],
//                 pw.SizedBox(height: 8),
//                 ...question.options.map((option) {
//                   return _optionRow(
//                     option: option,
//                     answer: answer,
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _hintBox(String hint) {
//     return pw.Container(
//       width: double.infinity,
//       padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: pw.BoxDecoration(
//         color: _yellowSoft,
//         border: pw.Border.all(color: _yellowBorder, width: 0.7),
//         borderRadius: pw.BorderRadius.circular(6),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             'تلميح',
//             style: pw.TextStyle(
//               color: PdfColor.fromHex('#A66A00'),
//               fontSize: 9,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.SizedBox(height: 2),
//           pw.Text(
//             hint,
//             textAlign: pw.TextAlign.right,
//             style: pw.TextStyle(
//               color: PdfColor.fromHex('#7A5200'),
//               fontSize: 9,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _optionRow({
//     required TestPlayOptionEntity option,
//     required TestPlayAnswerRecordEntity? answer,
//   }) {
//     final isSelected = option.optionId == answer?.selectedOptionId;
//     final isCorrectOption = option.isCorrect;

//     final bool showCorrect = isCorrectOption;
//     final bool showWrong = isSelected && !isCorrectOption;

//     final color = showCorrect
//         ? _green
//         : showWrong
//             ? _red
//             : _muted;

//     final bgColor = showCorrect
//         ? _greenSoft
//         : showWrong
//             ? _redSoft
//             : PdfColor.fromHex('#F8FAFC');

//     return pw.Container(
//       width: double.infinity,
//       margin: const pw.EdgeInsets.only(bottom: 5),
//       padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: pw.BoxDecoration(
//         color: bgColor,
//         border: pw.Border.all(
//           color: showCorrect || showWrong ? color : _border,
//           width: 0.6,
//         ),
//         borderRadius: pw.BorderRadius.circular(5),
//       ),
//       child: pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Container(
//             width: 22,
//             alignment: pw.Alignment.center,
//             child: pw.Text(
//               _optionLetter(option.position),
//               style: pw.TextStyle(
//                 color: color,
//                 fontSize: 10,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
//           pw.SizedBox(width: 6),
//           pw.Expanded(
//             child: pw.Text(
//               option.optionText,
//               textAlign: pw.TextAlign.right,
//               style: pw.TextStyle(
//                 color: color,
//                 fontSize: 9.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget _buildResultTable({
//     required TestPlayInfoEntity test,
//     required Map<int, TestPlayAnswerRecordEntity> answersByQuestionId,
//   }) {
//     return pw.Table(
//       border: pw.TableBorder.all(
//         color: _border,
//         width: 0.6,
//       ),
//       columnWidths: const {
//         0: pw.FlexColumnWidth(1),
//         1: pw.FlexColumnWidth(1.2),
//         2: pw.FlexColumnWidth(1.2),
//         3: pw.FlexColumnWidth(1),
//       },
//       children: [
//         _resultTableRow(
//           cells: ['رقم السؤال', 'اختيارك', 'الإجابة الصحيحة', 'الحالة'],
//           isHeader: true,
//         ),
//         ...test.questions.map((question) {
//           final answer = answersByQuestionId[question.questionId];
//           final selectedOption = _findOptionById(
//             question,
//             answer?.selectedOptionId,
//           );
//           final correctOption = question.correctOption;

//           return _resultTableRow(
//             cells: [
//               '${question.position}',
//               selectedOption == null ? '-' : _optionLetter(selectedOption.position),
//               correctOption == null ? '-' : _optionLetter(correctOption.position),
//               answer?.isCorrect == true ? 'صحيح' : 'خاطئ',
//             ],
//             isCorrect: answer?.isCorrect == true,
//           );
//         }),
//       ],
//     );
//   }

//   pw.TableRow _resultTableRow({
//     required List<String> cells,
//     bool isHeader = false,
//     bool isCorrect = false,
//   }) {
//     final bgColor = isHeader
//         ? _primary
//         : isCorrect
//             ? _greenSoft
//             : _redSoft;

//     final textColor = isHeader
//         ? PdfColors.white
//         : isCorrect
//             ? _green
//             : _red;

//     return pw.TableRow(
//       decoration: pw.BoxDecoration(color: bgColor),
//       children: cells.map((cell) {
//         return pw.Padding(
//           padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
//           child: pw.Text(
//             cell,
//             textAlign: pw.TextAlign.center,
//             style: pw.TextStyle(
//               fontSize: isHeader ? 10 : 9,
//               color: textColor,
//               fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   TestPlayOptionEntity? _findOptionById(
//     TestPlayQuestionEntity question,
//     int? optionId,
//   ) {
//     if (optionId == null) return null;

//     for (final option in question.options) {
//       if (option.optionId == optionId) return option;
//     }

//     return null;
//   }

//   String _formatSeconds(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainingSeconds = seconds % 60;

//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   String _optionLetter(int position) {
//     const letters = ['A', 'B', 'C', 'D', 'E'];

//     if (position <= 0 || position > letters.length) {
//       return position.toString();
//     }

//     return letters[position - 1];
//   }
// }