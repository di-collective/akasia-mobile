import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/clinic_location_model.dart';
import '../models/clinic_model.dart';

abstract class ClinicRemoteDataSource {
  Future<List<ClinicModel>> getClinics({
    required String accessToken,
    int? page,
    int? limit,
  });
  Future<List<ClinicLocationModel>> getClinicLocations({
    required String accessToken,
    required String? clinicId,
    int? page,
    int? limit,
  });
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final AppHttpClient appHttpClient;

  ClinicRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<List<ClinicModel>> getClinics({
    required String accessToken,
    int? page,
    int? limit,
  }) async {
    try {
      Logger.info('getClinics accessToken: $accessToken');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaClinicApiUrl}/clinic",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      Logger.success('getClinics response: $response');

      final List data = (response.data?['data'] is List)
          ? (response.data?['data'] as List)
          : [];

      return data.map((clinic) {
        return ClinicModel.fromJson(clinic);
      }).toList();
    } catch (error) {
      Logger.error('getClinics error: $error');

      rethrow;
    }
  }

  @override
  Future<List<ClinicLocationModel>> getClinicLocations({
    required String accessToken,
    required String? clinicId,
    int? page,
    int? limit,
  }) async {
    try {
      Logger.info(
          'getClinicLocations accessToken: $accessToken, clinicId: $clinicId');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaClinicApiUrl}/clinic/$clinicId/location",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      Logger.success('getClinicLocations response: $response');

      final List data = (response.data?['data'] is List)
          ? (response.data?['data'] as List)
          : [];

      return data.map((clinicLocation) {
        return ClinicLocationModel.fromJson(clinicLocation);
      }).toList();
    } catch (error) {
      Logger.error('getClinicLocations error: $error');

      rethrow;
    }
  }
}

final List<Map<String, dynamic>> mockClinics = [
  {
    'id': '1',
    'name': 'Klinik 1',
  },
  {
    'id': '2',
    'name': 'Klinik 2',
  },
  {
    'id': '3',
    'name': 'Klinik 3',
  },
  {
    'id': '4',
    'name': 'Klinik 4',
  },
  {
    'id': '5',
    'name': 'Klinik 5',
  },
  {
    'id': '6',
    'name': 'Klinik 6',
  },
  {
    'id': '7',
    'name': 'Klinik 7',
  },
  {
    'id': '8',
    'name': 'Klinik 8',
  },
  {
    'id': '9',
    'name': 'Klinik 9',
  },
  {
    'id': '10',
    'name': 'Klinik 10',
  },
];

final List<Map<String, dynamic>> mockClinicLocations = [
  {
    'id': '1',
    'name': 'Lokasi 1',
  },
  {
    'id': '2',
    'name': 'Lokasi 2',
  },
  {
    'id': '3',
    'name': 'Lokasi 3',
  },
  {
    'id': '4',
    'name': 'Lokasi 4',
  },
  {
    'id': '5',
    'name': 'Lokasi 5',
  },
  {
    'id': '6',
    'name': 'Lokasi 6',
  },
  {
    'id': '7',
    'name': 'Lokasi 7',
  },
  {
    'id': '8',
    'name': 'Lokasi 8',
  },
];
