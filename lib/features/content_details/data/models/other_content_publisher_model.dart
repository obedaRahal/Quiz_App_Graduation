import '../../domain/entities/other_content_publisher_entity.dart';

class OtherContentPublisherModel extends OtherContentPublisherEntity {
  const OtherContentPublisherModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.followersCount,
    required super.followingCount,
    required super.publishedTestsCount,
  });

  factory OtherContentPublisherModel.fromJson(Map<String, dynamic> json) {
    return OtherContentPublisherModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      publishedTestsCount: json['published_tests_count'] ?? 0,
    );
  }
}