import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';

enum _CreateTestSheetMode { methods, aiImages, aiFile }

class CreateAiGenerationSheetRequest {
  final String sourceType;
  final int questionCount;
  final String difficultyLevel;
  final String language;
  final List<PlatformFile> files;

  const CreateAiGenerationSheetRequest({
    required this.sourceType,
    required this.questionCount,
    required this.difficultyLevel,
    required this.language,
    required this.files,
  });

  Map<String, dynamic> toDebugMap() {
    return {
      'source_type': sourceType,
      'question_count': questionCount,
      'difficulty_level': difficultyLevel,
      'language': language,
      'files': files.map((file) => file.name).toList(),
    };
  }
}

Future<void> showCreateTestBottomSheet(
  BuildContext context, {
  ValueChanged<CreateAiGenerationSheetRequest>? onAiGenerationRequested,
  bool hasReachedAiDailyLimit = false,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'create_test_bottom_sheet',
    barrierColor: Colors.black.withOpacity(0.12),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
              child: const SizedBox.expand(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CreateTestBottomSheet(
              onAiGenerationRequested: onAiGenerationRequested,
              hasReachedAiDailyLimit: hasReachedAiDailyLimit,
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(opacity: curvedAnimation, child: child),
      );
    },
  );
}

class CreateTestBottomSheet extends StatefulWidget {
  final ValueChanged<CreateAiGenerationSheetRequest>? onAiGenerationRequested;
  final bool hasReachedAiDailyLimit;

  const CreateTestBottomSheet({
    super.key,
    this.onAiGenerationRequested,
    this.hasReachedAiDailyLimit = false,
  });

  @override
  State<CreateTestBottomSheet> createState() => _CreateTestBottomSheetState();
}

class _CreateTestBottomSheetState extends State<CreateTestBottomSheet> {
  _CreateTestSheetMode _mode = _CreateTestSheetMode.methods;

  final TextEditingController _questionCountController = TextEditingController(
    text: '10',
  );

  String _selectedLevel = 'سهل';
  String _selectedLanguage = 'عربية';

  List<PlatformFile> _selectedImages = [];
  PlatformFile? _selectedFile;

  static const List<String> _levels = ['سهل', 'متوسط', 'صعب'];
  static const List<String> _languages = ['عربية', 'إنكليزية'];

  @override
  void dispose() {
    _questionCountController.dispose();
    super.dispose();
  }

  bool get _isAiMode {
    return _mode == _CreateTestSheetMode.aiImages ||
        _mode == _CreateTestSheetMode.aiFile;
  }

  bool get _hasMedia {
    if (_mode == _CreateTestSheetMode.aiImages) {
      return _selectedImages.isNotEmpty && _selectedImages.length <= 3;
    }

    if (_mode == _CreateTestSheetMode.aiFile) {
      return _selectedFile != null;
    }

    return false;
  }

  bool get _canRequestGeneration {
    final count = int.tryParse(_questionCountController.text.trim());

    return _isAiMode &&
        _hasMedia &&
        count != null &&
        count >= 10 &&
        count <= 40 &&
        _selectedLevel.trim().isNotEmpty &&
        _selectedLanguage.trim().isNotEmpty;
  }

  void _goToAiImages() {
    setState(() {
      _mode = _CreateTestSheetMode.aiImages;
    });
  }

  void _goToAiFile() {
    setState(() {
      _mode = _CreateTestSheetMode.aiFile;
    });
  }

  void _backToMethods() {
    setState(() {
      _mode = _CreateTestSheetMode.methods;
    });
  }

  void _requestAiGeneration() {
    if (!_canRequestGeneration) return;

    final count = int.parse(_questionCountController.text.trim());

    final args = CreateTestInitialArgs(
      mode: _mode == _CreateTestSheetMode.aiImages
          ? CreateTestCreationMode.aiImages
          : CreateTestCreationMode.aiFile,
      mediaFiles: _mode == _CreateTestSheetMode.aiImages
          ? _selectedImages
          : [_selectedFile!],
      aiQuestionCount: count,
      aiLevel: _selectedLevel,
      aiLanguage: _selectedLanguage,
    );

    Navigator.of(context).pop();

    context.pushNamed(AppRouterName.createTestAiLoadingPage, extra: args);
  }

