part of 'my_schedules_cubit.dart';

sealed class MySchedulesState extends Equatable {
  const MySchedulesState();

  @override
  List<Object> get props => [];
}

final class MySchedulesInitial extends MySchedulesState {}

final class MySchedulesLoading extends MySchedulesState {}

final class MySchedulesLoaded extends MySchedulesState {
  final List schedules;

  const MySchedulesLoaded({
    required this.schedules,
  });

  @override
  List<Object> get props => [schedules];
}

final class MySchedulesError extends MySchedulesState {
  final Object error;

  const MySchedulesError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
