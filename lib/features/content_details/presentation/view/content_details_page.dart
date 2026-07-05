import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_state.dart';
import 'package:quiz_app_grad/features/content_details/presentation/mapper/content_details_mapper.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_scaffold.dart';

// class ContentDetailsPage extends StatelessWidget {
//   const ContentDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ContentDetailsScaffold(
//       data: ContentDetailsDemoData.imagesContent,
//     );

//     // للتجربة بحالة الملف:
//     // return ContentDetailsScaffold(
//     //   data: ContentDetailsDemoData.fileContent,
//     // );
//   }
// }
class ContentDetailsPage extends StatelessWidget {
  final int contentId;
  final bool isMyContent;

  const ContentDetailsPage({
    super.key,
    required this.contentId,
    this.isMyContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<OtherContentDetailsCubit>();

        if (isMyContent) {
          cubit.getMyContentDetails(contentId);
        } else {
          cubit.getContentDetails(contentId);
        }

        return cubit;
      },

      child: BlocConsumer<OtherContentDetailsCubit, OtherContentDetailsState>(
        listenWhen: (previous, current) =>
            (previous.successMessage != current.successMessage &&
                current.successMessage != null) ||
            previous.showOpenDownloadedFileDialog !=
                current.showOpenDownloadedFileDialog,

        listener: (context, state) {
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

                        await OpenFilex.open(filePath);
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
              body: Center(
                child: CustomTextWidget(state.errorMessage ?? 'حدث خطأ'),
              ),
            );
          }

          if (!isMyContent && state.details == null) {
            return const SizedBox();
          }

          if (isMyContent && state.myDetails == null) {
            return const SizedBox();
          }

          return ContentDetailsScaffold(
            data: isMyContent ? state.myDetails!.toUi() : state.details!.toUi(),
          );
        },
      ),
    );
  }
}
