import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';

class StudyPlanTitleSection extends StatelessWidget {
  final String title;
  final String emoji;

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onEmojiChanged;

  const StudyPlanTitleSection({
    super.key,
    required this.title,
    required this.emoji,
    required this.onChanged,
    required this.onEmojiChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: 'العنوان',
          description:
              'حدد عنوانًا واضحًا وسهلًا لخطة الدراسة التي تريد إنشاءها.',
          image: AppImage.menu,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudyPlanEmojiField(value: emoji, onChanged: onEmojiChanged),
            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: CreateTestCounterTextField(
                value: title,
                hintText: 'العنوان',
                image: AppImage.selfie,
                maxLength: 100,
                currentLength: title.length,
                minLines: 1,
                maxLines: 1,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StudyPlanEmojiField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StudyPlanEmojiField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<StudyPlanEmojiField> createState() => _StudyPlanEmojiFieldState();
}

class _StudyPlanEmojiFieldState extends State<StudyPlanEmojiField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);

    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant StudyPlanEmojiField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;

      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _handleChanged(String value) {
    if (value.isEmpty) {
      widget.onChanged('');
      return;
    }

    // نحفظ آخر رمز تمت إضافته فقط.
    // characters تحافظ على الإيموجي المركب كوحدة واحدة.
    final lastCharacter = value.characters.last;

    if (_controller.text != lastCharacter) {
      _controller.value = TextEditingValue(
        text: lastCharacter,
        selection: TextSelection.collapsed(offset: lastCharacter.length),
      );
    }

    widget.onChanged(lastCharacter);
  }

  void _openKeyboard() {
    _focusNode.requestFocus();

    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final appColors = context.appColors;

    return GestureDetector(
      onTap: _openKeyboard,
      child: SizedBox(
        width: SizeConfig.h(0.057),
        height: SizeConfig.h(0.057),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: _handleChanged,
          style: TextStyle(fontSize: SizeConfig.text(0.060), height: 1),
          decoration: InputDecoration(
            counterText: '',
            hintText: '🎓',
            hintStyle: TextStyle(fontSize: SizeConfig.text(0.052)),
            filled: true,
            fillColor: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: appColors.primaryToPrimaryDark,
                width: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
