import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'countdown_state.dart';

class CountdownCubit extends Cubit<CountdownState> {
  CountdownCubit() : super(CountdownInitial());

  void startCountdown({
    required int totalSeconds,
  }) {
    emit(
      CountdownLoading(
        totalSeconds: totalSeconds,
        currentSeconds: totalSeconds,
      ),
    );

    // Start the timer
    _startTimer();
  }

  void _startTimer() {
    final currentState = state;

    if (currentState is CountdownLoading) {
      final currentSeconds = currentState.currentSeconds;

      if (currentSeconds! > 0) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _startTimer();

            updateCountdown(currentSeconds - 1);
          },
        );
      } else {
        emit(CountdownStop());
      }
    }
  }

  void updateCountdown(int currentSeconds) {
    final currentState = state;

    if (currentState is CountdownLoading) {
      emit(
        currentState.copyWith(
          currentSeconds: currentSeconds,
        ),
      );
    }
  }
}
