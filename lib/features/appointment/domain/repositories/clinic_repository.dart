import '../entities/clinic_entity.dart';
import '../entities/clinic_location_entity.dart';

abstract class ClinicRepository {
  Future<List<ClinicEntity>> getClinics({
    int? page,
    int? limit,
  });
  Future<List<ClinicLocationEntity>> getClinicLocations({
    required String? clinicId,
  });
}
