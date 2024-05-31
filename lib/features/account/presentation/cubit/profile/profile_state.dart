part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded({
    required this.profile,
  });

  @override
  List<Object> get props => [profile];
}

final class ProfileError extends ProfileState {
  final Object error;

  const ProfileError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
