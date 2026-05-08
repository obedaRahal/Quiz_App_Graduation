class LaboratoryTestModel {
  final String ownerName;
  final String ownerImage;
  final int publishedTestsCount;
  final int followersCount;
  final bool isVerified;

  final String title;
  final String description;
  final List<String> tags;
  final String difficultyLevel;
  final int questionCount;
  final double rating;
  final num price;

  const LaboratoryTestModel({
    required this.ownerName,
    required this.ownerImage,
    required this.publishedTestsCount,
    required this.followersCount,
    required this.isVerified,
    required this.title,
    required this.description,
    required this.tags,
    required this.difficultyLevel,
    required this.questionCount,
    required this.rating,
    required this.price,
  });
}

const List<LaboratoryTestModel> dummyLaboratoryTests = [
  LaboratoryTestModel(
    ownerName: 'محمد منصور',
    ownerImage: '',
    publishedTestsCount: 25,
    followersCount: 155,
    isVerified: true,
    title: 'جلسة امتحانية',
    description: 'هذه الأسئلة تساعد على التقدم للامتحان بثقة وذلك في مادة خوارزميات البحث.',
    tags: ['البرمجة', 'خوارزميات'],
    difficultyLevel: 'متوسط',
    questionCount: 45,
    rating: 4.5,
    price: 180,
  ),
  LaboratoryTestModel(
    ownerName: 'عبيدة الرفاعي',
    ownerImage: '',
    publishedTestsCount: 12,
    followersCount: 89,
    isVerified: false,
    title: 'جلسة امتحانية أولى',
    description: 'اختبار تدريبي شامل يساعدك على مراجعة المفاهيم الأساسية قبل الامتحان.',
    tags: ['رياضيات', 'منطق'],
    difficultyLevel: 'صعب',
    questionCount: 22,
    rating: 5.0,
    price: 240,
  ),
  LaboratoryTestModel(
    ownerName: 'كارمن الشوفي',
    ownerImage: '',
    publishedTestsCount: 7,
    followersCount: 60,
    isVerified: true,
    title: 'اختبار مراجعة سريع',
    description: 'مجموعة أسئلة قصيرة لقياس فهمك قبل الدخول إلى الجلسة الامتحانية.',
    tags: ['فيزياء'],
    difficultyLevel: 'سهل',
    questionCount: 18,
    rating: 4.2,
    price: 0,
  ),
];