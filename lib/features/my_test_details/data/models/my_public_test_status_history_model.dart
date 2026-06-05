import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';

class MyPublicTestStatusHistoryModel {
  final bool success;
  final String title;
  final List<MyPublicTestStatusHistoryItemModel> data;
  final int statusCode;

  const MyPublicTestStatusHistoryModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory MyPublicTestStatusHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestStatusHistoryModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: _asList(json['data'])
          .map((item) => MyPublicTestStatusHistoryItemModel.fromJson(item))
          .toList(),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyPublicTestStatusHistoryEntity toEntity() {
    return MyPublicTestStatusHistoryEntity(
      success: success,
      title: title,
      data: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class MyPublicTestStatusHistoryItemModel {
  final int historyId;
  final int? roundId;
  final MyPublicTestStatusTransitionModel status;
  final String description;
  final String happenedAt;

  const MyPublicTestStatusHistoryItemModel({
    required this.historyId,
    required this.roundId,
    required this.status,
    required this.description,
    required this.happenedAt,
  });

  factory MyPublicTestStatusHistoryItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestStatusHistoryItemModel(
      historyId: _asInt(json['history_id']),
      roundId: _asNullableInt(json['round_id']),
      status: MyPublicTestStatusTransitionModel.fromJson(
        (json['status'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      description: json['description']?.toString() ?? '',
      happenedAt: json['happened_at']?.toString() ?? '',
    );
  }

  MyPublicTestStatusHistoryItemEntity toEntity() {
    return MyPublicTestStatusHistoryItemEntity(
      historyId: historyId,
      roundId: roundId,
      status: status.toEntity(),
      description: description,
      happenedAt: happenedAt,
    );
  }
}

class MyPublicTestStatusTransitionModel {
  final String? fromStatus;
  final String? toStatus;

  const MyPublicTestStatusTransitionModel({
    required this.fromStatus,
    required this.toStatus,
  });

  factory MyPublicTestStatusTransitionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyPublicTestStatusTransitionModel(
      fromStatus: _asNullableString(json['from_status']),
      toStatus: _asNullableString(json['to_status']),
    );
  }

  MyPublicTestStatusTransitionEntity toEntity() {
    return MyPublicTestStatusTransitionEntity(
      fromStatus: fromStatus,
      toStatus: toStatus,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty) return null;
  if (text == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}