import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @override
  void emit(State state) {
    if (isClosed) {
      if (kDebugMode) {
        debugPrint('⚠ ignored emit after close in $runtimeType');
      }
      return;
    }

    super.emit(state);
  }
}
