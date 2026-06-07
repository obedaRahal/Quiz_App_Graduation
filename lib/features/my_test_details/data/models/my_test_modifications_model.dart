import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_test_modifications_entity.dart';

class MyTestModificationsModel {
  final bool success;
  final String title;
  final List<MyTestModificationItemModel> data;
  final int statusCode;

  const MyTestModificationsModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyTestModificationsModel.fromJson(Map<String, dynamic> json) {
    return MyTestModificationsModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: _asList(json['data'])
          .map((item) => MyTestModificationItemModel.fromJson(item))
          .toList(),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyTestModificationsEntity toEntity() {
    return MyTestModificationsEntity(
      success: success,
      title: title,
      data: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class MyTestModificationItemModel {
  final String revisionType;
  final String questionNumber;
  final String optionNumber;
  final String problemNote;
  final bool userHasModified;

  const MyTestModificationItemModel({
    required this.revisionType,
    required this.questionNumber,
    required this.optionNumber,
    required this.problemNote,
    required this.userHasModified,
  });

  factory MyTestModificationItemModel.fromJson(Map<String, dynamic> json) {
    return MyTestModificationItemModel(
      revisionType: json['revision_type']?.toString() ?? '',
      questionNumber: json['question_number']?.toString() ?? '-',
      optionNumber: json['option_number']?.toString() ?? '-',
      problemNote: json['problem_note']?.toString() ?? '',
      userHasModified: json['user_has_modified'] == true,
    );
  }

  MyTestModificationItemEntity toEntity() {
    return MyTestModificationItemEntity(
      revisionType: revisionType,
      questionNumber: questionNumber,
      optionNumber: optionNumber,
      problemNote: problemNote,
      userHasModified: userHasModified,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}