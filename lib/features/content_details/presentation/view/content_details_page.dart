import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const ContentDetailsPage({
    super.key,
    required this.contentId,
  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_)=>sl<OtherContentDetailsCubit>()
      ..getContentDetails(contentId),

      child: BlocConsumer<
          OtherContentDetailsCubit,
          OtherContentDetailsState>(
listenWhen: (previous, current) =>
    previous.successMessage != current.successMessage ||
    previous.showOpenDownloadedFileDialog !=
        current.showOpenDownloadedFileDialog,

  listener: (context, state) {
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
              context.read<OtherContentDetailsCubit>().clearDownloadDialog();
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OtherContentDetailsCubit>().clearDownloadDialog();

              // هون لاحقاً منضيف فتح الملف
              // OpenFilex.open(filePath);
            },
            child: const Text('نعم'),
          ),
        ],
      );
    },
  );

  return;
}
    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          state.successMessage!,
        ),

        backgroundColor: Colors.green,

      ),

    );

    context
        .read<OtherContentDetailsCubit>()
        .clearSuccessMessage();

  },
        builder: (context,state){

          if(state.status==
              OtherContentDetailsStatus.loading){

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          }

          if(state.status==
              OtherContentDetailsStatus.failure){

            return Scaffold(

              body: Center(

                child: CustomTextWidget(
                  state.errorMessage ??
                  'حدث خطأ',
                ),

              ),

            );

          }

          if(state.details==null){

            return const SizedBox();

          }

          return ContentDetailsScaffold(

            data: state.details!.toUi(),

          );

        },

      ),

    );

  }
}