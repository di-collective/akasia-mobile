import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/health_service.dart';

part 'health_service_state.dart';

class HealthServiceCubit extends Cubit<HealthServiceState> {
  final HealthService healthService;

  HealthServiceCubit({
    required this.healthService,
  }) : super(HealthServiceInitial()) {
    init();
  }

  Future<void> init() async {
    // check has permissions
    await hasPermissions();
  }

  Future<bool?> hasPermissions() async {
    try {
      emit(HealthServiceLoading());

      final hasPermissions = await healthService.hasPermissions;
      if (hasPermissions == true) {
        emit(HealthServiceConnected());
      } else {
        emit(HealthServiceDisconnected());
      }

      return hasPermissions;
    } catch (error) {
      emit(HealthServiceError(
        error: error,
      ));

      rethrow;
    }
  }

  Future<bool?> connect() async {
    try {
      emit(HealthServiceLoading());

      final isAuthorized = await healthService.connect();
      if (isAuthorized == true) {
        emit(HealthServiceConnected());
      } else {
        emit(HealthServiceDisconnected());
      }

      return isAuthorized;
    } catch (error) {
      emit(HealthServiceError(
        error: error,
      ));

      rethrow;
    }
  }

  Future<bool?> disconnect() async {
    try {
      emit(HealthServiceLoading());

      final isSuccess = await healthService.disconnect();

      if (isSuccess == true) {
        emit(HealthServiceDisconnected());
      }

      return isSuccess;
    } catch (error) {
      emit(HealthServiceError(
        error: error,
      ));

      rethrow;
    }
  }
}
