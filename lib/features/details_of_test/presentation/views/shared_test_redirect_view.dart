import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_state.dart';

class SharedTestRedirectView extends StatelessWidget {
  final String slug;

  const SharedTestRedirectView({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
          listenWhen: (previous, current) =>
              previous.sharedTestLinkStatus != current.sharedTestLinkStatus,
          listener: (context, state) {
            if (state.isSharedTestLinkSuccess) {
              final testId = state.sharedTestId;
              final isOwner = state.sharedTestIsOwner ?? false;

              debugPrint(
                "============ SharedTestRedirect Success ============",
              );
              debugPrint("→ testId: $testId");
              debugPrint("→ isOwner: $isOwner");
              debugPrint("=================================================");

              context.read<DetailsOfTestCubit>().resetSharedTestLinkState();

              if (testId == null || testId <= 0) {
                context.go(AppRouterPath.mainLayout);
                return;
              }

              if (isOwner) {
                debugPrint("→ owner test, MyTestDetailsView not ready yet");
              }

              context.go(
                AppRouterPath.detailsOfTest,
                extra: DetailsOfTestRouteArgs(testId: testId),
              );
            }

            if (state.isSharedTestLinkFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر فتح رابط الاختبار",
                type: AppValidationSnackBarType.error,
              );

              context.read<DetailsOfTestCubit>().resetSharedTestLinkState();
              context.go(AppRouterPath.mainLayout);
            }
          },
          builder: (context, state) {
            return Center(
              child: state.isSharedTestLinkLoading
                  ? const CircularProgressIndicator()
                  : CustomTextWidget(
                      "جاري فتح الاختبار...",
                      textAlign: TextAlign.center,
                    ),
            );
          },
        ),
      ),
    );
  }
}
