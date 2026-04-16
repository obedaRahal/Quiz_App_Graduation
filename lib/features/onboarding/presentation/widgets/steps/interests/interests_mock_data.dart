import 'interests_models.dart';

final List<InterestGroupOption> mockInterestGroups = [
  InterestGroupOption(
    id: 1,
    title: 'اهتمامات علمية أساسية',
    items: const [
      InterestOption(id: 101, name: 'العلوم الأساسية'),
      InterestOption(id: 102, name: 'الرياضيات'),
      InterestOption(id: 103, name: 'الفيزياء'),
      InterestOption(id: 104, name: 'الكيمياء'),
      InterestOption(id: 105, name: 'الأحياء'),
    ],
  ),
  InterestGroupOption(
    id: 2,
    title: 'التكنولوجيا والحاسوب',
    items: const [
      InterestOption(id: 201, name: 'علوم الحاسوب'),
      InterestOption(id: 202, name: 'البرمجة'),
      InterestOption(id: 203, name: 'الذكاء الاصطناعي'),
      InterestOption(id: 204, name: 'أمن المعلومات'),
      InterestOption(id: 205, name: 'تطوير التطبيقات'),
    ],
  ),
  InterestGroupOption(
    id: 3,
    title: 'الهندسات',
    items: const [
      InterestOption(id: 301, name: 'الهندسة المدنية'),
      InterestOption(id: 302, name: 'الهندسة المعمارية'),
      InterestOption(id: 303, name: 'الهندسة الكهربائية'),
      InterestOption(id: 304, name: 'الهندسة الميكانيكية'),
      InterestOption(id: 305, name: 'الهندسة المعلوماتية'),
    ],
  ),
  InterestGroupOption(
    id: 4,
    title: 'العلوم الطبية',
    items: const [
      InterestOption(id: 401, name: 'الطب البشري'),
      InterestOption(id: 402, name: 'طب الأسنان'),
      InterestOption(id: 403, name: 'الصيدلة'),
      InterestOption(id: 404, name: 'التمريض'),
      InterestOption(id: 405, name: 'العلاج الفيزيائي'),
    ],
  ),
  InterestGroupOption(
    id: 5,
    title: 'العلوم الإنسانية والإدارية',
    items: const [
      InterestOption(id: 501, name: 'الاقتصاد'),
      InterestOption(id: 502, name: 'إدارة الأعمال'),
      InterestOption(id: 503, name: 'الحقوق'),
      InterestOption(id: 504, name: 'الإعلام'),
      InterestOption(id: 505, name: 'العلوم السياسية'),
    ],
  ),
];
