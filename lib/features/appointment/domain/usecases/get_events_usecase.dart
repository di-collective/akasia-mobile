import '../../../../core/usecases/usecase.dart';
import '../entities/calendar_appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetEventsUseCase
    extends UseCase<CalendarAppointmentEntity, GetEventsUseCaseParams> {
  final AppointmentRepository appointmentRepository;

  GetEventsUseCase({
    required this.appointmentRepository,
  });

  @override
  Future<CalendarAppointmentEntity> call(GetEventsUseCaseParams params) async {
    return await appointmentRepository.getEvents(
      locationId: params.locationId,
      startTime: params.startTime,
      endTime: params.endTime,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetEventsUseCaseParams {
  final String? locationId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? page;
  final int? limit;

  GetEventsUseCaseParams({
    required this.locationId,
    required this.startTime,
    required this.endTime,
    this.page,
    this.limit,
  });
}
