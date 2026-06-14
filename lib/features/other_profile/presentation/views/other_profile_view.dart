import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_body.dart';

class OtherProfileView extends StatefulWidget {
  final int userId;

  const OtherProfileView({
    super.key,
    required this.userId,
  });

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // context.read<OtherProfileCubit>().loadMockOtherProfile(
      //       userId: widget.userId,
      //     );
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
              title: 'ملف تعريف المستخدم',
              onBack: () => safeBackToHome(context),
              icon: Icons.share_rounded,
              onIconTap: () {
                debugPrint("============ OtherProfileView.shareTap ============");
                debugPrint("→ userId: ${widget.userId}");
                debugPrint("=================================================");
              },
            ),

            Expanded(
              child: OtherProfileBody(
                userId: widget.userId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}