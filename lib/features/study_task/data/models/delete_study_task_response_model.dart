import 'package:quiz_app_grad/features/study_task/domain/entities/delete_study_task_response_entity.dart';

class DeleteStudyTaskResponseModel extends DeleteStudyTaskResponseEntity {
  const DeleteStudyTaskResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory DeleteStudyTaskResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteStudyTaskResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: int.tryParse(json['status_code']?.toString() ?? '') ?? 0,
    );
  }
}
