import '../../../../../core/utils/logger.dart';
import '../../../../../core/network/http/app_http_client.dart';
import '../../models/emergency_contact_model.dart';

abstract class EmergencyContactRemoteDataSource {
  Future<EmergencyContactModel> getEmergencyContact({
    required String accessToken,
  });
  Future<void> editEmergencyContact({
    required String accessToken,
    required EmergencyContactModel emergencyContact,
  });
}

class EmergencyContactRemoteDataSourceImpl
    implements EmergencyContactRemoteDataSource {
  final AppHttpClient appHttpClient;

  EmergencyContactRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<EmergencyContactModel> getEmergencyContact({
    required String accessToken,
  }) async {
    try {
      Logger.info('getEmergencyContact accessToken: $accessToken');

      // TODO: Connect API
      // final result = await appHttpClient.get(
      //   url: "${EnvConfig.baseAkasiaApiUrl}/emergency-contact",
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      // Logger.info('getEmergencyContact result: ${result.data}');

      // return EmergencyContactModel.fromJson(result.data);

      final result = await Future.delayed(
        const Duration(seconds: 2),
        () => mockEmergenContact,
      );
      Logger.info('getEmergencyContact result: $result');

      return result;
    } catch (error) {
      Logger.error('getEmergencyContact error: $error');

      rethrow;
    }
  }

  @override
  Future<void> editEmergencyContact({
    required String accessToken,
    required EmergencyContactModel emergencyContact,
  }) async {
    try {
      Logger.info(
          'getEmergencyContact accessToken: $accessToken, emergencyContact: $emergencyContact');

      // TODO: Connect API
      // final result = await appHttpClient.post(
      //   url: "${EnvConfig.baseAkasiaApiUrl}/emergency-contact",
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      // Logger.info('editEmergencyContact result: ${result.data}');

      // return EmergencyContactModel.fromJson(result.data);

      final result = await Future.delayed(
        const Duration(seconds: 2),
      );
      Logger.info('editEmergencyContact result: $result');
    } catch (error) {
      Logger.error('editEmergencyContact error: $error');

      rethrow;
    }
  }
}

const mockEmergenContact = EmergencyContactModel(
  relationship: 'Wife',
  name: 'Jane Doe',
  countryCode: '62',
  phoneNumber: '81234567890',
);
