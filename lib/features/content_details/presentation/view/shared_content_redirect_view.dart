import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_state.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';

class SharedContentRedirectView extends StatelessWidget {
  final String slug;

  const SharedContentRedirectView({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OtherContentDetailsCubit, OtherContentDetailsState>(
          listenWhen: (previous, current) =>
              previous.sharedContentLinkStatus !=
              current.sharedContentLinkStatus,
          listener: (context, state) {
            if (state.isSharedContentLinkSuccess) {
              final materialId = state.sharedMaterialId;
              final isOwner = state.sharedContentIsOwner ?? false;

              debugPrint('============ Shared Content Redirect ============');
              debugPrint('→ materialId: $materialId');
              debugPrint('→ isOwner: $isOwner');
              debugPrint('=================================================');

              context
                  .read<OtherContentDetailsCubit>()
                  .resetSharedContentLinkState();

              if (materialId == null || materialId <= 0) {
                context.go(AppRouterPath.mainLayout);
                return;
              }

              context.goNamed(
                AppRouterName.otherContentDetails,
                extra: ContentDetailsRouteArgs(
                  contentId: materialId,
                  isMyContent: isOwner,
                ),
              );
              return;
            }

            if (state.isSharedContentLinkFailure) {
              showValidationTopSnackBar(
                context,
                title: 'تعذر فتح المحتوى',
                message:
                    state.errorMessage ?? 'رابط المحتوى غير صالح أو غير متاح',
                type: AppValidationSnackBarType.error,
              );

              context
                  .read<OtherContentDetailsCubit>()
                  .resetSharedContentLinkState();
              context.go(AppRouterPath.mainLayout);
            }
          },
          builder: (context, state) {
            return Center(
              child: state.isSharedContentLinkLoading
                  ? const CircularProgressIndicator()
                  : const CustomTextWidget(
                      'جاري فتح المحتوى...',
                      textAlign: TextAlign.center,
                    ),
            );
          },
        ),
      ),
    );
  }
}
