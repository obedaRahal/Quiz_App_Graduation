import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_character_ui_model.dart';

abstract class ChallengeCharactersData {
  static  List<ChallengeCharacterUiModel> characters = [
    ChallengeCharacterUiModel(
      id: 1,
      name: 'نواف',
      subtitle: 'خصم متوازن',
      imagePath: AppImage.robot1,
      accuracyPercentage: 70,
      minReactionSeconds: 3,
      maxReactionSeconds: 6,
    ),
    ChallengeCharacterUiModel(
      id: 2,
      name: 'سارة',
      subtitle: 'سريعة لكن تخطئ كثيرًا',
      imagePath: AppImage.robot2,
      accuracyPercentage: 60,
      minReactionSeconds: 2,
      maxReactionSeconds: 4,
    ),
    ChallengeCharacterUiModel(
      id: 3,
      name: 'آدم',
      subtitle: 'ذكي وبطيء قليلًا',
      imagePath: AppImage.robot3,
      accuracyPercentage: 85,
      minReactionSeconds: 4,
      maxReactionSeconds: 7,
    ),
    ChallengeCharacterUiModel(
      id: 4,
      name: 'ليان',
      subtitle: 'هادئة ودقيقة',
      imagePath: AppImage.robot4,
      accuracyPercentage: 78,
      minReactionSeconds: 4,
      maxReactionSeconds: 6,
    ),
    ChallengeCharacterUiModel(
      id: 5,
      name: 'يزن',
      subtitle: 'متسرع ومشاكس',
      imagePath: AppImage.robot5,
      accuracyPercentage: 55,
      minReactionSeconds: 1,
      maxReactionSeconds: 3,
    ),
    ChallengeCharacterUiModel(
      id: 6,
      name: 'مايا',
      subtitle: 'خصم صعب وذكي',
      imagePath: AppImage.robot6,
      accuracyPercentage: 92,
      minReactionSeconds: 2,
      maxReactionSeconds: 4,
    ),
  ];

  static ChallengeCharacterUiModel selectedById(int id) {
    return characters.firstWhere(
      (character) => character.id == id,
      orElse: () => characters.first,
    );
  }
}