import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';

class SchoolStageStep extends StatelessWidget {
  const SchoolStageStep({super.key});

  static final List<_SchoolStageOption> _options = [
    _SchoolStageOption(
      title: 'ابتدائي',
      description: 'يشمل الصفوف من\nالصف الأول إلى الصف\nالسادس',
      imagePath: AppImage.number1Onboarding
    ),
    _SchoolStageOption(
      title: 'اعدادي',
      description: 'يشمل الصفوف من\nالصف السابع إلى الصف\nالتاسع',
      imagePath: AppImage.number2Onboarding
    ),
    _SchoolStageOption(
      title: 'ثانوي',
      description: 'يشمل الصفوف من\nالصف العاشر إلى صف\nالبكالوريا',
      imagePath: AppImage.number3Onboarding
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //SizeConfig.init(context);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.schoolStage != current.schoolStage,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SchoolStageCard(
                    imagePath: _options[1].imagePath,
                    option: _options[1],
                    isSelected: state.schoolStage == _options[1].title,
                    onTap: () {
                      context.read<OnboardingCubit>().schoolStageChanged(
                        _options[1].title,
                      );
                      //debugPrint(state.schoolStage);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.04)),
                Expanded(
                  child: _SchoolStageCard(
                    imagePath:_options[0].imagePath,
                    option: _options[0],
                    isSelected: state.schoolStage == _options[0].title,
                    onTap: () {
                      context.read<OnboardingCubit>().schoolStageChanged(
                        _options[0].title,
                      );                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.03)),
            Center(
              child: SizedBox(
                width: SizeConfig.w(0.42),
                child: _SchoolStageCard(
                  imagePath: _options[2].imagePath,
                  option: _options[2],
                  isSelected: state.schoolStage == _options[2].title,
                  onTap: () {
                    context.read<OnboardingCubit>().schoolStageChanged(
                      _options[2].title,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SchoolStageCard extends StatelessWidget {
  final _SchoolStageOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final String imagePath;

  const _SchoolStageCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppPalette.primary : AppPalette.greyLight;
    final backgroundColor = isSelected
        ? AppPalette.primarySoft
        : AppPalette.grey;
    final titleColor = isSelected ? AppPalette.primary : AppPalette.black;
    final descriptionColor = AppPalette.greyMedium;
    final iconColor = isSelected ? AppPalette.primary : AppPalette.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.018),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.8 : 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppImage(path: imagePath, color: iconColor),
              SizedBox(height: SizeConfig.h(0.01)),
              CustomTextWidget(
                option.title,
                textAlign: TextAlign.center,
                color: titleColor,
                fontSize: SizeConfig.text(0.045),
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: SizeConfig.h(0.008)),
              CustomTextWidget(
                option.description,
                textAlign: TextAlign.center,
                color: descriptionColor,
                fontSize: SizeConfig.text(0.026),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SchoolStageOption {
  final String title;
  final String description;
  final String imagePath;

  const _SchoolStageOption({
    required this.title,
    required this.description,
    required this.imagePath
  });
}
