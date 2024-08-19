import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/ui/extensions/app_exception_extension.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/entities/weight_goal_entity.dart';
import '../../domain/entities/weight_history_entity.dart';
import '../../domain/entities/weight_goal_simulation_entity.dart';
import '../../domain/repositories/weight_goal_repository.dart';
import '../datasources/weight_goal_remote_datasource.dart';

class WeightGoalRepositoryImpl extends WeightGoalRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;
  final WeightGoalRemoteDataSource weightGoalRemoteDataSource;

  WeightGoalRepositoryImpl({
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.weightGoalRemoteDataSource,
  });

  @override
  Future<WeightGoalEntity> getWeightGoal() async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return weightGoalRemoteDataSource.getWeightGoal(
          accessToken: accessToken,
        );
      } on AuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<WeightGoalEntity> createWeightGoal({
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required String? pace,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return weightGoalRemoteDataSource.createWeightGoal(
          accessToken: accessToken,
          startingWeight: startingWeight,
          targetWeight: targetWeight,
          activityLevel: activityLevel,
          pace: pace,
        );
      } on AuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<WeightGoalSimulationEntity> getSimulation({
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return await weightGoalRemoteDataSource.getSimulation(
          accessToken: accessToken,
          startingWeight: startingWeight,
          targetWeight: targetWeight,
          activityLevel: activityLevel,
        );
      } on AuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<WeightHistoryEntity> updateWeight({
    required double? weight,
    required DateTime? date,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return await weightGoalRemoteDataSource.updateWeight(
          accessToken: accessToken,
          weight: weight,
          date: date,
        );
      } on AuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }
}
