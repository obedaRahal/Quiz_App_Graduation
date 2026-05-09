import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

extension LabRecommendedTestItemMapper on LabRecommendedTestItemEntity {
  TestByInterestEntity toExamSessionEntity() {
    return TestByInterestEntity(
      id: test.id,
      title: test.title,
      description: test.description,
      interests: test.interestNames
          .map(
            (name) => TestInterestEntity(
              id: 0,
              name: name,
            ),
          )
          .toList(),
      questionCount: test.questionCount,
      difficultyLevel: test.difficultyLevel,
      price: test.price,
      averageRating: test.averageRating,
      publishedAgo: test.publishedAtHuman,
    );
  }
}