part of 'change_phone_number_cubit.dart';

sealed class ChangePhoneNumberState extends Equatable {
  const ChangePhoneNumberState();

  @override
  List<Object> get props => [];
}

final class ChangePhoneNumberInitial extends ChangePhoneNumberState {}

final class ChangePhoneNumberLoading extends ChangePhoneNumberState {}

final class ChangePhoneNumberLoaded extends ChangePhoneNumberState {}

final class ChangePhoneNumberError extends ChangePhoneNumberState {
  final Object error;

  const ChangePhoneNumberError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
