// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/notification/presentation/manager/notification/notification_cubit.dart';
// import 'package:quiz_app_grad/features/notification/presentation/manager/notification/notification_state.dart';
// import 'package:quiz_app_grad/features/notification/presentation/widgets/notification_card.dart';

// class NotificationBody extends StatefulWidget {
//   const NotificationBody({super.key});

//   @override
//   State<NotificationBody> createState() => _NotificationBodyState();
// }

// class _NotificationBodyState extends State<NotificationBody> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (!_scrollController.hasClients) return;

//     final position = _scrollController.position;

//     if (position.maxScrollExtent <= 0) return;

//     if (position.pixels >= position.maxScrollExtent * 0.8) {
//       context.read<NotificationCubit>().fetchMoreIfNeeded();
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.w(0.03),
//             vertical: SizeConfig.h(0.015),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('الإشعارات'),

//               IconButton(
//                 onPressed: () {
//                   context.read<NotificationCubit>().refresh();
//                 },
//                 icon: const Icon(Icons.refresh),
//               ),
//             ],
//           ),
//         ),

//         Expanded(
//           child: BlocBuilder<NotificationCubit, NotificationState>(
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state.hasError && state.notifications.isEmpty) {
//                 return _NotificationFailureBody(
//                   message: state.errorMessage ?? 'تعذر جلب الإشعارات',
//                   onRetry: () {
//                     context.read<NotificationCubit>().fetchInitial();
//                   },
//                 );
//               }

//               if (state.notifications.isEmpty) {
//                 return RefreshIndicator(
//                   onRefresh: () {
//                     return context.read<NotificationCubit>().refresh();
//                   },
//                   child: ListView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     children: [
//                       SizedBox(height: SizeConfig.h(0.3)),
//                       const Center(child: Text('لا توجد إشعارات حالياً')),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: () {
//                   return context.read<NotificationCubit>().refresh();
//                 },
//                 child: ListView.separated(
//                   controller: _scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.w(0.03),
//                     vertical: SizeConfig.h(0.01),
//                   ),

//                   itemCount:
//                       state.notifications.length +
//                       (state.isLoadingMore ? 1 : 0),

//                   separatorBuilder: (_, index) {
//                     if (index >= state.notifications.length - 1) {
//                       return const SizedBox.shrink();
//                     }

//                     return SizedBox(height: SizeConfig.h(0.012));
//                   },

//                   itemBuilder: (context, index) {
//                     if (index >= state.notifications.length) {
//                       return Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: SizeConfig.h(0.018),
//                         ),
//                         child: const Center(child: CircularProgressIndicator()),
//                       );
//                     }

//                     final notification = state.notifications[index];

//                     return NotificationCard(notification: notification,
//                     navigateToPage: () {
//                       debugPrint("go to page");
//                     },
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _NotificationFailureBody extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _NotificationFailureBody({
//     required this.message,
//     required this.onRetry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(SizeConfig.w(0.05)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(message, textAlign: TextAlign.center),

//             SizedBox(height: SizeConfig.h(0.02)),

//             TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
//           ],
//         ),
//       ),
//     );
//   }
// }
