import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_form_sections.dart';

class CreateStudyTaskContent extends StatelessWidget {
  const CreateStudyTaskContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: const SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsetsDirectional.fromSTEB(
          16,
          20,
          16,
          28,
        ),
        child: CreateStudyTaskFormSections(),
      ),
    );
  }
}