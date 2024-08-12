import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../entities/clinic_entity.dart';
import '../entities/clinic_location_entity.dart';
import '../repositories/appointment_repository.dart';

class CreateEventUseCase
    extends UseCase<AppointmentEntity, CreateEventUseCaseParams> {
  final AppointmentRepository appointmentRepository;

  CreateEventUseCase({
    required this.appointmentRepository,
  });

  @override
  Future<AppointmentEntity> call(CreateEventUseCaseParams params) {
    return appointmentRepository.createEvent(
      clinic: params.clinic,
      location: params.location,
      eventStatus: params.eventStatus,
      startTime: params.startTime,
      eventType: params.eventType,
    );
  }
}

class CreateEventUseCaseParams {
  final ClinicEntity? clinic;
  final ClinicLocationEntity? location;
  final EventStatus? eventStatus;
  final DateTime? startTime;
  final EventType? eventType;

  CreateEventUseCaseParams({
    required this.clinic,
    required this.location,
    required this.eventStatus,
    required this.startTime,
    required this.eventType,
  });
}
