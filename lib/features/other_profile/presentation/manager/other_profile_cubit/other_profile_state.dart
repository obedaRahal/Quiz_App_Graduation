import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

enum OtherProfileTab { overview, tests, lists, content }

enum OtherProfileTestsFilter { paid, free, latest, mostTaken }

enum OtherProfileContentFilter { latest, popular, files, images }

enum OtherProfileContentType { image, file }

class OtherProfileContentUiModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final OtherProfileContentType type;
  final List<String> tags;
  final int likesCount;
  final String publishedAt;
  final bool isSaved;
  final bool isLiked;

  const OtherProfileContentUiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.tags,
    required this.likesCount,
    required this.publishedAt,
    required this.isSaved,
    required this.isLiked,
  });

  OtherProfileContentUiModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    OtherProfileContentType? type,
    List<String>? tags,
    int? likesCount,
    String? publishedAt,
    bool? isSaved,
    bool? isLiked,
  }) {
    return OtherProfileContentUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      publishedAt: publishedAt ?? this.publishedAt,
      isSaved: isSaved ?? this.isSaved,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class OtherProfileMockData {
  static const profile = OtherProfileUiModel(
    userId: 15,
    name: 'جنى تحسين أمير',
    avatarUrl: '',
    coverUrl: '',
    isAcademicallyVerified: true,
    testsCount: 500,
    followingCount: 20,
    followersCount: 14,
    isFollowing: false,
    bio:
        'طالبة مهتمة بالتعلم وتنظيم الاختبارات ومشاركة المحتوى التعليمي بطريقة بسيطة.',
  );

  static const folders = [
    OtherProfileFolderUiModel(
      id: 1,
      title: 'جلسة امتحانية أولى',
      testsCount: 8,
      createdAt: 'منذ خمس دقائق',
      tags: ['علوم أساسية', 'برمجة', 'ذكاء اصطناعي'],
      isSaved: false,
      color: AppPalette.circleContainer1,
    ),
    OtherProfileFolderUiModel(
      id: 2,
      title: 'قائمة مراجعة الخوارزميات',
      testsCount: 12,
      createdAt: 'منذ يومين',
      tags: ['خوارزميات', 'هياكل بيانات', 'جامعة'],
      isSaved: true,
      color: AppPalette.circleContainer2,
    ),
    OtherProfileFolderUiModel(
      id: 3,
      title: 'اختبارات رياضيات متقدمة',
      testsCount: 5,
      createdAt: 'منذ أسبوع',
      tags: ['رياضيات', 'تحليل', 'جبر خطي'],
      isSaved: false,
      color: AppPalette.circleContainer3,
    ),
  ];

  static const contents = [
    OtherProfileContentUiModel(
      id: 1,
      title: 'وثيقة صيفي حيوي',
      description: 'تحتوي هذه الصورة على طريقة تذكر الصبغات في أجسام الحيوانات',
      imageUrl: '',
      type: OtherProfileContentType.image,
      tags: ['علوم أساسية'],
      likesCount: 234,
      publishedAt: '15 س',
      isSaved: false,
      isLiked: false
    ),
    OtherProfileContentUiModel(
      id: 2,
      title: 'هرمية الذواكر',
      description: 'تحتوي هذه الصورة على طريقة تذكر الصبغات في أجسام الحيوانات',
      imageUrl: '',
      type: OtherProfileContentType.file,
      tags: ['علوم أساسية', 'ghgh ghghgh', 'sdsd ddsd sd', 'fdfdf f'],
      likesCount: 12,
      publishedAt: 'منذ يومان',
      isSaved: false,
      isLiked:  true
    ),
  ];
}

class OtherProfileUiModel {
  final int userId;
  final String name;
  final String avatarUrl;
  final String coverUrl;
  final bool isAcademicallyVerified;
  final int testsCount;
  final int followingCount;
  final int followersCount;
  final bool isFollowing;
  final String bio;

  const OtherProfileUiModel({
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.coverUrl,
    required this.isAcademicallyVerified,
    required this.testsCount,
    required this.followingCount,
    required this.followersCount,
    required this.isFollowing,
    required this.bio,
  });

  OtherProfileUiModel copyWith({
    int? userId,
    String? name,
    String? avatarUrl,
    String? coverUrl,
    bool? isAcademicallyVerified,
    int? testsCount,
    int? listsCount,
    int? followersCount,
    bool? isFollowing,
    String? bio,
  }) {
    return OtherProfileUiModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      testsCount: testsCount ?? this.testsCount,
      followingCount: listsCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
      bio: bio ?? this.bio,
    );
  }
}

class OtherProfileFolderUiModel {
  final int id;
  final String title;
  final int testsCount;
  final String createdAt;
  final List<String> tags;
  final bool isSaved;
  final Color color;

  const OtherProfileFolderUiModel({
    required this.id,
    required this.title,
    required this.testsCount,
    required this.createdAt,
    required this.tags,
    required this.isSaved,
    required this.color,
  });

  OtherProfileFolderUiModel copyWith({
    int? id,
    String? title,
    int? testsCount,
    String? createdAt,
    List<String>? tags,
    bool? isSaved,
    Color? color,
  }) {
    return OtherProfileFolderUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      testsCount: testsCount ?? this.testsCount,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      isSaved: isSaved ?? this.isSaved,
      color: color ?? this.color,
    );
  }
}

class OtherProfileState {
  final OtherProfileTab selectedTab;
  final OtherProfileUiModel? profile;

  final OtherProfileTestsFilter selectedTestsFilter;

  final List<OtherProfileFolderUiModel> folders;

  final OtherProfileContentFilter selectedContentFilter;

  final List<OtherProfileContentUiModel> contents;
  const OtherProfileState({
    this.selectedTab = OtherProfileTab.overview,
    this.profile,

    this.selectedTestsFilter = OtherProfileTestsFilter.paid,

    this.folders = const [],

    this.selectedContentFilter = OtherProfileContentFilter.latest,

    this.contents = const [],
  });

  OtherProfileState copyWith({
    OtherProfileTab? selectedTab,
    OtherProfileUiModel? profile,

    OtherProfileTestsFilter? selectedTestsFilter,

    List<OtherProfileFolderUiModel>? folders,

    OtherProfileContentFilter? selectedContentFilter,

    List<OtherProfileContentUiModel>? contents,
  }) {
    return OtherProfileState(
      selectedTab: selectedTab ?? this.selectedTab,
      profile: profile ?? this.profile,

      selectedTestsFilter: selectedTestsFilter ?? this.selectedTestsFilter,

      folders: folders ?? this.folders,

      selectedContentFilter:
          selectedContentFilter ?? this.selectedContentFilter,

      contents: contents ?? this.contents,
    );
  }
}
