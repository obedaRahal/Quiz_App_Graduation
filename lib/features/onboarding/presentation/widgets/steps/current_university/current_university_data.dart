import 'current_university_helpers.dart';
import 'current_university_models.dart';

final List<UniversityOption> currentUniversityOptions = [
  // =========================
  // جامعات عامة
  // =========================
  UniversityOption(
    id: 'damascus_university',
    name: 'جامعة دمشق',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption(
        'eem_engineering',
        'الهندسة الكهربائية والميكانيكية',
      ),
      buildDepartmentOption('agricultural_engineering', 'الهندسة الزراعية'),
      buildDepartmentOption('science', 'العلوم'),
      buildDepartmentOption('arts_humanities', 'الآداب والعلوم الإنسانية'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('law', 'الحقوق'),
      buildDepartmentOption('media', 'الإعلام'),
      buildDepartmentOption('education', 'التربية'),
      buildDepartmentOption('sharia', 'الشريعة'),
      buildDepartmentOption('fine_arts', 'الفنون الجميلة'),
      buildDepartmentOption('political_science', 'العلوم السياسية'),
      buildDepartmentOption('tourism', 'السياحة'),
    ],
  ),

  UniversityOption(
    id: 'aleppo_university',
    name: 'جامعة حلب',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption(
        'electrical_electronics_engineering',
        'الهندسة الكهربائية والإلكترونية',
      ),
      buildDepartmentOption('mechanical_engineering', 'الهندسة الميكانيكية'),
      buildDepartmentOption('agriculture', 'الزراعة'),
      buildDepartmentOption('science', 'العلوم'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('law', 'الحقوق'),
      buildDepartmentOption('arts', 'الآداب'),
      buildDepartmentOption('education', 'التربية'),
      buildDepartmentOption('fine_arts', 'الفنون الجميلة'),
    ],
  ),

  UniversityOption(
    id: 'latakia_university',
    name: 'جامعة اللاذقية',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption(
        'mechanical_electrical_engineering',
        'الهندسة الميكانيكية والكهربائية',
      ),
      buildDepartmentOption('agriculture', 'الزراعة'),
      buildDepartmentOption('science', 'العلوم'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('arts_humanities', 'الآداب والعلوم الإنسانية'),
      buildDepartmentOption('education', 'التربية'),
      buildDepartmentOption('law', 'الحقوق'),
      buildDepartmentOption('nursing', 'التمريض'),
      buildDepartmentOption('fine_arts', 'الفنون الجميلة'),
      buildDepartmentOption('physical_education', 'التربية الرياضية'),
      buildDepartmentOption(
        'geomatics_engineering',
        'الهندسة المساحية والجيوماتية',
      ),
    ],
  ),

  UniversityOption(
    id: 'homs_university',
    name: 'جامعة حمص',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption('chemical_engineering', 'الهندسة الكيميائية'),
      buildDepartmentOption('petroleum_engineering', 'الهندسة البترولية'),
      buildDepartmentOption('science', 'العلوم'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('agriculture', 'الزراعة'),
      buildDepartmentOption('education', 'التربية'),
    ],
  ),

  UniversityOption(
    id: 'euphrates_university',
    name: 'جامعة الفرات',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('agriculture', 'الزراعة'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('education', 'التربية'),
      buildDepartmentOption('arts', 'الآداب'),
      buildDepartmentOption('science', 'العلوم'),
    ],
  ),

  UniversityOption(
    id: 'hama_university',
    name: 'جامعة حماة',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('veterinary_medicine', 'الطب البيطري'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('education', 'التربية'),
      buildDepartmentOption('science', 'العلوم'),
    ],
  ),

  UniversityOption(
    id: 'tartous_university',
    name: 'جامعة طرطوس',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('technical_engineering', 'الهندسة التقنية'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('science', 'العلوم'),
      buildDepartmentOption('arts', 'الآداب'),
      buildDepartmentOption('education', 'التربية'),
    ],
  ),

  UniversityOption(
    id: 'idlib_university',
    name: 'جامعة إدلب',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('economics', 'الاقتصاد'),
      buildDepartmentOption('education', 'التربية'),
    ],
  ),

  UniversityOption(
    id: 'syrian_virtual_university',
    name: 'الجامعة الافتراضية السورية',
    logoPath: null,
    isPrivate: false,
    departments: [
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
      buildDepartmentOption('law', 'الحقوق'),
      buildDepartmentOption('digital_media', 'الإعلام الرقمي'),
      buildDepartmentOption('information_technology', 'تقانة المعلومات'),
    ],
  ),

  // =========================
  // جامعات خاصة
  // =========================
  UniversityOption(
    id: 'uok',
    name: 'جامعة القلمون',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
      buildDepartmentOption('applied_arts', 'الفنون التطبيقية'),
    ],
  ),

  UniversityOption(
    id: 'aiu',
    name: 'الجامعة العربية الدولية',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption(
        'informatics_communications_engineering',
        'الهندسة المعلوماتية والاتصالات',
      ),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    id: 'spu',
    name: 'الجامعة السورية الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('petroleum_engineering', 'الهندسة البترولية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    id: 'iust',
    name: 'الجامعة الدولية للعلوم والتكنولوجيا',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('architecture_engineering', 'الهندسة المعمارية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    id: 'andalus',
    name: 'جامعة الأندلس الخاصة للعلوم الطبية',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('medical_engineering', 'الهندسة الطبية'),
      buildDepartmentOption('nursing', 'التمريض'),
      buildDepartmentOption('hospital_management', 'إدارة المشافي'),
    ],
  ),

  UniversityOption(
    id: 'yarmouk_private',
    name: 'جامعة اليرموك الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption(
        'information_communications_engineering',
        'هندسة المعلومات والاتصالات',
      ),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
      buildDepartmentOption('fine_arts', 'الفنون الجميلة'),
    ],
  ),

  UniversityOption(
    id: 'wpu',
    name: 'الجامعة الوطنية الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption(
        'architecture_engineering',
        'هندسة العمارة والتخطيط العمراني',
      ),
      buildDepartmentOption(
        'informatics_communications_engineering',
        'هندسة المعلوماتية والاتصالات',
      ),
      buildDepartmentOption('civil_engineering', 'الهندسة المدنية'),
      buildDepartmentOption(
        'financial_administrative_sciences',
        'العلوم الإدارية والمالية',
      ),
    ],
  ),

  UniversityOption(
    id: 'wadi',
    name: 'جامعة الوادي الدولية',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    id: 'hawash',
    name: 'جامعة الحواش الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('nursing', 'التمريض'),
      buildDepartmentOption('physical_therapy', 'العلاج الفيزيائي'),
    ],
  ),

  UniversityOption(
    id: 'jazira_private',
    name: 'جامعة الجزيرة الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
      buildDepartmentOption('law', 'الحقوق'),
    ],
  ),

  UniversityOption(
    id: 'ebla_private',
    name: 'جامعة إيبلا الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('engineering', 'الهندسة'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),

  UniversityOption(
    id: 'aspu',
    name: 'جامعة الشام الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('medicine', 'طب بشري'),
      buildDepartmentOption('informatics_engineering', 'الهندسة المعلوماتية'),
      buildDepartmentOption('dentistry', 'طب الأسنان'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
    ],
  ),

  UniversityOption(
    id: 'qurtuba_private',
    name: 'جامعة قرطبة الخاصة',
    logoPath: null,
    isPrivate: true,
    departments: [
      buildDepartmentOption('engineering', 'الهندسة'),
      buildDepartmentOption('pharmacy', 'الصيدلة'),
      buildDepartmentOption('business_administration', 'إدارة الأعمال'),
    ],
  ),
];
