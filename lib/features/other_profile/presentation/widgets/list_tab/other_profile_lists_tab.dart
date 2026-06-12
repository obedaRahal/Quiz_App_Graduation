import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/list_tab/other_profile_folder_card.dart';

class OtherProfileListsTab extends StatelessWidget {
  const OtherProfileListsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) => previous.folders != current.folders,
      builder: (context, state) {
        final folders = state.folders;

        if (folders.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
              child: CustomTextWidget(
                'لا توجد قوائم لعرضها',
                color: AppPalette.greyMedium,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }

        return Column(
          children: folders.map((folder) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                  child: OtherProfileFolderCard(
                    folder: folder,
                    onSaveTap: () {
                      context.read<OtherProfileCubit>().toggleFolderSaveLocally(
                        folderId: folder.id,
                      );
                    },
                  ),
                ),
                CustomDivider(height: 8, thickness: 2),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
