import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

class CreateStudyTaskTitleDescriptionSection
    extends StatelessWidget {
  const CreateStudyTaskTitleDescriptionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        CreateStudyTaskCubit,
        CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'معلومات المهمة',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 14),

            _TaskTitleField(
              value: state.title,
            ),
            const SizedBox(height: 16),

            _TaskDescriptionField(
              value: state.description,
            ),
          ],
        );
      },
    );
  }
}

class _TaskTitleField extends StatefulWidget {
  final String value;

  const _TaskTitleField({
    required this.value,
  });

  @override
  State<_TaskTitleField> createState() =>
      _TaskTitleFieldState();
}

class _TaskTitleFieldState
    extends State<_TaskTitleField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.value,
    );

    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(
    covariant _TaskTitleField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(
          offset: widget.value.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      textInputAction: TextInputAction.next,
      maxLength:
          CreateStudyTaskState.titleMaxLength,
      onChanged: context
          .read<CreateStudyTaskCubit>()
          .changeTitle,
      decoration: const InputDecoration(
        labelText: 'عنوان المهمة',
        hintText: 'مثال: مراجعة الفصل الأول',
        prefixIcon: Icon(
          Icons.title_rounded,
        ),
        border: OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
}

class _TaskDescriptionField extends StatefulWidget {
  final String value;

  const _TaskDescriptionField({
    required this.value,
  });

  @override
  State<_TaskDescriptionField> createState() =>
      _TaskDescriptionFieldState();
}

class _TaskDescriptionFieldState
    extends State<_TaskDescriptionField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.value,
    );
  }

  @override
  void didUpdateWidget(
    covariant _TaskDescriptionField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(
          offset: widget.value.length,
        ),
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
    return TextFormField(
      controller: _controller,
      minLines: 4,
      maxLines: 7,
      maxLength:
          CreateStudyTaskState.descriptionMaxLength,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      onChanged: context
          .read<CreateStudyTaskCubit>()
          .changeDescription,
      decoration: const InputDecoration(
        labelText: 'وصف المهمة',
        hintText:
            'اكتب تفاصيل المهمة وما الذي تريد إنجازه',
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            bottom: 72,
          ),
          child: Icon(
            Icons.description_outlined,
          ),
        ),
        border: OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
}