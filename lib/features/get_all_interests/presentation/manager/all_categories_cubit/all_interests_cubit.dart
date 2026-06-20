// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
// import 'package:quiz_app_grad/features/get_all_interests/presentation/managet/all_categories_cubit/all_interests_state.dart';

// class AllInterestsCubit extends Cubit<AllInterestsState> {
//   final GetAllInterestsUseCase getAllInterestsUseCase;

//   AllInterestsCubit({
//     required this.getAllInterestsUseCase,
//   }) : super(const AllInterestsState());

//   Future<void> getAllInterests() async {
//     emit(
//       state.copyWith(
//         isLoading: true,
//         errorMessage: null,
//       ),
//     );

//     try {
//       final response = await getAllInterestsUseCase();

//       emit(
//         state.copyWith(
//           isLoading: false,
//           categories: response.categories,
//           errorMessage: null,
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isLoading: false,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }

//   void changeSearchText(String value) {
//     emit(
//       state.copyWith(
//         searchText: value,
//         errorMessage: null,
//       ),
//     );
//   }

//   void clearSearch() {
//     emit(
//       state.copyWith(
//         searchText: '',
//         errorMessage: null,
//       ),
//     );
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_state.dart';

class AllInterestsCubit extends Cubit<AllInterestsState> {
  final GetAllInterestsUseCase getAllInterestsUseCase;

  AllInterestsCubit({
    required this.getAllInterestsUseCase,
  }) : super(const AllInterestsState());

  Future<void> getAllInterests() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await getAllInterestsUseCase();

      emit(
        state.copyWith(
          isLoading: false,
          categories: response.categories,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void changeSearchText(String value) {
    emit(
      state.copyWith(
        searchText: value,
        clearErrorMessage: true,
      ),
    );
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchText: '',
        clearErrorMessage: true,
      ),
    );
  }
}