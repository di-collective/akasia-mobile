import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_steps_state.dart';

class DailyStepsCubit extends Cubit<DailyStepsState> {
  DailyStepsCubit() : super(DailyStepsInitial());
}
