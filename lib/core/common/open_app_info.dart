import 'package:url_launcher/url_launcher.dart';

import '../ui/extensions/string_extension.dart';

abstract class OpenAppInfo {
  Future<void> openLink({
    required String? url,
  });
}

class OpenAppInfoImpl implements OpenAppInfo {
  const OpenAppInfoImpl();

  @override
  Future<void> openLink({
    required String? url,
  }) async {
    try {
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

      await launchUrl(
        uri,
      );
    } catch (error) {
      rethrow;
    }
  }
}
