import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_asset_viewer.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_app_bar.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_info_sheet.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_existing_media_state.dart';

class ContentDetailsScaffold extends StatefulWidget {
  final ContentDetailsUiData data;

  const ContentDetailsScaffold({super.key, required this.data});

  @override
  State<ContentDetailsScaffold> createState() => _ContentDetailsScaffoldState();
}

class _ContentDetailsScaffoldState extends State<ContentDetailsScaffold> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  int _currentIndex = 0;
  int _pdfPagesCount = 1;

  bool _sheetIsCollapsed = false;
  static const double _collapsedSheetSize = 0.105;
  double get _initialSheetSize => widget.data.isOwner ? 0.25 : 0.44;

  double get _expandedSheetSize => widget.data.isOwner ? 0.38 : 0.72;

  int get _totalCount {
    if (widget.data.isFile) return _pdfPagesCount;

    return widget.data.assets.isNotEmpty
        ? widget.data.assets.length
        : widget.data.assetCount;
  }

  Future<void> _collapseSheet() async {
    if (!_sheetController.isAttached) return;

    await _sheetController.animateTo(
      _collapsedSheetSize,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );

    if (mounted) {
      setState(() => _sheetIsCollapsed = true);
    }
  }

  Future<void> _expandSheet() async {
    if (!_sheetController.isAttached) return;

    await _sheetController.animateTo(
      _initialSheetSize,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );

    if (mounted) {
      setState(() => _sheetIsCollapsed = false);
    }
  }

  Future<void> _toggleSheetFromImageTap() async {
    if (!_sheetController.isAttached) return;

    final currentSize = _sheetController.size;

    if (currentSize <= _collapsedSheetSize + 0.03) {
      await _sheetController.animateTo(
        _initialSheetSize,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } else {
      await _sheetController.animateTo(
        _collapsedSheetSize,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }
Future<void> _goToEditContent() async {
  final data = widget.data;

  final result = await context.pushNamed(
    AppRouterName.createTestPage,
    extra: CreateTestInitialArgs(
      mode: data.isFile
          ? CreateTestCreationMode.contentFile
          : CreateTestCreationMode.contentImages,
      isContentEditMode: true,
      editingContentId: data.id,
      initialTitle: data.title,
      initialDescription: data.description,
      initialIsPublished: data.isPublic,
      initialAcademicLevel: data.targetLevel,
      initialScientificCategories: data.interests,
      initialScientificInterestIds: const [],
      existingAiMedia: data.assets.map((asset) {
        return CreateTestExistingMediaState(
          id: asset.id,
          name: asset.url.split('/').last,
          url: asset.url,
          type: data.isFile ? 'pdf' : 'image',
        );
      }).toList(),
    ),
  );

  if (!mounted) return;

  if (result == true) {
    context.read<OtherContentDetailsCubit>().getMyContentDetails(data.id);
  }
}
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint(
      'ContentDetails images count: ${widget.data.assets.length}, '
      'assetCount: ${widget.data.assetCount}, '
      'currentIndex: $_currentIndex',
    );
    return Scaffold(
      backgroundColor: isDark ? AppPalette.black : AppPalette.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: ContentAssetViewer(
              data: widget.data,
              currentIndex: _currentIndex,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              onPdfPagesCountChanged: (count) {
                setState(() => _pdfPagesCount = count);
              },
              onViewerTap: _toggleSheetFromImageTap,
            ),
          ),

          ContentDetailsAppBar(
            title: 'تفاصيل محتوى',
            currentIndex: _currentIndex + 1,
            totalCount: _totalCount,
            targetLevel: widget.data.targetLevel,
            isOwner: widget.data.isOwner,
            isPublic: widget.data.isPublic,
            onEditContentTap: _goToEditContent,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ContentInfoSheet(
              controller: _sheetController,
              data: widget.data,
              collapsedSize: _collapsedSheetSize,
              initialSize: _initialSheetSize,
              maxSize: _expandedSheetSize,
            ),
          ),
        ],
      ),
    );
  }
}
