part of 'fill_personal_information_cubit.dart';

sealed class FillPersonalInformationState extends Equatable {
  const FillPersonalInformationState();

  @override
  List<Object> get props => [];
}

final class FillPersonalInformationInitial
    extends FillPersonalInformationState {}

final class FillPersonalInformationLoading
    extends FillPersonalInformationState {}

final class FillPersonalInformationLoaded
    extends FillPersonalInformationState {}

final class FillPersonalInformationError extends FillPersonalInformationState {
  final Object error;

  const FillPersonalInformationError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
