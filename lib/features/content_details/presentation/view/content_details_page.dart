import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_state.dart';
import 'package:quiz_app_grad/features/content_details/presentation/mapper/content_details_mapper.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_scaffold.dart';
import 'package:share_plus/share_plus.dart';



class ContentDetailsPage extends StatelessWidget {
  final int contentId;
  final bool isMyContent;
  final bool isMyPublicContent;

  const ContentDetailsPage({
    super.key,
    required this.contentId,
    this.isMyContent = false,
    this.isMyPublicContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<OtherContentDetailsCubit>();

        if (isMyContent) {
          cubit.getMyContentDetails(contentId, isPublic: isMyPublicContent);
        } else {
          cubit.getContentDetails(contentId);
        }

        return cubit;
      },

      child: BlocConsumer<OtherContentDetailsCubit, OtherContentDetailsState>(
        listenWhen: (previous, current) =>
            previous.shareLinkStatus != current.shareLinkStatus ||
            (previous.successMessage != current.successMessage &&
                current.successMessage != null) ||
            (current.status != OtherContentDetailsStatus.failure &&
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null) ||
            previous.showOpenDownloadedFileDialog !=
                current.showOpenDownloadedFileDialog,

        listener: (context, state) async {
          if (state.isShareLinkSuccess) {
            final shareUrl = state.shareUrl?.trim() ?? '';
            context.read<OtherContentDetailsCubit>().resetShareLinkState();

            if (shareUrl.isEmpty) {
              showValidationTopSnackBar(
                context,
                title: 'تعذر مشاركة المحتوى',
                message: 'لم يتم استلام رابط مشاركة صالح',
                type: AppValidationSnackBarType.error,
              );
              return;
            }

            await SharePlus.instance.share(
              ShareParams(text: shareUrl, subject: 'مشاركة محتوى من Nerd'),
            );
            return;
          }

          if (state.isShareLinkFailure) {
            final message =
                state.errorMessage?.trim() ?? 'تعذر جلب رابط مشاركة المحتوى';

            context.read<OtherContentDetailsCubit>().resetShareLinkState();

            showValidationTopSnackBar(
              context,
              title: 'تعذر مشاركة المحتوى',
              message: message,
              type: AppValidationSnackBarType.error,
            );
            context.read<OtherContentDetailsCubit>().clearErrorMessage();
            return;
          }

          final errorMessage = state.errorMessage?.trim();

          if (state.status != OtherContentDetailsStatus.failure &&
              errorMessage != null &&
              errorMessage.isNotEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'تعذر إكمال العملية',
              message: errorMessage,
              type: AppValidationSnackBarType.error,
            );
            context.read<OtherContentDetailsCubit>().clearErrorMessage();
            return;
          }

          if (state.isDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'تم حذف المحتوى بنجاح'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.maybePop(context);
            return;
          }

          if (state.showOpenDownloadedFileDialog) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('تم التحميل بنجاح'),
                  content: const Text('هل تريد فتح الملف؟'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context
                            .read<OtherContentDetailsCubit>()
                            .clearDownloadDialog();
                      },
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final filePath = state.downloadedFilePath;

                        Navigator.pop(context);

                        context
                            .read<OtherContentDetailsCubit>()
                            .clearDownloadDialog();

                        if (filePath == null || filePath.isEmpty) return;

                        final result = await OpenFilex.open(filePath);

                        if (!context.mounted ||
                            result.type == ResultType.done) {
                          return;
                        }

                        showValidationTopSnackBar(
                          context,
                          title: 'تعذر فتح الملف',
                          message: result.message.trim().isNotEmpty
                              ? result.message
                              : 'لا يوجد تطبيق مناسب لفتح هذا النوع من الملفات',
                          type: AppValidationSnackBarType.error,
                        );
                      },
                      child: const Text('نعم'),
                    ),
                  ],
                );
              },
            );

            return;
          }
          final message = state.successMessage;

          if (message == null || message.trim().isEmpty) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );

          context.read<OtherContentDetailsCubit>().clearSuccessMessage();
        },
        builder: (context, state) {
          if (state.status == OtherContentDetailsStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == OtherContentDetailsStatus.failure) {
            return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off_rounded,
                          size: 54,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        CustomTextWidget(
                          state.errorMessage ?? 'تعذر تحميل تفاصيل المحتوى',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () {
                            final cubit = context
                                .read<OtherContentDetailsCubit>();
                            if (isMyContent) {
                              cubit.getMyContentDetails(
                                contentId,
                                isPublic: isMyPublicContent,
                              );
                            } else {
                              cubit.getContentDetails(contentId);
                            }
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (!isMyContent && state.details == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (isMyContent && state.myDetails == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return ContentDetailsScaffold(
            data: isMyContent
                ? state.myDetails!.toUi(isPublicOverride: isMyPublicContent)
                : state.details!.toUi(),
          );
        },
      ),
    );
  }
}
