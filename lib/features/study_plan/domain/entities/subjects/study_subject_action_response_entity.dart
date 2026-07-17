class StudySubjectActionResponseEntity {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const StudySubjectActionResponseEntity({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  StudySubjectActionResponseEntity copyWith({
    bool? success,
    String? title,
    String? message,
    int? statusCode,
  }) {
    return StudySubjectActionResponseEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}