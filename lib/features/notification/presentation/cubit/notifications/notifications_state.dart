part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity>? notifications;

  const NotificationsLoaded({
    this.notifications,
  });

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsError extends NotificationsState {
  final Object error;

  const NotificationsError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
