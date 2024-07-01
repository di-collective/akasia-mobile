import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/clinic_location_entity.dart';
import '../../../domain/usecases/get_clinic_locations_usecase.dart';

part 'clinic_locations_state.dart';

class ClinicLocationsCubit extends Cubit<ClinicLocationsState> {
  final GetClinicLocationsUseCase getClinicLocationsUseCase;

  ClinicLocationsCubit({
    required this.getClinicLocationsUseCase,
  }) : super(ClinicLocationsInitial());

  Future<void> getClinicLocations({
    required String? clinicId,
  }) async {
    try {
      emit(ClinicLocationsLoading());

      final clinicLocations = await getClinicLocationsUseCase(
        GetClinicLocationsUseCaseParams(
          clinicId: clinicId,
        ),
      );

      emit(ClinicLocationsLoaded(clinicLocations: clinicLocations));
    } catch (error) {
      emit(ClinicLocationsError(error: error));

      rethrow;
    }
  }
}
