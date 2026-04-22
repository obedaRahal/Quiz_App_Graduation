import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  // 🔵 خاص بالـ PageView
  void changePage(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  // 🟢 خاص بالفلاتر
  void changeFilter(int index) {
    emit(state.copyWith(filterIndex: index));
  }
}