import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit({int initialIndex = 0})
    : super(BottomNavState(currentIndex: initialIndex));

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
