import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';

const questionImportAiPrompt = '''
أنشئ ملف JSON صالحًا لاستيراد أسئلة اختيار من متعدد في تطبيق الاختبارات.
أعد محتوى JSON فقط، دون Markdown أو شرح إضافي، ليُحفظ باسم quiz_import.json.

استخدم البنية التالية بالضبط:
{
  "questions": [
    {
      "question": "نص السؤال، 10 أحرف على الأقل",
      "options": ["الخيار الأول", "الخيار الثاني", "الخيار الثالث", "الخيار الرابع"],
      "correctOptionIndex": 0,
      "explanation": "شرح اختياري"
    }
  ]
}

الشروط:
- أسئلة اختيار من متعدد فقط.
- من خيارين إلى خمسة خيارات لكل سؤال.
- correctOptionIndex يبدأ من 0 ويشير إلى الخيار الصحيح.
- نص السؤال بين 10 و500 حرف، وكل خيار لا يتجاوز 150 حرفًا.
- explanation اختياري ولا يتجاوز 1000 حرف.
- لا تضف حقولًا أخرى.
''';

const questionImportJsonExample = '''
{
  "questions": [
    {
      "question": "ما هي عاصمة الجمهورية العربية السورية؟",
      "options": ["دمشق", "حلب", "حمص", "اللاذقية"],
      "correctOptionIndex": 0,
      "explanation": "دمشق هي عاصمة الجمهورية العربية السورية."
    }
  ]
}
''';

class CreateTestQuestionsImportSection extends StatelessWidget {
  const CreateTestQuestionsImportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(0.030)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : appColors.primaryToPrimaryDark.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upload_file_rounded,
                color: appColors.primaryToPrimaryDark,
                size: SizeConfig.text(0.050),
              ),
              SizedBox(width: SizeConfig.w(0.014)),
              Expanded(
                child: CustomTextWidget(
                  'استيراد أسئلة من ملف JSON',
                  fontSize: SizeConfig.text(0.035),
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(0.006)),
          CustomTextWidget(
            'أنشئ الملف عبر أداة ذكاء اصطناعي ثم أضفه إلى الأسئلة الحالية لمراجعته وتعديله قبل الحفظ.',
            fontSize: SizeConfig.text(0.027),
            fontWeight: FontWeight.w600,
            color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
            textAlign: TextAlign.right,
            maxLines: 3,
          ),
          SizedBox(height: SizeConfig.h(0.014)),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.h(0.048),
            child: ElevatedButton.icon(
              onPressed: () => _pickQuestionsJsonFile(context),
              icon: Icon(
                Icons.folder_open_rounded,
                size: SizeConfig.text(0.040),
              ),
              label: CustomTextWidget(
                'اختيار ملف JSON',
                fontSize: SizeConfig.text(0.031),
                fontWeight: FontWeight.w900,
                color: AppPalette.white,
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primaryToPrimaryDark,
                foregroundColor: AppPalette.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.h(0.010)),
          Row(
            children: [
              Expanded(
                child: _ImportOutlineButton(
                  icon: Icons.auto_awesome_outlined,
                  label: 'نسخ البرومبت',
                  onPressed: () => _copyImportText(
                    context,
                    value: questionImportAiPrompt,
                    successMessage: 'تم نسخ البرومبت. أرسله إلى أداة الذكاء الاصطناعي.',
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.w(0.020)),
              Expanded(
                child: _ImportOutlineButton(
                  icon: Icons.code_rounded,
                  label: 'عرض نموذج JSON',
                  onPressed: () => showQuestionImportExampleDialog(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImportOutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ImportOutlineButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      height: SizeConfig.h(0.044),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: SizeConfig.text(0.033)),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomTextWidget(
            label,
            fontSize: SizeConfig.text(0.027),
            fontWeight: FontWeight.w800,
            color: appColors.primaryToPrimaryDark,
            textAlign: TextAlign.center,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: appColors.primaryToPrimaryDark,
          side: BorderSide(color: appColors.primaryToPrimaryDark),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.012)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

Future<void> _copyImportText(
  BuildContext context, {
  required String value,
  required String successMessage,
}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (!context.mounted) return;

  showValidationTopSnackBar(
    context,
    title: 'تم النسخ',
    message: successMessage,
    type: AppValidationSnackBarType.success,
  );
}

Future<void> _pickQuestionsJsonFile(BuildContext context) async {
  final pickerResult = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['json'],
    allowMultiple: false,
    withData: true,
  );

  if (pickerResult == null || pickerResult.files.isEmpty || !context.mounted) {
    return;
  }

  final cubit = context.read<CreateTestCubit>();
  final importResult = cubit.prepareImportedQuestions(pickerResult.files.first);

  if (!importResult.isSuccess) {
    await showQuestionImportErrorDialog(context, importResult.error!);
    return;
  }

  final shouldAppend = await showQuestionImportConfirmationDialog(
    context,
    importedQuestionsCount: importResult.questions.length,
    totalQuestionsCount:
        cubit.state.questions.length + importResult.questions.length,
  );

  if (shouldAppend != true || !context.mounted) return;

  cubit.appendImportedQuestions(importResult.questions);

  showValidationTopSnackBar(
    context,
    title: 'تمت إضافة الأسئلة',
    message:
        'تمت إضافة ${importResult.questions.length} سؤالًا. راجعها وعدّلها قبل إنشاء الاختبار.',
    type: AppValidationSnackBarType.success,
  );
}

Future<void> showQuestionImportExampleDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('نموذج ملف JSON'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                questionImportJsonExample,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _copyImportText(
                dialogContext,
                value: questionImportJsonExample,
                successMessage: 'تم نسخ نموذج JSON.',
              ),
              child: const Text('نسخ النموذج'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showQuestionImportErrorDialog(
  BuildContext context,
  String error,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تعذر استيراد الأسئلة'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('حسنًا'),
            ),
          ],
        ),
      );
    },
  );
}

Future<bool?> showQuestionImportConfirmationDialog(
  BuildContext context, {
  required int importedQuestionsCount,
  required int totalQuestionsCount,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إضافة الأسئلة المستوردة؟'),
          content: Text(
            'تم العثور على $importedQuestionsCount سؤالًا صالحًا. سيصبح إجمالي الأسئلة $totalQuestionsCount. لن يتم إرسال الاختبار تلقائيًا.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('إضافة الأسئلة'),
            ),
          ],
        ),
      );
    },
  );
}
