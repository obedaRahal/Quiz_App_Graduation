import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/search_body.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: Column(
            children: [
              StudyPlanHomeHeader(
                title: 'البحث عن مستخدمين',
                onActionTap: () {
                  Navigator.of(context).pop();
                },
                actionIcon: Icons.arrow_back_ios_rounded,
              ),

              const Expanded(child: SearchBody()),
            ],
          ),
        ),
      ),
    );
  }
}
