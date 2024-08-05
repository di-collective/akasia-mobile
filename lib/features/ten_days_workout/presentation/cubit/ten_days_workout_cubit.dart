import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ten_days_workout_state.dart';

class TenDaysWorkoutCubit extends Cubit<TenDaysWorkoutState> {
  TenDaysWorkoutCubit() : super(TenDaysWorkoutInitial());
}
