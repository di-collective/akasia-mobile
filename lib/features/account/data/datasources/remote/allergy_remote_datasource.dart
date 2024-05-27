import '../../../../../app/config/allery_config.dart';
import '../../../../../app/observers/logger.dart';
import '../../../../../core/network/http/app_http_client.dart';
import '../../models/allergy_model.dart';

abstract class AllergyRemoteDataSource {
  Future<List<AllergyModel>> getAllergies({
    required String accessToken,
  });
}

class AllergyRemoteDataSourceImpl implements AllergyRemoteDataSource {
  final AppHttpClient appHttpClient;

  const AllergyRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<List<AllergyModel>> getAllergies({
    required String accessToken,
  }) async {
    try {
      Logger.info('getAllergies accessToken: $accessToken');

      // TODO: Connect API
      // final result = await appHttpClient.get(
      //   url: "${EnvConfig.baseAkasiaApiUrl}/allergies",
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      // Logger.info('getAllergies result: ${result.data}');
      // final List data = (result.data is List) ? result.data : [];

      // return data.map((e) {
      //   return AllergyModel.fromJson(e);
      // }).toList();

      final result = await Future.delayed(
        const Duration(seconds: 2),
        () => mockAllergies,
      );
      Logger.info('getAllergies result: $result');

      return result;
    } catch (error) {
      Logger.error('getAllergies error: $error');

      rethrow;
    }
  }
}

final List<AllergyModel> mockAllergies = [
  AllergyConfig.allAllergies.first,
  AllergyConfig.allAllergies.last,
];
