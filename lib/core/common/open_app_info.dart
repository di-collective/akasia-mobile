import 'package:url_launcher/url_launcher.dart';

import '../../app/observers/logger.dart';
import '../ui/extensions/string_extension.dart';

abstract class OpenAppInfo {
  Future<bool> openLink({
    required String? url,
  });
}

class OpenAppInfoImpl implements OpenAppInfo {
  const OpenAppInfoImpl();

  @override
  Future<bool> openLink({
    required String? url,
  }) async {
    try {
      Logger.info('openLink url: $url');

      if (url == null) {
        throw 'Url is null';
      }

      final uri = url.toUri;
      if (uri == null) {
        throw "Invalid url";
      }

      if (!await canLaunchUrl(uri)) {
        throw 'Could not launch $uri';
      }

      final result = await launchUrl(
        uri,
      );
      Logger.success('openLink result: $result');

      return result;
    } catch (error) {
      Logger.error('openLink error: $error');

      rethrow;
    }
  }
}
