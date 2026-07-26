import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'bottom_nav_state.dart';

class BottomNavCubit extends SafeCubit<BottomNavState> {
  BottomNavCubit({int initialIndex = 0})
    : super(BottomNavState(currentIndex: initialIndex));

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
