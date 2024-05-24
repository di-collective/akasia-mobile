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

      final result = await Future.delayed(
        const Duration(seconds: 2),
        () => mockAllergies,
      );
      Logger.info('getAllergies result: $result');
      final List data = result;

      return data.map((e) {
        return AllergyModel.fromJson(e);
      }).toList();
    } catch (error) {
      Logger.error('getAllergies error: $error');

      rethrow;
    }
  }
}

final List mockAllergies = [
  {
    "id": "1",
    "allergy": "Allergy 1",
  },
  {
    "id": "2",
    "allergy": "Allergy 2",
  },
  {
    "id": "3",
    "allergy": "Allergy 3",
  },
  {
    "id": "4",
    "allergy": "Allergy 4",
  },
  {
    "id": "5",
    "allergy": "Allergy 5",
  },
  {
    "id": "6",
    "allergy": "Allergy 6",
  },
];
