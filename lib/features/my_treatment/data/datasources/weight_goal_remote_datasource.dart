import 'dart:convert';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/weight_goal_model.dart';

abstract class WeightGoalRemoteDataSource {
  Future<WeightGoalModel> getWeightGoal({
    required String accessToken,
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
}
