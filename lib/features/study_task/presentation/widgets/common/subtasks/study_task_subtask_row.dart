// import 'package:flutter/material.dart';

// class StudyTaskSubtaskRow extends StatelessWidget {
//   final int index;
//   final String title;
//   final bool isCompleted;

//   final int maxTitleLength;

//   final ValueChanged<String> onTitleChanged;
//   final ValueChanged<bool>? onCompletedChanged;
//   final VoidCallback onRemove;

//   final bool canRemove;
//   final bool showCompletedCheckbox;

//   const StudyTaskSubtaskRow({
//     super.key,
//     required this.index,
//     required this.title,
//     required this.isCompleted,
//     required this.maxTitleLength,
//     required this.onTitleChanged,
//     required this.onRemove,
//     required this.canRemove,
//     this.onCompletedChanged,
//     this.showCompletedCheckbox = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       textDirection: TextDirection.rtl,
//       children: [
//         if (showCompletedCheckbox)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Checkbox(
//               value: isCompleted,
//               onChanged: onCompletedChanged == null
//                   ? null
//                   : (value) {
//                       if (value == null) {
//                         return;
//                       }

//                       onCompletedChanged!(value);
//                     },
//             ),
//           ),

//         if (showCompletedCheckbox) const SizedBox(width: 8),

//         Expanded(
//           child: TextFormField(
//             key: ValueKey('study-task-subtask-$index'),
//             initialValue: title,
//             maxLength: maxTitleLength,
//             textDirection: TextDirection.rtl,
//             textAlign: TextAlign.right,
//             decoration: InputDecoration(
//               hintText: 'اكتب المهمة الفرعية',
//               counterText: '${title.length}/$maxTitleLength',
//               border: const OutlineInputBorder(),
//               prefixIcon: const Icon(Icons.subdirectory_arrow_left_rounded),
//             ),
//             onChanged: onTitleChanged,
//           ),
//         ),

//         const SizedBox(width: 8),

//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: IconButton(
//             tooltip: 'حذف المهمة الفرعية',
//             onPressed: canRemove ? onRemove : null,
//             icon: const Icon(Icons.delete_outline_rounded),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class StudyTaskSubtaskRow extends StatelessWidget {
//   final int index;
//   final String title;
//   final bool isCompleted;
//   final int maxTitleLength;

//   final bool canRemove;
//   final bool showCompletedCheckbox;

//   final ValueChanged<String> onTitleChanged;
//   final ValueChanged<bool>? onCompletedChanged;
//   final VoidCallback onRemove;

//   const StudyTaskSubtaskRow({
//     super.key,
//     required this.index,
//     required this.title,
//     required this.isCompleted,
//     required this.maxTitleLength,
//     required this.canRemove,
//     required this.showCompletedCheckbox,
//     required this.onTitleChanged,
//     required this.onRemove,
//     this.onCompletedChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: TextFormField(
//             key: ValueKey('subtask-field-$index-$title'),
//             initialValue: title,
//             maxLength: maxTitleLength,
//             textDirection: TextDirection.rtl,
//             textAlign: TextAlign.right,
//             decoration: const InputDecoration(
//               hintText: 'اكتب المهمة الفرعية',
//               counterText: '',
//               border: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
//             ),
//             onChanged: onTitleChanged,
//           ),
//         ),

//         if (showCompletedCheckbox) ...[
//           Checkbox(
//             value: isCompleted,
//             onChanged: onCompletedChanged == null
//                 ? null
//                 : (value) {
//                     onCompletedChanged!(value ?? false);
//                   },
//           ),
//         ],

//         IconButton(
//           onPressed: canRemove ? onRemove : null,
//           tooltip: 'حذف المهمة الفرعية',
//           icon: Icon(
//             Icons.close_rounded,
//             size: 22,
//             color: canRemove
//                 ? AppPalette.grey
//                 : AppPalette.grey.withValues(alpha: 0.35),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class StudyTaskSubtaskRow extends StatefulWidget {
//   final int index;
//   final String title;
//   final bool isCompleted;
//   final int maxTitleLength;

//   final bool canRemove;
//   final bool showCompletedCheckbox;

//   final ValueChanged<String> onTitleChanged;
//   final ValueChanged<bool>? onCompletedChanged;
//   final VoidCallback onRemove;

//   const StudyTaskSubtaskRow({
//     super.key,
//     required this.index,
//     required this.title,
//     required this.isCompleted,
//     required this.maxTitleLength,
//     required this.canRemove,
//     required this.showCompletedCheckbox,
//     required this.onTitleChanged,
//     required this.onRemove,
//     this.onCompletedChanged,
//   });

//   @override
//   State<StudyTaskSubtaskRow> createState() => _StudyTaskSubtaskRowState();
// }

// class _StudyTaskSubtaskRowState extends State<StudyTaskSubtaskRow> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = TextEditingController(text: widget.title);
//   }

//   @override
//   void didUpdateWidget(covariant StudyTaskSubtaskRow oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.title != oldWidget.title && widget.title != _controller.text) {
//       _controller.value = TextEditingValue(
//         text: widget.title,
//         selection: TextSelection.collapsed(offset: widget.title.length),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Row(
//       textDirection: TextDirection.rtl,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             textDirection: TextDirection.rtl,
//             textAlign: TextAlign.right,
//             maxLength: widget.maxTitleLength,
//             textInputAction: TextInputAction.next,
//             inputFormatters: [
//               LengthLimitingTextInputFormatter(widget.maxTitleLength),
//             ],
//             onChanged: widget.onTitleChanged,
//             style: TextStyle(
//               fontFamily: AppFont.elMessiriRegular,
//               fontSize: SizeConfig.text(0.034),
//               fontWeight: FontWeight.w500,
//               color: isDark
//                   ? AppPalette.textWhiteINDark
//                   : AppPalette.textColorInHome,
//             ),
//             decoration: InputDecoration(
//               counterText: '',
//               hintText: 'مهمة فرعية ${widget.index + 1}',
//               hintTextDirection: TextDirection.rtl,
//               hintStyle: TextStyle(
//                 fontFamily: AppFont.elMessiriRegular,
//                 fontSize: SizeConfig.text(0.033),
//                 fontWeight: FontWeight.w500,
//                 color: AppPalette.greyMedium,
//               ),
//               border: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: SizeConfig.h(0.010),
//               ),
//             ),
//           ),
//         ),

//         if (widget.showCompletedCheckbox)
//           Checkbox(
//             value: widget.isCompleted,
//             onChanged: widget.onCompletedChanged == null
//                 ? null
//                 : (value) {
//                     widget.onCompletedChanged!(value ?? false);
//                   },
//           ),

//         SizedBox(width: SizeConfig.w(0.015)),

//         InkWell(
//           onTap: widget.onRemove,
//           borderRadius: BorderRadius.circular(20),
//           child: Padding(
//             padding: EdgeInsets.all(SizeConfig.w(0.012)),
//             child: Icon(
//               Icons.close_rounded,
//               size: SizeConfig.text(0.045),
//               color: AppPalette.greyMedium,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

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
