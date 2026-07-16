import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/mappers/my_profile_folder_content_mapper.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';

void showMyProfileFolderContentBottomSheet({
  required BuildContext context,
  required MyProfileFolderItemEntity folder,
}) {
  final cubit = context.read<MyProfileCubit>();

  cubit.fetchMyProfileFolderContent(folderId: folder.id);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: MyProfileFolderContentBottomSheet(folder: folder),
      );
    },
  );
}

class MyProfileFolderContentBottomSheet extends StatelessWidget {
  final MyProfileFolderItemEntity folder;

  const MyProfileFolderContentBottomSheet({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return CustomBackgroundWithChild(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BlocBuilder<MyProfileCubit, MyProfileState>(
            buildWhen: (previous, current) =>
                previous.folderContentStatus != current.folderContentStatus ||
                previous.folderContentResponse !=
                    current.folderContentResponse ||
                previous.activeFolderContentId !=
                    current.activeFolderContentId ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.012)),

                  Container(
                    width: SizeConfig.w(0.12),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppPalette.greyLightDark
                          : AppPalette.greyLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.014)),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.045),
                    ),
                    child: CustomTextWidget(
                      folder.name,
                      textAlign: TextAlign.center,
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.045),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.01)),

                  const CustomDivider(height: 10, thickness: 2, isDashed: true),

                  Expanded(
                    child: _FolderContentBody(
                      folder: folder,
                      scrollController: scrollController,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _FolderContentBody extends StatelessWidget {
  final MyProfileFolderItemEntity folder;
  final ScrollController scrollController;

  const _FolderContentBody({
    required this.folder,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      buildWhen: (previous, current) =>
          previous.folderContentStatus != current.folderContentStatus ||
          previous.folderContentResponse != current.folderContentResponse ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isFolderContentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFolderContentFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب محتوى المجلد',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.h(0.015)),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MyProfileCubit>()
                          .fetchMyProfileFolderContent(folderId: folder.id);
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        final tests = state.folderContentResponse?.data ?? [];

        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.035),
            vertical: SizeConfig.h(0.012),
          ),
          child: Column(
            children: [
              MyProfileFolderInfoCard(folder: folder),

              SizedBox(height: SizeConfig.h(0.014)),

              if (tests.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
                  child: const Text(
                    'لا توجد اختبارات داخل هذا المجلد',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...tests.map((test) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                    child: OtherProfileTestCard(
                      item: mapMyFolderContentTestToOtherProfileTest(test),
                      showSaveButton: false,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class MyProfileFolderInfoCard extends StatelessWidget {
  final MyProfileFolderItemEntity folder;

  const MyProfileFolderInfoCard({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.primaryToPrimaryDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.035),
          vertical: SizeConfig.h(0.014),
        ),
        border: Border.all(color: appColors.whiteToblack),
        boxShadow: [
          BoxShadow(color: appColors.primaryToPrimaryDark, blurRadius: 4),
        ],
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    folder.name,
                    color: appColors.whiteToblack,
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.038),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: SizeConfig.h(0.006)),
                  Row(
                    children: [
                      CustomTextWidget(
                        '${folder.testsCount} عناصر',
                        color: appColors.whiteToblack,
                        fontSize: SizeConfig.text(0.026),
                      ),
                      SizedBox(width: SizeConfig.w(0.03)),
                      CustomTextWidget(
                        folder.publishedAt,
                        color: appColors.whiteToblack,
                        fontSize: SizeConfig.text(0.026),
                      ),
                      SizedBox(width: SizeConfig.w(0.03)),
                      CustomTextWidget(
                        folder.folderKind,
                        color: appColors.whiteToblack,
                        fontSize: SizeConfig.text(0.026),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: SizeConfig.w(0.03)),
            CustomAppImage(path: AppImage.emptyFolder)
          ],
        ),
      ),
    );
  }
}
