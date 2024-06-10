import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase
    extends UseCase<List<NotificationEntity>?, NoParams> {
  final NotificationRepository notificationRepository;

  GetNotificationsUseCase({
    required this.notificationRepository,
  });

  @override
  Future<List<NotificationEntity>?> call(NoParams params) async {
    return await notificationRepository.getNotifications();
  }
}
