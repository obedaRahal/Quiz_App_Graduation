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

class CreateTestAiMediaSection extends StatelessWidget {
  const CreateTestAiMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.creationMode != current.creationMode ||
            previous.aiMediaFiles != current.aiMediaFiles;
      },
      builder: (context, state) {
        if (!state.isAiMode || state.aiMediaFiles.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MediaHeader(isImages: state.isAiImages),

            SizedBox(height: SizeConfig.h(0.012)),

            if (state.isAiImages)
              _ImagesPreview(files: state.aiMediaFiles)
            else
              _FilePreview(file: state.aiMediaFiles.first),
          ],
        );
      },
    );
  }
}

class _MediaHeader extends StatelessWidget {
  final bool isImages;

  const _MediaHeader({required this.isImages});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              // isImages ? Icons.image_outlined : Icons.article_outlined,
              Icons.code,
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

        SizedBox(height: SizeConfig.h(0.004)),

        CustomTextWidget(
          isImages
              ? 'الوسائط التي قمت بإرفاقها سيتم توليد الاختبار منها باستخدام أدوات الذكاء الاصطناعي'
              : 'الملف الذي قمت بإرفاقه سيتم توليد الاختبار منه باستخدام أدوات الذكاء الاصطناعي',
          fontSize: SizeConfig.text(0.030),
          fontWeight: FontWeight.w600,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 2,
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
            ? _ImageFallback(fileName: file.name)
            : Image.file(
                File(file.path!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _ImageFallback(fileName: file.name);
                },
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final String fileName;

  const _ImageFallback({required this.fileName});

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
              file.name,
              fontSize: SizeConfig.text(0.030),
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
