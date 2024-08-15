import 'dart:convert';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/weight_goal_model.dart';

abstract class WeightGoalRemoteDataSource {
  Future<WeightGoalModel> getWeightGoal({
    required String accessToken,
  });
  Future<WeightGoalModel> createWeightGoal({
    required String accessToken,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required String? pace,
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
        jsonDecode(response.data), // FIXME: why is response.data a string?
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
    required String? pace,
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
          "pace": pace,
        },
      );
      Logger.success('createWeightGoal response: $response');

      return WeightGoalModel.fromJson(
        jsonDecode(response.data), // FIXME: why is response.data a string?
      );
    } catch (error) {
      Logger.error('createWeightGoal error: $error');

      rethrow;
    }
  }
}
