import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>?> getNotifications({
    required String accessToken,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final AppHttpClient appHttpClient;

  NotificationRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<List<NotificationModel>?> getNotifications({
    required String accessToken,
  }) async {
    try {
      Logger.info('getNotifications accessToken: $accessToken');

      // TODO: Implement getNotifications
      // final result = await appHttpClient.get(
      //   url: "${EnvConfig.akasiaUserApiUrl}/notifications",
      //   headers: {
      //     'Authorization': 'Bearer $accessToken',
      //   },
      // );
      // Logger.success('getNotifications result: $result');

      // final List? data = (result.data?['data'] is List)
      //     ? (result.data?['data'] as List?)
      //     : null;

      final List? data = await Future.delayed(
        const Duration(seconds: 3),
        () => mockNotifications,
      );

      return data?.map((e) {
        return NotificationModel.fromJson(e);
      }).toList();
    } catch (error) {
      Logger.error('getNotifications error: $error');

      rethrow;
    }
  }
}

final List<Map<String, dynamic>> mockNotifications = [
  {
    "id": "1",
    "title": "Notification 1",
    "description": "Description 1",
    "date": "Feb 28, 16:20",
  },
  {
    "id": "2",
    "title": "Notification Notification Notification 2",
    "description": "Description Description Description 2",
    "date": "Feb 28, 16:20",
  },
  {
    "id": "3",
    "title": "Notification 3",
    "description":
        "Description Description Description Description Description 3",
    "date": "Feb 28, 16:20",
  }
];
