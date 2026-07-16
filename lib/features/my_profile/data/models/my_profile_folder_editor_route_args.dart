import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';

class MyProfileFolderEditorRouteArgs {
  final MyProfileFolderEditorMode mode;
  final MyProfileFolderItemEntity? folder;
  final int userId;

  const MyProfileFolderEditorRouteArgs({
    required this.mode,
    this.folder,
    required this.userId,
  });

  const MyProfileFolderEditorRouteArgs.create({required this.userId})
    : mode = MyProfileFolderEditorMode.create,
      folder = null;

  const MyProfileFolderEditorRouteArgs.edit({
    required MyProfileFolderItemEntity this.folder,
    required this.userId,
  }) : mode = MyProfileFolderEditorMode.edit;
}
