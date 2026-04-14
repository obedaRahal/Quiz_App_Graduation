import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_option_selected_card.dart';
import '../../../../../core/utils/media_query_config.dart';

class HeardAboutStep extends StatelessWidget {
  const HeardAboutStep({super.key});

  static const List<_HeardAboutOption> _options = [
    _HeardAboutOption(
      value: 'linkedin',
      label: 'لينكد إن',
      icon: FontAwesomeIcons.linkedin,
    ),
    _HeardAboutOption(
      value: 'instagram',
      label: 'انستاغرام',
      icon: FontAwesomeIcons.instagram,
    ),
    _HeardAboutOption(
      value: 'facebook',
      label: 'فيسبوك',
      icon: FontAwesomeIcons.facebook,
    ),
    _HeardAboutOption(
      value: 'friends',
      label: 'الأصدقاء',
      icon: FontAwesomeIcons.userGroup,
    ),
    _HeardAboutOption(
      value: 'family',
      label: 'العائلة',
      icon: FontAwesomeIcons.peopleRoof,
    ),
    _HeardAboutOption(
      value: 'other',
      label: 'غير ذلك',
      icon: FontAwesomeIcons.ellipsis,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.heardAbout != current.heardAbout,
      builder: (context, state) {
        return Column(
          children: _options.map((option) {
            final isSelected = state.heardAbout == option.value;

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
              child: OnboardingOptionSelectedCard(
                label: option.label,
                icon: option.icon,
                isSelected: isSelected,
                onTap: () {
                  context.read<OnboardingCubit>().heardAboutChanged(
                    option.value,
                  );
                },
                backgroundColor: isSelected
                    ? AppPalette.primarySoft
                    : AppPalette.grey,
                borderColor: isSelected
                    ? AppPalette.primary
                    : AppPalette.greyLight,
                textColor: isSelected ? AppPalette.primary : AppPalette.black,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _HeardAboutOption {
  final String value;
  final String label;
  final FaIconData icon;

  const _HeardAboutOption({
    required this.value,
    required this.label,
    required this.icon,
  });
}