  Future<void> _pickMedia() async {
    if (_mode == _CreateTestSheetMode.aiImages) {
      await _pickImages();
      return;
    }

    if (_mode == _CreateTestSheetMode.aiFile) {
      await _pickPdfFile();
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: true,
      withData: false,
    );

    if (result == null) return;

    final validFiles = result.files
        .where((file) => file.path != null && file.path!.trim().isNotEmpty)
        .take(3)
        .toList();

    setState(() {
      _selectedImages = validFiles;
    });
  }

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (file.path == null || file.path!.trim().isEmpty) return;

    setState(() {
      _selectedFile = file;
    });
  }

  void _removeSelectedImage(PlatformFile file) {
    setState(() {
      _selectedImages = _selectedImages
          .where((selectedFile) => selectedFile.identifier != file.identifier)
          .toList();
    });
  }

  void _removeSelectedFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  String _mapDifficultyLevelToBackend(String value) {
    return switch (value.trim()) {
      'سهل' => 'Easy',
      'متوسط' => 'Medium',
      'صعب' => 'Hard',
      _ => 'Easy',
    };
  }

  String _mapLanguageToBackend(String value) {
    return switch (value.trim()) {
      'عربية' => 'Arabic',
      'إنكليزية' => 'English',
      _ => 'Arabic',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppPalette.fieldColorNDark
        : AppPalette.white;
    final primaryTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;
    final secondaryTextColor = isDark
        ? AppPalette.grey2Dark
        : AppPalette.greyMedium;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: _isAiMode ? SizeConfig.h(0.68) : SizeConfig.h(0.40),
              maxHeight: _isAiMode ? SizeConfig.h(0.88) : SizeConfig.h(0.52),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: SizeConfig.h(0.008)),

                Container(
                  width: SizeConfig.w(0.13),
                  height: SizeConfig.h(0.0045),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.greyLightDark
                        : AppPalette.smallContainerGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.008)),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.045),
                  ),
                  child: SizedBox(
                    height: SizeConfig.h(0.045),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: CustomTextWidget(
                            _mode == _CreateTestSheetMode.methods
                                ? 'إنشاء اختبار'
                                : _mode == _CreateTestSheetMode.aiImages
                                ? 'توليد الأسئلة من الصور'
                                : 'توليد الأسئلة من ملف',
                            fontSize: SizeConfig.text(0.050),
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        if (_isAiMode)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: _backToMethods,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: SizeConfig.w(0.080),
                                height: SizeConfig.w(0.080),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppPalette.greyMediumDark
                                      : AppPalette.whiteToGrey,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppPalette.borderFieldColorNDark
                                        : AppPalette.borderFieldColorNLight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  size: SizeConfig.text(0.040),
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.010)),

                const _DashedDivider(),

                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeOutCubic,
                    child: _mode == _CreateTestSheetMode.methods
                        ? _MethodsContent(
                            key: const ValueKey('methods'),
                            primaryTextColor: primaryTextColor,
                            secondaryTextColor: secondaryTextColor,
                            hasReachedAiDailyLimit:
                                widget.hasReachedAiDailyLimit,
                            onManualTap: () {
                              Navigator.of(context).pop();

                              context.pushNamed(
                                AppRouterName.createTestPage,
                                extra: const CreateTestInitialArgs(
                                  mode: CreateTestCreationMode.manual,
                                ),
                              );
                            },
                            onAiImagesTap: _goToAiImages,
                            onAiFileTap: _goToAiFile,
                          )
                        : _AiGenerationContent(
                            key: ValueKey(_mode.name),
                            mode: _mode,
                            selectedImages: _selectedImages,
                            selectedFile: _selectedFile,
                            questionCountController: _questionCountController,
                            selectedLevel: _selectedLevel,
                            selectedLanguage: _selectedLanguage,
                            levels: _levels,
                            languages: _languages,
                            onQuestionCountChanged: (_) {
                              setState(() {});
                            },
                            onLevelChanged: (value) {
                              setState(() {
                                _selectedLevel = value;
                              });
                            },
                            onLanguageChanged: (value) {
                              setState(() {
                                _selectedLanguage = value;
                              });
                            },
                            onPickMedia: _pickMedia,
                            onRemoveImage: _removeSelectedImage,
                            onRemoveFile: _removeSelectedFile,
                            canRequestGeneration: _canRequestGeneration,
                            onRequestGeneration: _requestAiGeneration,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodsContent extends StatelessWidget {
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final bool hasReachedAiDailyLimit;
  final VoidCallback onManualTap;
  final VoidCallback onAiImagesTap;
  final VoidCallback onAiFileTap;

  const _MethodsContent({
    super.key,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.hasReachedAiDailyLimit,
    required this.onManualTap,
    required this.onAiImagesTap,
    required this.onAiFileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fieldColor = isDark
        ? AppPalette.greyMediumDark
        : const Color(0xFFFAFAFA);
    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : const Color(0xFFE8E8E8);
    final aiDisabled = hasReachedAiDailyLimit;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Column(
        key: const ValueKey('methods_content'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.h(0.018)),

          CustomTextWidget(
            'طريقة الإنشاء',
            fontSize: SizeConfig.text(0.045),
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.004)),

          CustomTextWidget(
            'حدد الطريقة التي تود إنشاء اختبار بها',
            fontSize: SizeConfig.text(0.035),
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.017)),

          _CreateTestMethodField(
            title: 'إنشاء الاختبار يدوياً',
            icon: Icons.edit_outlined,
            fieldColor: fieldColor,
            borderColor: borderColor,
            textColor: secondaryTextColor,
            iconColor: primaryTextColor,
            onTap: onManualTap,
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          _CreateTestMethodField(
            title: 'رفع صور إلى الذكاء الاصطناعي',
            icon: Icons.image_outlined,
            fieldColor: fieldColor,
            borderColor: borderColor,
            textColor: secondaryTextColor,
            iconColor: primaryTextColor,
            isDisabled: aiDisabled,
            disabledMessage:
                'لقد وصلت إلى الحد اليومي لاستخدام الذكاء الاصطناعي',
            onTap: aiDisabled ? null : onAiImagesTap,
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          _CreateTestMethodField(
            title: 'رفع ملف إلى الذكاء الاصطناعي',
            icon: Icons.article_outlined,
            fieldColor: fieldColor,
            borderColor: borderColor,
            textColor: secondaryTextColor,
            iconColor: primaryTextColor,
            isDisabled: aiDisabled,
            disabledMessage:
                'لقد وصلت إلى الحد اليومي لاستخدام الذكاء الاصطناعي',
            onTap: aiDisabled ? null : onAiFileTap,
          ),
          if (aiDisabled) ...[
            SizedBox(height: SizeConfig.h(0.012)),
            _AiDailyLimitMessage(
              text:
                  'تم استهلاك جميع محاولات توليد الأسئلة بالذكاء الاصطناعي لهذا اليوم. يمكنك إنشاء اختبار يدوياً حالياً.',
            ),
            SizedBox(height: SizeConfig.h(0.01)),
          ],
          SizedBox(height: SizeConfig.h(0.01)),
        ],
      ),
    );
  }
}

