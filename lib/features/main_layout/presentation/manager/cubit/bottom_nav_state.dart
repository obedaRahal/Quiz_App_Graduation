import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable {
  final int currentIndex;
  final bool isLoading;

  const BottomNavState({
    this.currentIndex = 0,
    this.isLoading = false,
  });

  BottomNavState copyWith({
    int? currentIndex,
    bool? isLoading,
  }) {
    return BottomNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [currentIndex, isLoading];
}