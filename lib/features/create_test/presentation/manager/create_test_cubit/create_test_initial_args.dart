// // import 'package:file_picker/file_picker.dart';

// // enum CreateTestCreationMode {
// //   manual,
// //   aiImages,
// //   aiFile,
// // }

// // class CreateTestInitialArgs {
// //   final CreateTestCreationMode mode;
// //   final List<PlatformFile> mediaFiles;

// //   final int? aiQuestionCount;
// //   final String? aiLevel;
// //   final String? aiLanguage;

// //   const CreateTestInitialArgs({
// //     this.mode = CreateTestCreationMode.manual,
// //     this.mediaFiles = const [],
// //     this.aiQuestionCount,
// //     this.aiLevel,
// //     this.aiLanguage,
// //   });

// //   bool get isAiMode {
// //     return mode == CreateTestCreationMode.aiImages ||
// //         mode == CreateTestCreationMode.aiFile;
// //   }

// //   bool get isAiImages => mode == CreateTestCreationMode.aiImages;

// //   bool get isAiFile => mode == CreateTestCreationMode.aiFile;
// // }
// import 'package:file_picker/file_picker.dart';
// import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';

// enum CreateTestCreationMode {
//   manual,
//   aiImages,
//   aiFile,
// }

// class CreateTestInitialArgs {
//   final CreateTestCreationMode mode;
//   final List<PlatformFile> mediaFiles;

//   final int? aiQuestionCount;
//   final String? aiLevel;
//   final String? aiLanguage;

//   final List<GeneratedAiQuestionEntity> generatedQuestions;

//   const CreateTestInitialArgs({
//     this.mode = CreateTestCreationMode.manual,
//     this.mediaFiles = const [],
//     this.aiQuestionCount,
//     this.aiLevel,
//     this.aiLanguage,
//     this.generatedQuestions = const [],
//   });

//   bool get isAiMode {
//     return mode == CreateTestCreationMode.aiImages ||
//         mode == CreateTestCreationMode.aiFile;
//   }

//   bool get isAiImages => mode == CreateTestCreationMode.aiImages;

//   bool get isAiFile => mode == CreateTestCreationMode.aiFile;

//   CreateTestInitialArgs copyWith({
//     CreateTestCreationMode? mode,
//     List<PlatformFile>? mediaFiles,
//     int? aiQuestionCount,
//     String? aiLevel,
//     String? aiLanguage,
//     List<GeneratedAiQuestionEntity>? generatedQuestions,
//   }) {
//     return CreateTestInitialArgs(
//       mode: mode ?? this.mode,
//       mediaFiles: mediaFiles ?? this.mediaFiles,
//       aiQuestionCount: aiQuestionCount ?? this.aiQuestionCount,
//       aiLevel: aiLevel ?? this.aiLevel,
//       aiLanguage: aiLanguage ?? this.aiLanguage,
//       generatedQuestions: generatedQuestions ?? this.generatedQuestions,
//     );
//   }
// }
import 'package:file_picker/file_picker.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';

enum CreateTestCreationMode {
  manual,
  aiImages,
  aiFile,
}

class CreateTestInitialArgs {
  final CreateTestCreationMode mode;
  final List<PlatformFile> mediaFiles;

  final int? aiQuestionCount;
  final String? aiLevel;
  final String? aiLanguage;

  final List<GeneratedAiQuestionEntity> generatedQuestions;

  const CreateTestInitialArgs({
    this.mode = CreateTestCreationMode.manual,
    this.mediaFiles = const [],
    this.aiQuestionCount,
    this.aiLevel,
    this.aiLanguage,
    this.generatedQuestions = const [],
  });

  bool get isAiMode {
    return mode == CreateTestCreationMode.aiImages ||
        mode == CreateTestCreationMode.aiFile;
  }

  bool get isAiImages => mode == CreateTestCreationMode.aiImages;

  bool get isAiFile => mode == CreateTestCreationMode.aiFile;

  CreateTestInitialArgs copyWith({
    CreateTestCreationMode? mode,
    List<PlatformFile>? mediaFiles,
    int? aiQuestionCount,
    String? aiLevel,
    String? aiLanguage,
    List<GeneratedAiQuestionEntity>? generatedQuestions,
  }) {
    return CreateTestInitialArgs(
      mode: mode ?? this.mode,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      aiQuestionCount: aiQuestionCount ?? this.aiQuestionCount,
      aiLevel: aiLevel ?? this.aiLevel,
      aiLanguage: aiLanguage ?? this.aiLanguage,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
    );
  }
}