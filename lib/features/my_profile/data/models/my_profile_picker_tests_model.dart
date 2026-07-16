import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';

class MyProfilePickerTestsModel {
  final bool success;
  final String message;
  final List<MyProfilePickerTestItemModel> data;
  final MyProfilePickerTestsMetaModel meta;
  final int statusCode;

  const MyProfilePickerTestsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory MyProfilePickerTestsModel.fromJson(Map<String, dynamic> json) {
    return MyProfilePickerTestsModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(
        json['data'],
      ).map((item) => MyProfilePickerTestItemModel.fromJson(item)).toList(),
      meta: MyProfilePickerTestsMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyProfilePickerTestsEntity toEntity() {
    return MyProfilePickerTestsEntity(
      success: success,
      message: message,
      data: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyProfilePickerTestItemModel {
  final int id;
  final String title;
  final String description;
  final List<MyProfilePickerTestInterestModel> interests;
  final String targetLevel;
  final double averageRating;
  final double price;
  final String publishedAt;
  final int questionCount;

  const MyProfilePickerTestItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.questionCount,
  });

  factory MyProfilePickerTestItemModel.fromJson(Map<String, dynamic> json) {
    return MyProfilePickerTestItemModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      interests: _asMapList(
        json['interests'],
      ).map((item) => MyProfilePickerTestInterestModel.fromJson(item)).toList(),
      targetLevel: json['target_level']?.toString() ?? '',
      averageRating: _asDouble(json['average_rating']),
      price: _asDouble(json['price']),
      publishedAt: json['published_at']?.toString() ?? '',
      questionCount: _asInt(json['question_count']),
    );
  }

  MyProfilePickerTestItemEntity toEntity() {
    return MyProfilePickerTestItemEntity(
      id: id,
      title: title,
      description: description,
      interests: interests.map((item) => item.toEntity()).toList(),
      targetLevel: targetLevel,
      averageRating: averageRating,
      price: price,
      publishedAt: publishedAt,
      questionCount: questionCount,
    );
  }
}

class MyProfilePickerTestInterestModel {
  final int id;
  final String name;

  const MyProfilePickerTestInterestModel({
    required this.id,
    required this.name,
  });

  factory MyProfilePickerTestInterestModel.fromJson(Map<String, dynamic> json) {
    return MyProfilePickerTestInterestModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  MyProfilePickerTestInterestEntity toEntity() {
    return MyProfilePickerTestInterestEntity(id: id, name: name);
  }
}

class MyProfilePickerTestsMetaModel {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfilePickerTestsMetaModel({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });

  factory MyProfilePickerTestsMetaModel.fromJson(Map<String, dynamic> json) {
    return MyProfilePickerTestsMetaModel(
      perPage: _asInt(json['per_page']),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(json['prev_cursor']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  MyProfilePickerTestsMetaEntity toEntity() {
    return MyProfilePickerTestsMetaEntity(
      perPage: perPage,
      nextCursor: nextCursor,
      prevCursor: prevCursor,
      hasMorePages: hasMorePages,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  if (text.isEmpty || text == 'null') return null;

  return text;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}

class MyProfilePickerSearchTestsModel {
  final bool success;
  final String message;
  final List<MyProfilePickerTestItemModel> data;
  final MyProfilePickerSearchTestsMetaModel meta;
  final int statusCode;

  const MyProfilePickerSearchTestsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });

  factory MyProfilePickerSearchTestsModel.fromJson(Map<String, dynamic> json) {
    return MyProfilePickerSearchTestsModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: _asMapList(
        json['data'],
      ).map((item) => MyProfilePickerTestItemModel.fromJson(item)).toList(),
      meta: MyProfilePickerSearchTestsMetaModel.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  MyProfilePickerSearchTestsEntity toEntity() {
    return MyProfilePickerSearchTestsEntity(
      success: success,
      message: message,
      data: data.map((item) => item.toEntity()).toList(),
      meta: meta.toEntity(),
      statusCode: statusCode,
    );
  }
}

class MyProfilePickerSearchTestsMetaModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;

  const MyProfilePickerSearchTestsMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
  });

  factory MyProfilePickerSearchTestsMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyProfilePickerSearchTestsMetaModel(
      currentPage: _asInt(json['current_page']),
      perPage: _asInt(json['per_page']),
      total: _asInt(json['total']),
      lastPage: _asInt(json['last_page']),
      hasMorePages: json['has_more_pages'] == true,
    );
  }

  MyProfilePickerSearchTestsMetaEntity toEntity() {
    return MyProfilePickerSearchTestsMetaEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMorePages: hasMorePages,
    );
  }
}
