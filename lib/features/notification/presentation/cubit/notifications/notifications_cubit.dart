import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
  }) : super(NotificationsInitial());

  Future<void> getNotifications() async {
    try {
      emit(NotificationsLoading());

      final result = await getNotificationsUseCase(NoParams());

      emit(NotificationsLoaded(
        notifications: result,
      ));
    } catch (error) {
      emit(NotificationsError(
        error: error,
      ));
    }
  }

  Future<void> refreshNotifications() async {
    try {
      final result = await getNotificationsUseCase(NoParams());

      emit(NotificationsLoaded(
        notifications: result,
      ));
    } catch (error) {
      if (state is! NotificationsLoaded) {
        // if the state is not loaded, then emit error
        emit(NotificationsError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
