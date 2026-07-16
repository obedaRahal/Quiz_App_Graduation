import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';

OtherProfileTestItemEntity mapMyFolderContentTestToOtherProfileTest(
  MyProfileFolderContentTestEntity test,
) {
  return OtherProfileTestItemEntity(
    id: test.id,
    title: test.title,
    description: test.description,
    interests: test.interests,
    difficultyLevel: test.difficultyLevel,
    averageRating: test.averageRating,
    price: test.price.toString(),
    publishedAt: test.publishedAt,
    questionCount: test.questionCount, 
    targetLevel: '',
  );
}