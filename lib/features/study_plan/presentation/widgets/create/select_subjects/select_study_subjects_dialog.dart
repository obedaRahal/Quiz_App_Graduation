import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/select_subjects/selectable_study_subject_chip.dart';

class SelectStudySubjectsDialog extends StatefulWidget {
  final List<StudySubjectEntity> subjects;
  final Set<int> initiallySelectedIds;
  final int maxSelection;

  const SelectStudySubjectsDialog({
    super.key,
    required this.subjects,
    required this.initiallySelectedIds,
    this.maxSelection = 10,
  });

  @override
  State<SelectStudySubjectsDialog> createState() =>
      _SelectStudySubjectsDialogState();
}

class _SelectStudySubjectsDialogState extends State<SelectStudySubjectsDialog> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();

    final availableIds = widget.subjects.map((subject) => subject.id).toSet();

    _selectedIds = widget.initiallySelectedIds
        .where(availableIds.contains)
        .take(widget.maxSelection)
        .toSet();
  }

  void _toggleSubject(int subjectId) {
    setState(() {
      if (_selectedIds.contains(subjectId)) {
        _selectedIds.remove(subjectId);
        return;
      }

      if (_selectedIds.length >= widget.maxSelection) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'يمكنك اختيار ${widget.maxSelection} مواد على الأكثر',
                textAlign: TextAlign.right,
              ),
            ),
          );

        return;
      }

      _selectedIds.add(subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        decoration: BoxDecoration(
          color: context.appColors.whiteToblack,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.w(0.035),
                SizeConfig.h(0.015),
                SizeConfig.w(0.035),
                SizeConfig.h(0.008),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      'مواد الخطة',
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.043),
                      color: context.appColors.blackToGrey2Dark,
                      textAlign: TextAlign.right,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.025),
                      vertical: SizeConfig.h(0.004),
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.primaryToPrimaryDark.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomTextWidget(
                      '${_selectedIds.length}/${widget.maxSelection}',
                      fontFamily: AppFont.elMessiriSemiBold,
                      fontSize: SizeConfig.text(0.028),
                      color: context.appColors.primaryToPrimaryDark,
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.02)),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: SizeConfig.w(0.075),
                      height: SizeConfig.w(0.075),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppPalette.fieldColorNDark
                            : AppPalette.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: SizeConfig.text(0.05),
                        color: context.appColors.blackToGrey2Dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const CustomDivider(height: 20, thickness: 2),

            Flexible(
              child: widget.subjects.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.04),
                        vertical: SizeConfig.h(0.04),
                      ),
                      child: CustomTextWidget(
                        'لا توجد مواد متاحة، أضف مادة أولًا من إدارة المواد',
                        fontSize: SizeConfig.text(0.031),
                        color: AppPalette.greyMedium,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.035),
                        vertical: SizeConfig.h(0.012),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          spacing: SizeConfig.w(0.018),
                          runSpacing: SizeConfig.h(0.01),
                          children: widget.subjects
                              .map(
                                (subject) => SelectableStudySubjectChip(
                                  subject: subject,
                                  isSelected: _selectedIds.contains(subject.id),
                                  onTap: () {
                                    _toggleSubject(subject.id);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.w(0.035),
                SizeConfig.h(0.012),
                SizeConfig.w(0.035),
                SizeConfig.h(0.015),
              ),
              child: CustomButtonWidget(
                width: double.infinity,
                backgroundColor: context.appColors.primaryToPrimaryDark,
                childHorizontalPad: SizeConfig.w(0.04),
                childVerticalPad: SizeConfig.h(0.011),
                borderRadius: 7,
                onTap: widget.subjects.isEmpty
                    ? () {}
                    : () {
                        Navigator.of(context).pop(Set<int>.from(_selectedIds));
                      },
                child: CustomTextWidget(
                  'تأكيد',
                  fontFamily: AppFont.elMessiriSemiBold,
                  fontSize: SizeConfig.text(0.031),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
