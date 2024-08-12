import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsUseCase
    extends UseCase<List<AppointmentEntity>, NoParams> {
  final AppointmentRepository appointmentRepository;

  GetAppointmentsUseCase({
    required this.appointmentRepository,
  });

  @override
  Future<List<AppointmentEntity>> call(NoParams params) async {
    return await appointmentRepository.getAppointments();
  }
}
