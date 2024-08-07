import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/env_config.dart';
import '../../../domain/entities/clinic_entity.dart';
import '../../../domain/usecases/get_clinics_usecase.dart';

part 'clinics_state.dart';

class ClinicsCubit extends Cubit<ClinicsState> {
  final GetClinicsUseCase getClinicsUseCase;

  ClinicsCubit({
    required this.getClinicsUseCase,
  }) : super(ClinicsInitial()) {
    limit = EnvConfig.getDataLimit;
  }

  late int limit;

  Future<void> getClinics() async {
    try {
      emit(ClinicsLoading());

      // TODO: use pagination
      final clinics = await getClinicsUseCase(GetClinicsUseCaseParams());

      emit(ClinicsLoaded(
        clinics: clinics,
      ));
    } catch (error) {
      emit(ClinicsError(error: error));

      rethrow;
    }
  }
}
