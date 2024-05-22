part of 'edit_information_cubit.dart';

sealed class EditInformationState extends Equatable {
  const EditInformationState();

  @override
  List<Object?> get props => [];
}

class EditInformationInitial extends EditInformationState {}

class EditInformationLoading extends EditInformationState {}

class EditInformationLoaded extends EditInformationState {}

class EditInformationError extends EditInformationState {
  final Object error;

  const EditInformationError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
