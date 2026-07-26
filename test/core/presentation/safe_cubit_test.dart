import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';

class DelayedCubit extends SafeCubit<int> {
  DelayedCubit() : super(0);

  Future<void> emitAfter(Future<void> operation) async {
    await operation;
    emit(1);
  }
}

void main() {
  test('ignores an asynchronous emit that completes after close', () async {
    final operation = Completer<void>();
    final cubit = DelayedCubit();
    final pendingEmit = cubit.emitAfter(operation.future);

    await cubit.close();
    operation.complete();

    await expectLater(pendingEmit, completes);
    expect(cubit.state, 0);
  });

  test('continues emitting normally while open', () async {
    final cubit = DelayedCubit();

    await cubit.emitAfter(Future<void>.value());

    expect(cubit.state, 1);
    await cubit.close();
  });

  test('all feature Cubits inherit from SafeCubit', () {
    final unsafeFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => file.readAsStringSync().contains('extends Cubit<'))
        .map((file) => file.path)
        .toList();

    expect(unsafeFiles, isEmpty);
  });
}