class _AiDailyLimitMessage extends StatelessWidget {
  final String text;

  const _AiDailyLimitMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.030),
        vertical: SizeConfig.h(0.010),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppPalette.greyMediumDark
            : AppPalette.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppPalette.red.withOpacity(isDark ? 0.55 : 0.35),
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: SizeConfig.text(0.038),
            color: AppPalette.red,
          ),
          SizedBox(width: SizeConfig.w(0.018)),
          Expanded(
            child: CustomTextWidget(
              text,
              fontSize: SizeConfig.text(0.026),
              fontWeight: FontWeight.w700,
              color: isDark ? AppPalette.textWhiteINDark : AppPalette.red,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiGenerationContent extends StatelessWidget {
  final _CreateTestSheetMode mode;
  final List<PlatformFile> selectedImages;
  final PlatformFile? selectedFile;
  final TextEditingController questionCountController;
  final String selectedLevel;
  final String selectedLanguage;
  final List<String> levels;
  final List<String> languages;
  final ValueChanged<String> onQuestionCountChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onPickMedia;
  final bool canRequestGeneration;
  final VoidCallback onRequestGeneration;
  final ValueChanged<PlatformFile> onRemoveImage;
  final VoidCallback onRemoveFile;

  const _AiGenerationContent({
    super.key,
    required this.mode,
    required this.selectedImages,
    required this.selectedFile,
    required this.questionCountController,
    required this.selectedLevel,
    required this.selectedLanguage,
    required this.levels,
    required this.languages,
    required this.onQuestionCountChanged,
    required this.onLevelChanged,
    required this.onLanguageChanged,
    required this.onPickMedia,
    required this.canRequestGeneration,
    required this.onRequestGeneration,
    required this.onRemoveImage,
    required this.onRemoveFile,
  });

  bool get isImagesMode => mode == _CreateTestSheetMode.aiImages;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final primaryTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;
    final secondaryTextColor = isDark
        ? AppPalette.grey2Dark
        : AppPalette.greyMedium;
    final fieldColor = isDark ? AppPalette.greyMediumDark : AppPalette.white;
    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.borderFieldColorNLight;

    return SingleChildScrollView(
      key: const ValueKey('ai_content'),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.h(0.018)),

          CustomTextWidget(
            'الوسائط',
            fontSize: SizeConfig.text(0.045),
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.004)),

          CustomTextWidget(
            isImagesMode
                ? 'أرفق حتى 3 صور ليتم استخراج الأسئلة منها'
                : 'أرفق ملفاً واحداً ليتم استخراج الأسئلة منه',
            fontSize: SizeConfig.text(0.032),
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
            textAlign: TextAlign.right,
            maxLines: 2,
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          _MediaPickerField(
            title: isImagesMode ? 'اختر الصور' : 'اختر الملف',
            subtitle: isImagesMode ? 'الحد الأقصى 3 صور' : 'ملف واحد فقط',
            icon: isImagesMode ? Icons.image_outlined : Icons.article_outlined,
            onTap: onPickMedia,
          ),

          if (isImagesMode && selectedImages.isNotEmpty) ...[
            SizedBox(height: SizeConfig.h(0.010)),
            ...selectedImages.map((file) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
                child: _SelectedMediaPreview(
                  title: file.name,
                  icon: Icons.image_outlined,
                  onRemove: () => onRemoveImage(file),
                ),
              );
            }),
          ],

          if (!isImagesMode && selectedFile != null) ...[
            SizedBox(height: SizeConfig.h(0.010)),
            _SelectedMediaPreview(
              title: selectedFile!.name,
              icon: Icons.article_outlined,
              onRemove: onRemoveFile,
            ),
          ],

          SizedBox(height: SizeConfig.h(0.020)),

          CustomTextWidget(
            'إعدادات التوليد',
            fontSize: SizeConfig.text(0.045),
            fontWeight: FontWeight.w800,
            color: primaryTextColor,
            textAlign: TextAlign.right,
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          _QuestionCountField(
            controller: questionCountController,
            onChanged: onQuestionCountChanged,
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          _SegmentedOptionsRow(
            title: 'مستوى الأسئلة',
            items: levels,
            selectedItem: selectedLevel,
            onChanged: onLevelChanged,
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          _SegmentedOptionsRow(
            title: 'لغة الأسئلة',
            items: languages,
            selectedItem: selectedLanguage,
            onChanged: onLanguageChanged,
          ),

          SizedBox(height: SizeConfig.h(0.020)),

          SizedBox(
            width: double.infinity,
            height: SizeConfig.h(0.050),
            child: ElevatedButton(
              onPressed: canRequestGeneration ? onRequestGeneration : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primaryToPrimaryDark,
                disabledBackgroundColor: isDark
                    ? AppPalette.greyLightDark
                    : const Color(0xFFBFD0FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: CustomTextWidget(
                'طلب توليد الأسئلة',
                fontSize: SizeConfig.text(0.032),
                fontWeight: FontWeight.w800,
                color: canRequestGeneration
                    ? (isDark ? AppPalette.black : AppPalette.white)
                    : (isDark ? AppPalette.grey2Dark : AppPalette.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: SizeConfig.h(0.022)),
        ],
      ),
    );
  }
}

class _MediaPickerField extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MediaPickerField({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;
    final secondaryTextColor = isDark
        ? AppPalette.grey2Dark
        : AppPalette.greyMedium;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: SizeConfig.h(0.066),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.greyMediumDark : AppPalette.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: SizeConfig.text(0.056), color: primaryTextColor),
            SizedBox(width: SizeConfig.w(0.025)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    title,
                    fontSize: SizeConfig.text(0.033),
                    fontWeight: FontWeight.w800,
                    color: primaryTextColor,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                  SizedBox(height: SizeConfig.h(0.002)),
                  CustomTextWidget(
                    subtitle,
                    fontSize: SizeConfig.text(0.025),
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_rounded,
              size: SizeConfig.text(0.048),
              color: context.appColors.primaryToPrimaryDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedMediaPreview extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onRemove;

  const _SelectedMediaPreview({
    required this.title,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      height: SizeConfig.h(0.040),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.026)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyMediumDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : appColors.primaryToPrimaryDark,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: SizeConfig.text(0.034),
            color: appColors.primaryToPrimaryDark,
          ),

          SizedBox(width: SizeConfig.w(0.018)),

          Expanded(
            child: CustomTextWidget(
              title,
              fontSize: SizeConfig.text(0.025),
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),

          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.008)),
              child: Icon(
                Icons.close_rounded,
                size: SizeConfig.text(0.030),
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCountField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _QuestionCountField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;
    final hintColor = isDark ? AppPalette.grey2Dark : AppPalette.greyMedium;

    return SizedBox(
      height: SizeConfig.h(0.054),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        onChanged: onChanged,
        onSubmitted: (value) {
          final parsed = int.tryParse(value.trim());

          if (parsed == null) {
            controller.text = '10';
            onChanged(controller.text);
            return;
          }

          final normalized = parsed.clamp(10, 40).toString();

          controller.text = normalized;
          controller.selection = TextSelection.collapsed(
            offset: controller.text.length,
          );

          onChanged(controller.text);
        },
        style: TextStyle(
          fontSize: SizeConfig.text(0.032),
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        cursorColor: context.appColors.primaryToPrimaryDark,

        decoration: InputDecoration(
          hintText: 'عدد الأسئلة من 10 إلى 40',
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            fontSize: SizeConfig.text(0.030),
            fontWeight: FontWeight.w600,
            color: hintColor,
          ),
          filled: true,
          fillColor: isDark ? AppPalette.greyMediumDark : AppPalette.white,
          contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
          prefixIcon: Icon(
            Icons.format_list_numbered_rounded,
            size: SizeConfig.text(0.048),
            color: hintColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.borderFieldColorNLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: context.appColors.primaryToPrimaryDark,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedOptionsRow extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onChanged;

  const _SegmentedOptionsRow({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.032),
          fontWeight: FontWeight.w800,
          color: primaryTextColor,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: SizeConfig.h(0.008)),
        Row(
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: item == items.last ? 0 : SizeConfig.w(0.010),
                ),
                child: _SegmentedOptionTile(
                  title: item,
                  isSelected: selectedItem == item,
                  onTap: () => onChanged(item),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SegmentedOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentedOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: SizeConfig.h(0.040),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppPalette.greyLightDark : AppPalette.primarySoft)
              : (isDark ? AppPalette.greyMediumDark : AppPalette.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : (isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.028),
          fontWeight: FontWeight.w800,
          color: isSelected
              ? appColors.primaryToPrimaryDark
              : (isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CreateTestMethodField extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color fieldColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? disabledMessage;

  const _CreateTestMethodField({
    required this.title,
    required this.icon,
    required this.fieldColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    this.isDisabled = false,
    this.disabledMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedFieldColor = isDisabled
        ? (isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey)
        : fieldColor;

    final resolvedBorderColor = isDisabled
        ? (isDark ? AppPalette.borderFieldColorNDark : AppPalette.greyLight)
        : borderColor;

    final resolvedTextColor = isDisabled
        ? (isDark ? AppPalette.greyLightDark : AppPalette.greyMedium)
        : textColor;

    final resolvedIconColor = isDisabled
        ? (isDark ? AppPalette.greyLightDark : AppPalette.greyMedium)
        : iconColor;

    return SizedBox(
      height: SizeConfig.h(0.062),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Opacity(
          opacity: isDisabled ? 0.62 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: resolvedFieldColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: resolvedBorderColor, width: 1),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                SizedBox(width: SizeConfig.w(0.025)),
                Icon(
                  icon,
                  size: SizeConfig.text(0.062),
                  color: resolvedIconColor,
                ),
                SizedBox(width: SizeConfig.w(0.025)),
                Expanded(
                  child: CustomTextWidget(
                    title,
                    fontSize: SizeConfig.text(0.035),
                    fontWeight: FontWeight.w600,
                    color: resolvedTextColor,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                  ),
                ),
                if (isDisabled) ...[
                  Icon(
                    Icons.lock_outline_rounded,
                    size: SizeConfig.text(0.040),
                    color: resolvedTextColor,
                  ),
                  SizedBox(width: SizeConfig.w(0.018)),
                ],
                SizedBox(width: SizeConfig.w(0.02)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : const Color(0xFFD7D7D7),
          dashWidth: 9,
          dashSpace: 6,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
