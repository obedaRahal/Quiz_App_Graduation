import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_option_selected_card.dart';
import '../../../../../core/utils/media_query_config.dart';

class HeardAboutStep extends StatelessWidget {
  const HeardAboutStep({super.key});

  static const List<_HeardAboutOption> _options = [
    _HeardAboutOption(title: 'لينكد إن', icon: FontAwesomeIcons.linkedin),
    _HeardAboutOption(title: 'إنستاغرام', icon: FontAwesomeIcons.instagram),
    _HeardAboutOption(title: 'فيسبوك', icon: FontAwesomeIcons.facebook),
    _HeardAboutOption(title: 'الإصدقاء ', icon: FontAwesomeIcons.userGroup),
    _HeardAboutOption(title: 'العائلة', icon: FontAwesomeIcons.peopleRoof),
    _HeardAboutOption(title: 'غير ذلك', icon: FontAwesomeIcons.ellipsis),
  ];

  @override
  Widget build(BuildContext context) {
    //SizeConfig.init(context);
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.heardAbout != current.heardAbout,
      builder: (context, state) {
        return Column(
          children: _options.map((option) {
            final isSelected = state.heardAbout == option.title;

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
              child: OnboardingOptionSelectedCard(
                label: option.title,
                icon: option.icon,
                isSelected: isSelected,
                onTap: () {
                  context.read<OnboardingCubit>().heardAboutChanged(
                    option.title,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _HeardAboutOption {
  final String title;
  final FaIconData icon;

  const _HeardAboutOption({required this.title, required this.icon});
}
