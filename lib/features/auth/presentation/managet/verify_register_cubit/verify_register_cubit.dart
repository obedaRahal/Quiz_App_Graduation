import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_state.dart';

class VerifyRegisterCubit extends Cubit<VerifyRegisterState>{
Timer? _timer;
 VerifyRegisterCubit() : super(const VerifyRegisterState()) {
    debugPrint("============ VerifyRegisterCubit INIT ============");
    debugPrint("VerifyRegisterCubit created for email: ");
    _startTimer();
  }
  void _startTimer() {
    debugPrint("VerifyRegisterCubit._startTimer() -> reset to 300s");
    _timer?.cancel();
    if (isClosed) return;
    emit(state.copyWith(remainingSeconds: 300));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        debugPrint("VerifyRegisterCubit timer finished (0s left)");
        timer.cancel();
        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: 0));
        if (isClosed) return;
      } else {
        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
        if (isClosed) return;
      }
    });
  }
}