class OtherProfileContentResponseEntity {
  final bool success;
  final String message;
  final List<OtherProfileContentItemEntity> data;
  final OtherProfileContentMetaEntity meta;
  final int statusCode;

  const OtherProfileContentResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class OtherProfileContentItemEntity {
  final int id;
  final String urlContent;
  final String title;
  final String description;
  final String type;
  final List<String> interests;
  final int likeCount;
  final String publishedAt;
  final bool viewerHasBookmarked;

  const OtherProfileContentItemEntity({
    required this.id,
    required this.urlContent,
    required this.title,
    required this.description,
    required this.type,
    required this.interests,
    required this.likeCount,
    required this.publishedAt,
    required this.viewerHasBookmarked,
  });

  OtherProfileContentItemEntity copyWith({
    int? id,
    String? urlContent,
    String? title,
    String? description,
    String? type,
    List<String>? interests,
    int? likeCount,
    String? publishedAt,
    bool? viewerHasBookmarked,
  }) {
    return OtherProfileContentItemEntity(
      id: id ?? this.id,
      urlContent: urlContent ?? this.urlContent,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      interests: interests ?? this.interests,
      likeCount: likeCount ?? this.likeCount,
      publishedAt: publishedAt ?? this.publishedAt,
      viewerHasBookmarked: viewerHasBookmarked ?? this.viewerHasBookmarked,
    );
  }
}

class OtherProfileContentMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const OtherProfileContentMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });
}
