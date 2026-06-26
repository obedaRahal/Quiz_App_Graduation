import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_existing_media_state.dart';

class CreateTestAiMediaSection extends StatelessWidget {
  const CreateTestAiMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.creationMode != current.creationMode ||
            previous.aiMediaFiles != current.aiMediaFiles ||
            previous.existingAiMedia != current.existingAiMedia ||
            previous.isEditMode != current.isEditMode;
      },
      builder: (context, state) {
        final isImages = state.isAiImages || state.isContentImages;
        final hasLocalMedia = state.aiMediaFiles.isNotEmpty;
        final hasExistingMedia = state.existingAiMedia.isNotEmpty;

        if (!state.hasMediaSection || (!hasLocalMedia && !hasExistingMedia)) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MediaHeader(
              isImages: isImages,
              isEditMode: state.isEditMode,
              isContentMode: state.isContentMode,
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            if (hasExistingMedia)
              isImages
                  ? _ExistingImagesPreview(media: state.existingAiMedia)
                  : _ExistingFilePreview(media: state.existingAiMedia.first)
            else
              isImages
                  ? _ImagesPreview(files: state.aiMediaFiles)
                  : _FilePreview(file: state.aiMediaFiles.first),
          ],
        );
      },
    );
  }
}

class _MediaHeader extends StatelessWidget {
  final bool isImages;
  final bool isEditMode;
  final bool isContentMode;

  const _MediaHeader({
    required this.isImages,
    required this.isEditMode,
    required this.isContentMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isImages ? Icons.image_outlined : Icons.article_outlined,
              size: SizeConfig.text(0.080),
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.014)),
            CustomTextWidget(
              'الوسائط',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        CustomTextWidget(
          isContentMode
              ? (isImages
                    ? 'الوسائط التي سيتم إنشاء المحتوى منها، يمكنك إرفاق صورة إلى ثلاث صور.'
                    : 'الملف الذي سيتم إنشاء المحتوى منه، يمكنك إرفاق ملف واحد فقط.')
              : isEditMode
              ? (isImages
                    ? 'هذه الصور هي الوسائط التي تم استخدامها لتوليد أسئلة الاختبار، وهي للعرض فقط ولا يمكن تعديلها.'
                    : 'هذا الملف هو الوسيط الذي تم استخدامه لتوليد أسئلة الاختبار، وهو للعرض فقط ولا يمكن تعديله.')
              : (isImages
                    ? 'الوسائط التي قمت بإرفاقها سيتم توليد الاختبار منها باستخدام أدوات الذكاء الاصطناعي'
                    : 'الملف الذي قمت بإرفاقه سيتم توليد الاختبار منه باستخدام أدوات الذكاء الاصطناعي'),
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 3,
        ),
      ],
    );
  }
}

class _ImagesPreview extends StatelessWidget {
  final List<PlatformFile> files;

  const _ImagesPreview({required this.files});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.105),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        itemCount: files.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: SizeConfig.w(0.025));
        },
        itemBuilder: (context, index) {
          return _ImagePreviewTile(file: files[index]);
        },
      ),
    );
  }
}

class _ImagePreviewTile extends StatelessWidget {
  final PlatformFile file;

  const _ImagePreviewTile({required this.file});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: SizeConfig.w(0.25),
      height: SizeConfig.h(0.105),
      padding: EdgeInsets.all(SizeConfig.w(0.008)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: file.path == null
            ? const _ImageFallback()
            : Image.file(
                File(file.path!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _ImageFallback();
                },
              ),
      ),
    );
  }
}

class _ExistingImagesPreview extends StatelessWidget {
  final List<CreateTestExistingMediaState> media;

  const _ExistingImagesPreview({required this.media});

  @override
  Widget build(BuildContext context) {
    final images = media.where((item) => item.isImage).toList();

    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: SizeConfig.h(0.105),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        separatorBuilder: (context, index) {
          return SizedBox(width: SizeConfig.w(0.025));
        },
        itemBuilder: (context, index) {
          return _ExistingImagePreviewTile(media: images[index]);
        },
      ),
    );
  }
}

class _ExistingImagePreviewTile extends StatelessWidget {
  final CreateTestExistingMediaState media;

  const _ExistingImagePreviewTile({required this.media});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: SizeConfig.w(0.25),
      height: SizeConfig.h(0.105),
      padding: EdgeInsets.all(SizeConfig.w(0.008)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          media.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const _ImageFallback();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return const _ImageFallback();
          },
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppPalette.greyMediumDark : AppPalette.primarySoft,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: SizeConfig.text(0.055),
          color: context.appColors.primaryToPrimaryDark,
        ),
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  final PlatformFile file;

  const _FilePreview({required this.file});

  @override
  Widget build(BuildContext context) {
    return _MediaFileTile(fileName: file.name, isExisting: false);
  }
}

class _ExistingFilePreview extends StatelessWidget {
  final CreateTestExistingMediaState media;

  const _ExistingFilePreview({required this.media});

  @override
  Widget build(BuildContext context) {
    return _MediaFileTile(
      fileName: media.name.trim().isEmpty ? 'ملف الاختبار' : media.name,
      isExisting: true,
    );
  }
}

class _MediaFileTile extends StatelessWidget {
  final String fileName;
  final bool isExisting;

  const _MediaFileTile({required this.fileName, required this.isExisting});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      height: SizeConfig.h(0.060),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : appColors.primaryToPrimaryDark,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: SizeConfig.text(0.050),
            color: appColors.primaryToPrimaryDark,
          ),

          SizedBox(width: SizeConfig.w(0.020)),

          Expanded(
            child: CustomTextWidget(
              fileName,
              fontSize: SizeConfig.text(0.030),
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (isExisting) ...[
            SizedBox(width: SizeConfig.w(0.016)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.018),
                vertical: SizeConfig.h(0.003),
              ),
              decoration: BoxDecoration(
                color: isDark ? AppPalette.greyMediumDark : AppPalette.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomTextWidget(
                'للعرض فقط',
                fontSize: SizeConfig.text(0.022),
                fontWeight: FontWeight.w700,
                color: AppPalette.greyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
