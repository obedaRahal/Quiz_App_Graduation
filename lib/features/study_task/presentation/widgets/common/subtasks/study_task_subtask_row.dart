











import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

























class StudyTaskSubtaskRow extends StatefulWidget {
  final int index;
  final String value;
  final bool isCompleted;
  final bool showCompletedCheckbox;
  final int maxTitleLength;

  final ValueChanged<String> onTitleChanged;
  final ValueChanged<bool>? onCompletedChanged;
  final VoidCallback onRemove;

  const StudyTaskSubtaskRow({
    super.key,
    required this.index,
    required this.value,
    required this.isCompleted,
    required this.showCompletedCheckbox,
    required this.maxTitleLength,
    required this.onTitleChanged,
    required this.onRemove,
    this.onCompletedChanged,
  });

  @override
  State<StudyTaskSubtaskRow> createState() => _StudyTaskSubtaskRowState();
}

class _StudyTaskSubtaskRowState extends State<StudyTaskSubtaskRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant StudyTaskSubtaskRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            maxLength: widget.maxTitleLength,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxTitleLength),
            ],
            onChanged: widget.onTitleChanged,
            style: TextStyle(
              fontFamily: AppFont.elMessiriRegular,
              fontSize: SizeConfig.text(0.034),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'مهمة فرعية ${widget.index + 1}',
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(
                fontFamily: AppFont.elMessiriRegular,
                fontSize: SizeConfig.text(0.033),
                fontWeight: FontWeight.w500,
                color: AppPalette.greyMedium,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.h(0.010),
              ),
            ),
          ),
        ),

        if (widget.showCompletedCheckbox) ...[
          SizedBox(width: SizeConfig.w(0.010)),

          Checkbox(
            value: widget.isCompleted,
            onChanged: widget.onCompletedChanged == null
                ? null
                : (value) {
                    widget.onCompletedChanged!(value ?? false);
                  },
          ),
        ],

        SizedBox(width: SizeConfig.w(0.015)),

        InkWell(
          onTap: widget.onRemove,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.w(0.012)),
            child: Icon(
              Icons.close_rounded,
              size: SizeConfig.text(0.045),
              color: AppPalette.greyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
