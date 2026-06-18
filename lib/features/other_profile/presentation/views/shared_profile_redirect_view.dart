import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/other_profile/data/models/other_profile_route_args.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class SharedProfileRedirectView extends StatelessWidget {
  final String slug;

  const SharedProfileRedirectView({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OtherProfileCubit, OtherProfileState>(
          listenWhen: (previous, current) =>
              previous.receiveStatus != current.receiveStatus,
          listener: (context, state) {
            if (state.isReceiveSuccess) {
              final userId = state.receivedUserId;
              final isThisYourProfile =
                  state.receivedIsThisYourProfile ?? false;

              context.read<OtherProfileCubit>().resetOtherProfileReceiveState();

              if (userId == null || userId <= 0) {
                context.go(AppRouterPath.mainLayout);
                return;
              }

              if (isThisYourProfile) {
                context.go(AppRouterPath.mainLayout);
                return;
              }

              context.go(
                AppRouterPath.otherProfile,
                extra: OtherProfileRouteArgs(userId: userId),
              );
            }

            if (state.isReceiveFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر فتح رابط الملف الشخصي",
                type: AppValidationSnackBarType.error,
              );

              context.read<OtherProfileCubit>().resetOtherProfileReceiveState();
              context.go(AppRouterPath.mainLayout);
            }
          },
          builder: (context, state) {
            return Center(
              child: state.isReceiveLoading
                  ? const CircularProgressIndicator()
                  : const CustomTextWidget(
                      "جاري فتح الملف الشخصي...",
                      textAlign: TextAlign.center,
                    ),
            );
          },
        ),
      ),
    );
  }
}