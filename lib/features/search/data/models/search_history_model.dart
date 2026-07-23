import 'package:quiz_app_grad/features/search/domain/entities/search_history_entity.dart';

class SearchHistoryResponseModel {
  final List<SearchHistoryModel> histories;

  const SearchHistoryResponseModel({required this.histories});

  factory SearchHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return SearchHistoryResponseModel(
      histories: (data['histories'] as List<dynamic>)
          .map(
            (item) => SearchHistoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}


class SearchHistoryModel extends SearchHistoryEntity {
  const SearchHistoryModel({required super.id, required super.query});

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'] as int,
      query: json['query'] as String,
    );
  }
}
