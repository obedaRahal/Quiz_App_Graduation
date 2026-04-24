import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/intro/data/model/intro_page_item.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_next_button.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_page_indicator.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_previous_button.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_title.dart';
import 'package:quiz_app_grad/features/intro/presentation/widget/intro_top_arc_clipper.dart';

class IntroBottomPanel extends StatelessWidget {
  final IntroPageItem pageData;
  final PageController controller;
  final int pagesCount;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isPreviousEnabled;
  final bool isSaving;

  const IntroBottomPanel({
    super.key,
    required this.pageData,
    required this.controller,
    required this.pagesCount,
    required this.onNext,
    required this.onPrevious,
    required this.isPreviousEnabled,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: IntroTopArcClipper(),
      color: AppPalette.white,
      elevation: 30,
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: SizeConfig.h(.45),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(.065)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Column(
                  children: [
                    IntroTitle(
                      titleBlack: pageData.titleBlack,
                      titlePrimary: pageData.titlePrimary,
                    ),
                    SizedBox(height: SizeConfig.h(.035)),
                    CustomTextWidget(
                      pageData.description,
                      color: AppPalette.greyMedium,
                      fontSize: SizeConfig.text(.034),
                    ),
                    const Spacer(),
                    if (!isSaving)
                      IntroPageIndicator(
                        controller: controller,
                        count: pagesCount,
                      ),
                    if (isSaving)
                      CircularProgressIndicator(),
                  ],
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                end: 12,
                child: IntroNextButton(onTap: onNext),
              ),
              if (isPreviousEnabled)
                PositionedDirectional(
                  bottom: 0,
                  start: 12,
                  child: IntroPreviousButton(
                    onTap: onPrevious,
                    isEnabled: isPreviousEnabled,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
