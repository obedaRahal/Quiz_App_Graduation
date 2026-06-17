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
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';

void showOtherProfileFolderDetailsBottomSheet({
  required BuildContext context,
  required int folderId,
}) {
  final cubit = context.read<OtherProfileCubit>();

  cubit.getOtherProfileFolderDetails(folderId: folderId);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: const OtherProfileFolderDetailsBottomSheet(),
      );
    },
  );
}

class OtherProfileFolderDetailsBottomSheet extends StatelessWidget {
  const OtherProfileFolderDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return CustomBackgroundWithChild(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),

          child: BlocBuilder<OtherProfileCubit, OtherProfileState>(
            buildWhen: (previous, current) =>
                previous.getFolderDetailsStatus !=
                    current.getFolderDetailsStatus ||
                previous.folderDetails != current.folderDetails ||
                previous.folderBookmarkActionStatus !=
                    current.folderBookmarkActionStatus,
            builder: (context, state) {
              if (state.isGetFolderDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.isGetFolderDetailsFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.w(0.05)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextWidget(
                          state.errorMessage ??
                              'حدث خطأ أثناء جلب محتوى المجلد',
                          color: AppPalette.red,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.h(0.015)),
                        ElevatedButton(
                          onPressed: () {
                            final folderId =
                                state.folderDetails?.data.folder.id;
                            if (folderId != null) {
                              context
                                  .read<OtherProfileCubit>()
                                  .getOtherProfileFolderDetails(
                                    folderId: folderId,
                                  );
                            }
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final details = state.folderDetails;
              if (details == null) {
                return const SizedBox.shrink();
              }

              final folder = details.data.folder;
              final tests = details.data.items;

              return Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.012)),
                  Container(
                    width: SizeConfig.w(0.12),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppPalette.greyLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(0.014)),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.045),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            folder.name,
                            textAlign: TextAlign.center,
                            fontFamily: AppFont.elMessiriBold,
                            fontSize: SizeConfig.text(0.045),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _FolderDetailsSaveButton(
                          isSaved: folder.viewerHasBookmarked,
                          isLoading:
                              state.isFolderBookmarkLoading &&
                              state.activeBookmarkFolderId == folder.id,
                          onTap: () {
                            context
                                .read<OtherProfileCubit>()
                                .toggleFolderBookmark(folderId: folder.id);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.01)),
                  const CustomDivider(height: 10, thickness: 2 , isDashed: true,),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.035),
                        vertical: SizeConfig.h(0.012),
                      ),
                      child: Column(
                        children: [
                          OtherProfileFolderDetailsInfoCard(folder: folder),
                          SizedBox(height: SizeConfig.h(0.014)),

                          if (tests.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.h(0.05),
                              ),
                              child: const Text(
                                'لا توجد اختبارات داخل هذا المجلد',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            ...tests.map(
                              (test) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: SizeConfig.h(0.014),
                                ),
                                child: OtherProfileTestCard(item: test),
                              ),
                            ),
                        ],
                      ),
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

class _FolderDetailsSaveButton extends StatelessWidget {
  final bool isSaved;
  final bool isLoading;
  final VoidCallback onTap;

  const _FolderDetailsSaveButton({
    required this.isSaved,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: SizeConfig.w(0.075),
        height: SizeConfig.w(0.075),
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Icon(
        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: isSaved ? AppPalette.red : AppPalette.greyMedium,
        size: SizeConfig.w(0.075),
      ),
    );
  }
}

class OtherProfileFolderDetailsInfoCard extends StatelessWidget {
  final OtherProfileFolderDetailsInfoEntity folder;

  const OtherProfileFolderDetailsInfoCard({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: AppPalette.primary.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.035),
          vertical: SizeConfig.h(0.014),
        ),
        border: Border.all(color: AppPalette.white),
        boxShadow: [BoxShadow(color: AppPalette.primary, blurRadius: 4)],
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    folder.name,
                    color: Colors.white,
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.038),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: SizeConfig.h(0.006)),
                  Row(
                    children: [
                      Row(
                        children: [
                          CustomAppImage(
                            path: AppImage.feather,
                            color: AppPalette.black,
                            height: SizeConfig.h(0.02),
                          ),
                          SizedBox(width: SizeConfig.w(0.01)),
                          CustomTextWidget(
                            '${folder.testsCount} عناصر',
                            color: Colors.white,
                            fontSize: SizeConfig.text(0.026),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.w(0.03)),
                      Row(
                        children: [
                          CustomAppImage(
                            path: AppImage.timer,
                            color: AppPalette.black,
                            height: SizeConfig.h(0.02),
                          ),
                          SizedBox(width: SizeConfig.w(0.01)),
                          CustomTextWidget(
                            folder.publishedAt,
                            color: Colors.white,
                            fontSize: SizeConfig.text(0.026),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: SizeConfig.w(0.03)),

            Icon(
              Icons.folder_open_rounded,
              color: AppPalette.blueDark,
              size: SizeConfig.w(0.1),
            ),
          ],
        ),
      ),
    );
  }
}
