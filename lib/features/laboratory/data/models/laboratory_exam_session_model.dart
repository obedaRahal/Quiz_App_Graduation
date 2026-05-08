class LaboratoryExamSessionModel {
  final String title;
  final String description;
  final String difficulty;
  final int questionCount;
  final double rating;
  final num price;
  final List<String> tags;

  const LaboratoryExamSessionModel({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questionCount,
    required this.rating,
    required this.price,
    required this.tags,
  });
}

const List<LaboratoryExamSessionModel> dummyExamSessions = [
  LaboratoryExamSessionModel(
    title: 'جلسة امتحانية أولى',
    description: 'مجموعة أسئلة امتحانية تساعدك على تقييم مستواك قبل الدخول إلى الاختبار النهائي.',
    difficulty: 'صعب',
    questionCount: 89,
    rating: 5.0,
    price: 180,
    tags: ['خوارزميات', 'برمجة'],
  ),
  LaboratoryExamSessionModel(
    title: 'جلسة امتحانية ثانية',
    description: 'جلسة تدريبية مركزة تحتوي على أسئلة متنوعة ومناسبة للمراجعة السريعة.',
    difficulty: 'متوسط',
    questionCount: 22,
    rating: 4.5,
    price: 240,
    tags: ['منطق', 'رياضيات'],
  ),
  LaboratoryExamSessionModel(
    title: 'جلسة امتحانية ثالثة',
    description: 'أسئلة قصيرة ومباشرة لاختبار الفهم الأساسي للمادة قبل الامتحان.',
    difficulty: 'سهل',
    questionCount: 45,
    rating: 4.2,
    price: 0,
    tags: ['فيزياء'],
  ),
];