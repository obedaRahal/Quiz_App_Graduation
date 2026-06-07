class MyTestModificationsEntity {
  final bool success;
  final String title;
  final List<MyTestModificationItemEntity> data;
  final int statusCode;

  const MyTestModificationsEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class MyTestModificationItemEntity {
  final String revisionType;
  final String questionNumber;
  final String optionNumber;
  final String problemNote;
  final bool userHasModified;

  const MyTestModificationItemEntity({
    required this.revisionType,
    required this.questionNumber,
    required this.optionNumber,
    required this.problemNote,
    required this.userHasModified,
  });
}