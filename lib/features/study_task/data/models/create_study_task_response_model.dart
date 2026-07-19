import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';

class CreateStudyTaskResponseModel extends CreateStudyTaskResponseEntity {
  const CreateStudyTaskResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory CreateStudyTaskResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudyTaskResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _parseInt(json['status_code']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  String toString() {
    return 'CreateStudyTaskResponseModel('
        'success: $success, '
        'title: $title, '
        'message: $message, '
        'statusCode: $statusCode'
        ')';
  }
}
