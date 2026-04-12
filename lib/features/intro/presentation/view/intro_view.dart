import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/intro/data/model/intro_page_item.dart';
import 'package:quiz_app_grad/features/intro/presentation/constants/intro_pages_content.dart';
import 'package:quiz_app_grad/features/intro/presentation/managet/intro_cubit/intro_cubit.dart';
import 'package:quiz_app_grad/features/intro/presentation/managet/intro_cubit/intro_state.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_bottom_panel.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_header_logo_skip.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_image_pager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IntroCubit(),
      child: const _IntroViewBody(),
    );
  }
}

class _IntroViewBody extends StatefulWidget {
  const _IntroViewBody();

  @override
  State<_IntroViewBody> createState() => _IntroViewBodyState();
}

class _IntroViewBodyState extends State<_IntroViewBody> {
  late final PageController _pageController;

  List<IntroPageItem> get _pages => IntroPagesContent.pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onSkip() async {
    debugPrint(" skip to welcome ");
    await context.read<IntroCubit>().finishIntro();
  }

  void _onPageChanged(int index) {
    debugPrint(" page changed to  $index");
    context.read<IntroCubit>().pageChanged(index);
  }

  Future<void> _nextPage({
    required bool isLastPage,
    required int currentPage,
  }) async {
    if (isLastPage) {
      debugPrint(" its the last page cuz $isLastPage ");

      await context.read<IntroCubit>().finishIntro();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    context.read<IntroCubit>().pageChanged(currentPage + 1);
  }

  Future<void> _previousPage({
    required bool isFirstPage,
    required int currentPage,
  }) async {
    if (isFirstPage) return;
    debugPrint(" its the first page cuz $isFirstPage ");
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );

    context.read<IntroCubit>().pageChanged(currentPage - 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroCubit, IntroState>(
      listenWhen: (prev, curr) =>
          prev.isFinished != curr.isFinished ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isFinished) {
          context.goNamed(AppRouterName.welcome);
        }

        if (state.errorMessage != null) {
          debugPrint(" error at  intro view at  errMsg");
          // showTopSnackBar(
          //   context,
          //   message: state.errorMessage!,
          //   isSuccess: false,
          // );
        }
      },
      child: BlocBuilder<IntroCubit, IntroState>(
        builder: (context, state) {
          final currentPage = state.currentPage;
          final currentPageData = _pages[currentPage];
          final isFirstPage = currentPage == 0;
          final isLastPage = currentPage == _pages.length - 1;

          return Scaffold(
            backgroundColor: AppPalette.whiteSoft,
            body: SafeArea(
              child: Column(
                children: [
                  IntroHeaderLogoSkip(onSkip: _onSkip),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        IntroImagePager(
                          controller: _pageController,
                          pages: _pages,
                          onPageChanged: _onPageChanged,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: -10,
                          child: IntroBottomPanel(
                            pageData: currentPageData,
                            controller: _pageController,
                            pagesCount: _pages.length,
                            onNext: () => _nextPage(
                              isLastPage: isLastPage,
                              currentPage: currentPage,
                            ),
                            onPrevious: () => _previousPage(
                              isFirstPage: isFirstPage,
                              currentPage: currentPage,
                            ),
                            isPreviousEnabled: !isFirstPage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.isSaving)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
