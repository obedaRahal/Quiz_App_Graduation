import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

class CreateStudyTaskSubtasksSection extends StatelessWidget {
  const CreateStudyTaskSubtasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.subtasks != current.subtasks;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudyPlanFormSectionHeader(
              title: 'المهام الفرعية',
              description:
                  'يمكنك تقسيم هذه المهمة إلى خطوات صغيرة ليسهل عليك إنجازها ومتابعتها.',
              image: AppImage.layers,
            ),

            SizedBox(height: SizeConfig.h(0.016)),

            _SubtasksContainer(
              subtasks: state.subtasks,
              canAddSubtask: state.canAddSubtask,
            ),

            SizedBox(height: SizeConfig.h(0.006)),

            Align(
              alignment: Alignment.centerLeft,
              child: CustomTextWidget(
                '${state.subtasksCount}/'
                '${CreateStudyTaskState.maxSubtasksCount}',
                fontSize: SizeConfig.text(0.028),
                fontWeight: FontWeight.w700,
                color: AppPalette.greyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubtasksContainer extends StatelessWidget {
  final List<String> subtasks;
  final bool canAddSubtask;

  const _SubtasksContainer({
    required this.subtasks,
    required this.canAddSubtask,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.030),
        vertical: SizeConfig.h(0.012),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(subtasks.length, (index) {
            return Column(
              children: [
                _SubtaskInputRow(
                  key: ValueKey('create-study-task-subtask-$index'),
                  index: index,
                  value: subtasks[index],
                  canRemove: subtasks.length > 1,
                ),

                if (index != subtasks.length - 1)
                  Divider(
                    height: SizeConfig.h(0.020),
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.borderFieldColorNLight,
                  ),
              ],
            );
          }),

          if (subtasks.isNotEmpty) SizedBox(height: SizeConfig.h(0.008)),

          _AddSubtaskButton(enabled: canAddSubtask),
        ],
      ),
    );
  }
}

class _SubtaskInputRow extends StatefulWidget {
  final int index;
  final String value;
  final bool canRemove;

  const _SubtaskInputRow({
    super.key,
    required this.index,
    required this.value,
    required this.canRemove,
  });

  @override
  State<_SubtaskInputRow> createState() => _SubtaskInputRowState();
}

class _SubtaskInputRowState extends State<_SubtaskInputRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _SubtaskInputRow oldWidget) {
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
            maxLength: CreateStudyTaskState.subtaskTitleMaxLength,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                CreateStudyTaskState.subtaskTitleMaxLength,
              ),
            ],
            onChanged: (value) {
              context.read<CreateStudyTaskCubit>().changeSubtaskTitle(
                index: widget.index,
                value: value,
              );
            },
            style: TextStyle(
              fontFamily: AppFont.elMessiriRegular,
              fontSize: SizeConfig.text(0.034),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
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

        SizedBox(width: SizeConfig.w(0.015)),

        InkWell(
          onTap: () {
            final cubit = context.read<CreateStudyTaskCubit>();

            if (widget.canRemove) {
              cubit.removeSubtask(widget.index);

              return;
            }

            _controller.clear();

            cubit.changeSubtaskTitle(index: widget.index, value: '');
          },
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

class _AddSubtaskButton extends StatelessWidget {
  final bool enabled;

  const _AddSubtaskButton({required this.enabled});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: enabled
          ? () {
              debugPrint('============ Add Study Task Subtask ============');

              context.read<CreateStudyTaskCubit>().addSubtask();
            }
          : null,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.008)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              Icons.add_circle_rounded,
              size: SizeConfig.text(0.050),
              color: enabled
                  ? appColors.primaryToPrimaryDark
                  : AppPalette.greyMedium,
            ),

            SizedBox(width: SizeConfig.w(0.018)),

            CustomTextWidget(
              enabled ? 'إضافة مهمة فرعية جديدة' : 'تم الوصول إلى الحد الأقصى',
              fontSize: SizeConfig.text(0.033),
              fontWeight: FontWeight.w700,
              color: enabled
                  ? appColors.primaryToPrimaryDark
                  : AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
