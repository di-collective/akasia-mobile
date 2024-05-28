import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_level_state.dart';

class ActivityLevelCubit extends Cubit<ActivityLevelState> {
  ActivityLevelCubit() : super(ActivityLevelInitial());
}
