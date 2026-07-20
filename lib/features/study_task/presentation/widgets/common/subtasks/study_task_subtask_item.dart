class StudyTaskSubtaskItem {
  final int? id;
  final String title;
  final bool isCompleted;

  const StudyTaskSubtaskItem({
    this.id,
    required this.title,
    required this.isCompleted,
  });

  StudyTaskSubtaskItem copyWith({int? id, String? title, bool? isCompleted}) {
    return StudyTaskSubtaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
