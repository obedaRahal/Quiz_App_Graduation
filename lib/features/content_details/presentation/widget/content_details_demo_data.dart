import 'package:quiz_app_grad/core/theme/assets/images.dart';

class ContentDetailsUiData {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String targetLevel;
  final String contentKind;
  final int assetCount;
  final int likeCount;
  final int bookmarksCount;
  final int downloadCount;
  final String publishedAt;
  final List<ContentAssetUiData> assets;
  final ContentPublisherUiData? publisher;
  final bool viewerHasLiked;
  final bool viewerHasBookmarked;
  final bool viewerIsFollowingCreator;
  final bool isOwner;
  final bool isPublic;

  const ContentDetailsUiData({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.contentKind,
    required this.assetCount,
    required this.likeCount,
    required this.bookmarksCount,
    required this.downloadCount,
    required this.publishedAt,
    required this.assets,
    this.publisher,
    this.viewerHasLiked = false,
    this.viewerHasBookmarked = false,
    this.viewerIsFollowingCreator = false,
    this.isOwner = false,
    this.isPublic = true,
  });

  bool get isFile => contentKind.trim() == 'ملف';
}

class ContentAssetUiData {
  final int id;
  final String url;
  final int position;

  const ContentAssetUiData({
    required this.id,
    required this.url,
    required this.position,
  });
}

class ContentPublisherUiData {
  final int id;
  final String name;
  final String avatarUrl;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final bool isVerified;

  const ContentPublisherUiData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.isVerified,
  });
}

class ContentDetailsDemoData {
  static final imagesContent = ContentDetailsUiData(
    id: 2,
    title: 'وثيقة صيفي حيوي',
    description:
        'تحتوي هذه الصورة على تفسير لانقسام الصبغيات في أجسام الكائنات الحية بطريقة تفصيلية مرتبة ومنظمة.',
    interests: const ['علوم أساسية', 'برمجة', 'أحياء'],
    targetLevel: 'إعدادي',
    contentKind: 'صور مجمعة',
    assetCount: 3,
    likeCount: 125,
    bookmarksCount: 65,
    downloadCount: 12,
    publishedAt: '15 س',
    assets: [
      ContentAssetUiData(id: 1, url: AppImage.carmen, position: 1),
      ContentAssetUiData(id: 2, url: AppImage.carmen, position: 2),
      ContentAssetUiData(id: 3, url: AppImage.carmen, position: 3),
    ],
    publisher: ContentPublisherUiData(
      id: 802,
      name: 'جيني تحسين أسير',
      avatarUrl: AppImage.carmen,
      followersCount: 500,
      followingCount: 2,
      publishedTestsCount: 14,
      isVerified: true,
    ),
  );

  static final fileContent = ContentDetailsUiData(
    id: 402,
    title: 'ملفففففففف',
    description: 'ملف تعليمي منظم مناسب للمراجعة والتطبيق العملي.',
    interests: const ['علوم الحاسوب'],
    targetLevel: 'الصف الأول',
    contentKind: 'ملف',
    assetCount: 1,
    likeCount: 0,
    bookmarksCount: 0,
    downloadCount: 0,
    publishedAt: '',
    assets: [ContentAssetUiData(id: 604, url: AppImage.carmen, position: 1)],
    publisher: null,
  );
}
