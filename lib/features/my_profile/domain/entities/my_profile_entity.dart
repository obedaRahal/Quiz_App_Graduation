class MyProfileEntity {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String governorate;
  final String gender;
  final String birthDate;
  final String avatarUrl;
  final String coverUrl;
  final bool isAcademicallyVerified;

  final String testsCount;
  final String followersCount;
  final String followingCount;

  final MyProfileAcademicInformationEntity academicInformation;
  final List<MyProfileScientificInterestEntity> scientificInterests;

  const MyProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.governorate,
    required this.gender,
    required this.birthDate,
    required this.avatarUrl,
    required this.coverUrl,
    required this.isAcademicallyVerified,
    required this.testsCount,
    required this.followersCount,
    required this.followingCount,
    required this.academicInformation,
    required this.scientificInterests,
  });

  List<int> get scientificInterestIds {
    return scientificInterests.map((item) => item.id).toList();
  }

  List<String> get scientificInterestNames {
    return scientificInterests.map((item) => item.name).toList();
  }

  MyProfileEntity copyWith({
    int? userId,
    String? name,
    String? email,
    String? phone,
    String? governorate,
    String? gender,
    String? birthDate,
    String? avatarUrl,
    String? coverUrl,
    bool? isAcademicallyVerified,
    String? testsCount,
    String? followersCount,
    String? followingCount,
    MyProfileAcademicInformationEntity? academicInformation,
    List<MyProfileScientificInterestEntity>? scientificInterests
  }) {
    return MyProfileEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      isAcademicallyVerified:
          isAcademicallyVerified ?? this.isAcademicallyVerified,
      testsCount: testsCount ?? this.testsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      academicInformation: academicInformation ?? this.academicInformation,
      scientificInterests: scientificInterests ?? this.scientificInterests,
    );
  }
}

class MyProfileAcademicInformationEntity {
  final String educationLevel;
  final String universityName;
  final String department;
  final String? universityYear;
  final String? schoolStage;

  const MyProfileAcademicInformationEntity({
    required this.educationLevel,
    required this.universityName,
    required this.department,
    this.universityYear,
    this.schoolStage,
  });

  List<String> get displayItems {
    return [
      educationLevel,
      universityName,
      department,
      universityYear,
      schoolStage,
    ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();
  }
}

class MyProfileScientificInterestEntity {
  final int id;
  final String name;

  const MyProfileScientificInterestEntity({
    required this.id,
    required this.name,
  });
}
