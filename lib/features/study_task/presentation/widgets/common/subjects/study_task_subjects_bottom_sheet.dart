import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subject_option.dart';

Future<int?> showStudyTaskSubjectsBottomSheet({
  required BuildContext context,
  required List<StudyTaskSubjectOption> subjects,
  required int? selectedSubjectId,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return _StudyTaskSubjectsBottomSheet(
        subjects: subjects,
        selectedSubjectId: selectedSubjectId,
      );
    },
  );
}

class _StudyTaskSubjectsBottomSheet extends StatefulWidget {
  final List<StudyTaskSubjectOption> subjects;
  final int? selectedSubjectId;

  const _StudyTaskSubjectsBottomSheet({
    required this.subjects,
    required this.selectedSubjectId,
  });

  @override
  State<_StudyTaskSubjectsBottomSheet> createState() {
    return _StudyTaskSubjectsBottomSheetState();
  }
}

class _StudyTaskSubjectsBottomSheetState
    extends State<_StudyTaskSubjectsBottomSheet> {
  late List<StudyTaskSubjectOption> _filteredSubjects;

  @override
  void initState() {
    super.initState();

    _filteredSubjects = widget.subjects;
  }

  void _searchChanged(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredSubjects = widget.subjects;
        return;
      }

      _filteredSubjects = widget.subjects.where((subject) {
        return subject.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: SizedBox(
          height: mediaQuery.size.height * 0.70,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 12),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'اختيار المادة الدراسية',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                child: TextField(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  onChanged: _searchChanged,
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن مادة',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Expanded(
                child: _filteredSubjects.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مواد مطابقة',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _filteredSubjects.length,
                        separatorBuilder: (_, __) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          final subject = _filteredSubjects[index];

                          final isSelected =
                              subject.id == widget.selectedSubjectId;

                          return ListTile(
                            onTap: () {
                              Navigator.of(context).pop(subject.id);
                            },
                            leading: Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                            ),
                            title: Text(
                              subject.name,
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
