import 'current_university_helpers.dart';
import 'current_university_models.dart';

final List<UniversityOption> currentUniversityOptions = [
  // =========================
  // جامعات عامة
  // =========================
  UniversityOption(
    title: 'جامعة دمشق',
    isPrivate: false,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption('الهندسة المعلوماتية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption('الهندسة المعمارية'),
      buildDepartmentOption('الهندسة الكهربائية والميكانيكية'),
      buildDepartmentOption('الهندسة الزراعية'),
      buildDepartmentOption('العلوم'),
      buildDepartmentOption('الآداب والعلوم الإنسانية'),
      buildDepartmentOption('الاقتصاد'),
      buildDepartmentOption('الحقوق'),
      buildDepartmentOption('الإعلام'),
      buildDepartmentOption('التربية'),
      buildDepartmentOption('الشريعة'),
      buildDepartmentOption('الفنون الجميلة'),
      buildDepartmentOption('العلوم السياسية'),
      buildDepartmentOption('السياحة'),
    ],
  ),

  UniversityOption(
    title: 'جامعة حلب',
    isPrivate: false,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption('الهندسة المعلوماتية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption('الهندسة المعمارية'),
      buildDepartmentOption('الهندسة الكهربائية والإلكترونية'),
      buildDepartmentOption('الهندسة الميكانيكية'),
      buildDepartmentOption('الزراعة'),
      buildDepartmentOption('العلوم'),
      buildDepartmentOption('الاقتصاد'),
      buildDepartmentOption('الحقوق'),
      buildDepartmentOption('الآداب'),
      buildDepartmentOption('التربية'),
      buildDepartmentOption('الفنون الجميلة'),
    ],
  ),

  UniversityOption(
    title: 'جامعة اللاذقية',
    isPrivate: false,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption('الهندسة المعلوماتية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption('الهندسة المعمارية'),
      buildDepartmentOption('الهندسة الميكانيكية والكهربائية'),
      buildDepartmentOption('الزراعة'),
      buildDepartmentOption('العلوم'),
      buildDepartmentOption('الاقتصاد'),
      buildDepartmentOption('الآداب والعلوم الإنسانية'),
      buildDepartmentOption('التربية'),
      buildDepartmentOption('الحقوق'),
      buildDepartmentOption('التمريض'),
      buildDepartmentOption('الفنون الجميلة'),
      buildDepartmentOption('التربية الرياضية'),
      buildDepartmentOption('الهندسة المساحية والجيوماتية'),
    ],
  ),

  UniversityOption(
    title: 'جامعة حمص',
    isPrivate: false,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption('الهندسة المعلوماتية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption('الهندسة المعمارية'),
      buildDepartmentOption('الهندسة الكيميائية'),
      buildDepartmentOption('الهندسة البترولية'),
      buildDepartmentOption('العلوم'),
      buildDepartmentOption('الاقتصاد'),
      buildDepartmentOption('الزراعة'),
      buildDepartmentOption('التربية'),
    ],
  ),

  UniversityOption(
    title: 'جامعة الفرات',
    isPrivate: false,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption('الزراعة'),
      buildDepartmentOption('الاقتصاد'),
      buildDepartmentOption('التربية'),
      buildDepartmentOption( 'الآداب'),
      buildDepartmentOption( 'العلوم'),
    ],
  ),

  UniversityOption(
    title: 'جامعة حماة',
    isPrivate: false,
    departments: [
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'الطب البيطري'),
      buildDepartmentOption( 'الاقتصاد'),
      buildDepartmentOption('التربية'),
      buildDepartmentOption('العلوم'),
    ],
  ),

  UniversityOption(
    title: 'جامعة طرطوس',
    isPrivate: false,
    departments: [
      buildDepartmentOption( 'الهندسة التقنية'),
      buildDepartmentOption( 'الاقتصاد'),
      buildDepartmentOption('العلوم'),
      buildDepartmentOption('الآداب'),
      buildDepartmentOption( 'التربية'),
    ],
  ),

  UniversityOption(
    title: 'جامعة إدلب',
    isPrivate: false,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption( 'الاقتصاد'),
      buildDepartmentOption( 'التربية'),
    ],
  ),

  UniversityOption(
    title: 'الجامعة الافتراضية السورية',
    isPrivate: false,
    departments: [
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'إدارة الأعمال'),
      buildDepartmentOption( 'الحقوق'),
      buildDepartmentOption( 'الإعلام الرقمي'),
      buildDepartmentOption( 'تقانة المعلومات'),
    ],
  ),

  // =========================
  // جامعات خاصة
  // =========================
  UniversityOption(
    title: 'جامعة القلمون',
    isPrivate: true,
    departments: [
      buildDepartmentOption('طب بشري'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'الهندسة المدنية'),
      buildDepartmentOption( 'إدارة الأعمال'),
      buildDepartmentOption('الفنون التطبيقية'),
    ],
  ),

  UniversityOption(
    title: 'الجامعة العربية الدولية',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption(
        'الهندسة المعلوماتية والاتصالات',
      ),
      buildDepartmentOption( 'الهندسة المعمارية'),
      buildDepartmentOption('الهندسة المدنية'),
      buildDepartmentOption( 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    title: 'الجامعة السورية الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'الهندسة البترولية'),
      buildDepartmentOption( 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    title: 'الجامعة الدولية للعلوم والتكنولوجيا',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'الهندسة المعمارية'),
      buildDepartmentOption('إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    title: 'جامعة الأندلس الخاصة للعلوم الطبية',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption('الصيدلة'),
      buildDepartmentOption( 'الهندسة الطبية'),
      buildDepartmentOption( 'التمريض'),
      buildDepartmentOption( 'إدارة المشافي'),
    ],
  ),

  UniversityOption(
    title: 'جامعة اليرموك الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption(
        'هندسة المعلومات والاتصالات',
      ),
      buildDepartmentOption( 'الهندسة المدنية'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'إدارة الأعمال'),
      buildDepartmentOption('الفنون الجميلة'),
    ],
  ),

  UniversityOption(
    title: 'الجامعة الوطنية الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption(
        'هندسة العمارة والتخطيط العمراني',
      ),
      buildDepartmentOption(
        'هندسة المعلوماتية والاتصالات',
      ),
      buildDepartmentOption( 'الهندسة المدنية'),
      buildDepartmentOption(
        'العلوم الإدارية والمالية',
      ),
    ],
  ),

  UniversityOption(
    title: 'جامعة الوادي الدولية',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    title: 'جامعة الحواش الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption('التمريض'),
      buildDepartmentOption( 'العلاج الفيزيائي'),
    ],
  ),

  UniversityOption(
    title: 'جامعة الجزيرة الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption( 'إدارة الأعمال'),
      buildDepartmentOption( 'الحقوق'),
    ],
  ),

  UniversityOption(
    title: 'جامعة إيبلا الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'الهندسة'),
      buildDepartmentOption( 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    title: 'جامعة الشام الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'طب بشري'),
      buildDepartmentOption( 'الهندسة المعلوماتية'),
      buildDepartmentOption('طب الأسنان'),
      buildDepartmentOption( 'الصيدلة'),
    ],
  ),

  UniversityOption(
    title: 'جامعة قرطبة الخاصة',
    isPrivate: true,
    departments: [
      buildDepartmentOption( 'الهندسة'),
      buildDepartmentOption( 'الصيدلة'),
      buildDepartmentOption( 'إدارة الأعمال'),
    ],
  ),
];
