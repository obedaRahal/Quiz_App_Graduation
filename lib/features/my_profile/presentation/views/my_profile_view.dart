import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/my_profile_body.dart';

class MyProfileView extends StatefulWidget {
  final int userId;

  const MyProfileView({super.key, required this.userId});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<MyProfileCubit>().getMyProfilePersonalInfo(
        userId: widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageHeader(
              title: 'الملف الشخصي',
              onBack: () => safeBackToHome(context),
              icon: Icons.settings_outlined,
              onIconTap: () {
                debugPrint('settings');
              },
            ),
            const Expanded(child: MyProfileBody()),
          ],
        ),
      ),
    );
  }
}
