part of 'deactive_account_cubit.dart';

sealed class DeactiveAccountState extends Equatable {
  const DeactiveAccountState();

  @override
  List<Object> get props => [];
}

final class DeactiveAccountInitial extends DeactiveAccountState {}

final class DeactiveAccountLoading extends DeactiveAccountState {}

final class DeactiveAccountLoaded extends DeactiveAccountState {}

final class DeactiveAccountError extends DeactiveAccountState {
  final Object error;

  const DeactiveAccountError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
