import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class CreateEventUseCase extends UseCase<void, CreateEventUseCaseParams> {
  final AppointmentRepository appointmentRepository;

  CreateEventUseCase({
    required this.appointmentRepository,
  });

  @override
  Future<void> call(CreateEventUseCaseParams params) {
    return appointmentRepository.createEvent(
      locationId: params.locationId,
      eventStatus: params.eventStatus,
      startTime: params.startTime,
      eventType: params.eventType,
    );
  }
}

class CreateEventUseCaseParams {
  final String? locationId;
  final EventStatus? eventStatus;
  final DateTime? startTime;
  final EventType? eventType;

  CreateEventUseCaseParams({
    required this.locationId,
    required this.eventStatus,
    required this.startTime,
    required this.eventType,
  });
}
