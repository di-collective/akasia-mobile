part of 'countdown_cubit.dart';

sealed class CountdownState extends Equatable {
  const CountdownState();

  @override
  List<Object?> get props => [];
}

final class CountdownInitial extends CountdownState {}

final class CountdownLoading extends CountdownState {
  final int? totalSeconds;
  final int? currentSeconds;

  const CountdownLoading({
    this.totalSeconds,
    this.currentSeconds,
  });

  CountdownLoading copyWith({
    int? totalSeconds,
    int? currentSeconds,
  }) {
    return CountdownLoading(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      currentSeconds: currentSeconds ?? this.currentSeconds,
    );
  }

  @override
  List<Object?> get props => [
        totalSeconds,
        currentSeconds,
      ];
}

final class CountdownStop extends CountdownState {}
