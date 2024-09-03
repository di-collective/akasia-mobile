import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/utils/logger.dart';
import '../models/weight_goal_model.dart';
import '../models/weight_goal_simulation_model.dart';
import '../models/weight_history_model.dart';

abstract class WeightGoalRemoteDataSource {
  Future<WeightGoalModel> getWeightGoal({
    required String accessToken,
  });
  Future<WeightGoalModel> createWeightGoal({
    required String accessToken,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required WeightGoalPace? pace,
  });
  Future<WeightGoalSimulationModel> getSimulation({
    required String accessToken,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
  });
  Future<WeightHistoryModel> updateWeight({
    required String accessToken,
    required double? weight,
    required DateTime? date,
  });
  Future<WeightGoalModel> updateWeightGoal({
    required String accessToken,
    required String? startingDate,
    required double? startingWeight,
    required double? targetWeight,
    required WeightGoalActivityLevel? activityLevel,
    required WeightGoalPace? pace,
  });
  Future<List<WeightHistoryModel>> getWeightHistory({
    required String accessToken,
    int? page,
    int? limit,
    DateTime? fromDate,
    DateTime? toDate,
  });
}

class WeightGoalRemoteDataSourceImpl implements WeightGoalRemoteDataSource {
  final AppHttpClient appHttpClient;

  WeightGoalRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<WeightGoalModel> getWeightGoal({
    required String accessToken,
  }) async {
    try {
      Logger.info('getWeightGoal accessToken: $accessToken');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-goal",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      Logger.success('getWeightGoal response: $response');

      return WeightGoalModel.fromJson(
        response.data?['data'],
      );
    } catch (error) {
      Logger.error('getWeightGoal error: $error');

      rethrow;
    }
  }

  @override
  Future<WeightGoalModel> createWeightGoal({
    required String accessToken,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required WeightGoalPace? pace,
  }) async {
    try {
      Logger.info(
          'createWeightGoal params: accessToken $accessToken, startingWeight $startingWeight, targetWeight $targetWeight, activityLevel $activityLevel, pace $pace');

      final response = await appHttpClient.post(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-goal",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "starting_weight": startingWeight,
          "target_weight": targetWeight,
          "activity_level": activityLevel,
          "pace": pace?.titleApi,
        },
      );
      Logger.success('createWeightGoal response: $response');

      return WeightGoalModel.fromJson(
        response.data?['data'],
      );
    } catch (error) {
      Logger.error('createWeightGoal error: $error');

      rethrow;
    }
  }

  @override
  Future<WeightGoalSimulationModel> getSimulation({
    required String accessToken,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
  }) async {
    try {
      Logger.info(
          'getSimulation params: accessToken $accessToken, startingWeight $startingWeight, targetWeight $targetWeight, activityLevel $activityLevel');

      final response = await appHttpClient.post(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-goal/simulation",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "starting_weight": startingWeight,
          "target_weight": targetWeight,
          "activity_level": activityLevel,
        },
      );
      Logger.success('getSimulation response: $response');

      return WeightGoalSimulationModel.fromJson(
        response.data?['data'],
      );
    } catch (error) {
      Logger.error('getSimulation error: $error');

      rethrow;
    }
  }

  @override
  Future<WeightHistoryModel> updateWeight({
    required String accessToken,
    required double? weight,
    required DateTime? date,
  }) async {
    try {
      Logger.info(
          'updateWeight params: accessToken $accessToken, weight $weight, date $date');

      final response = await appHttpClient.put(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-history",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "weight": weight,
          "date": date?.formatDate(
            format: 'yyyy-MM-dd',
          ),
        },
      );
      Logger.success('updateWeight response: $response');

      return WeightHistoryModel.fromJson(
        response.data?['data'],
      );
    } catch (error) {
      Logger.error('updateWeight error: $error');

      rethrow;
    }
  }

  @override
  Future<WeightGoalModel> updateWeightGoal({
    required String accessToken,
    required String? startingDate,
    required double? startingWeight,
    required double? targetWeight,
    required WeightGoalActivityLevel? activityLevel,
    required WeightGoalPace? pace,
  }) async {
    try {
      Logger.info(
          'updateWeightGoal params: accessToken $accessToken, startingDate $startingDate, startingWeight $startingWeight, targetWeight $targetWeight, activityLevel $activityLevel, pace $pace');

      final response = await appHttpClient.patch(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-goal",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "starting_date": startingDate,
          "starting_weight": startingWeight,
          "target_weight": targetWeight,
          "activity_level": activityLevel?.title,
          "pace": pace?.titleApi,
        },
      );
      Logger.success('updateWeightGoal response: $response');

      return WeightGoalModel.fromJson(
        response.data?['data'],
      );
    } catch (error) {
      Logger.error('updateWeightGoal error: $error');

      rethrow;
    }
  }

  @override
  Future<List<WeightHistoryModel>> getWeightHistory({
    required String accessToken,
    int? page,
    int? limit,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      Logger.info(
          'getWeightHistory params: accessToken $accessToken, page $page, limit $limit, fromDate $fromDate, toDate $toDate');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaFitnessApiUrl}/weight-history",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          "page": page,
          "limit": limit,
          "from": fromDate?.formatShortDateApi,
          "to": toDate?.formatShortDateApi,
        },
      );
      Logger.success('getWeightHistory response: $response');

      final data = (response.data?['data'] is List)
          ? (response.data?['data'] as List)
          : [];

      return data.map((e) {
        return WeightHistoryModel.fromJson(e);
      }).toList();
    } catch (error) {
      Logger.error('getWeightHistory error: $error');

      rethrow;
    }
  }
}
