import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_route_info.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../routes/app_route.dart';
import '../ui/extensions/string_extension.dart';
import '../utils/logger.dart';

abstract class DeepLinkInfo {
  void init();
}

class DeepLinkInfoImpl implements DeepLinkInfo {
  final AppLinks appLinks;
  final AppRouteInfo appRouteInfo;

  DeepLinkInfoImpl({
    required this.appLinks,
    required this.appRouteInfo,
  });

  @override
  void init() {
    Logger.info('DeepLinkInfo init');

    appLinks.stringLinkStream.listen((data) {
      Logger.success('DeepLinkInfo: data $data');

      final dataMap = data.urlToMap;
      Logger.success('DeepLinkInfo: dataMap $dataMap');

      final path = dataMap['path'];
      if (path is String && path.isNotEmpty) {
        final query = dataMap['query'];

        switch (path) {
          case '/forgot-password':
            // go to create new password page
            appRouteInfo.navigatorKey.currentContext?.goNamed(
              AppRoute.createNewPassword.name,
              extra: CreateNewPasswordPageParams(
                resetToken: query['reset-token'],
                userId: query['uid'],
              ),
            );
            break;
        }
      }
    });
  }
}
