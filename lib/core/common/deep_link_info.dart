import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

import '../../app/navigation/app_route.dart';
import '../../app/observers/logger.dart';
import '../../features/auth/presentation/pages/create_new_password_page.dart';
import '../ui/extensions/string_extension.dart';

abstract class DeepLinkInfo {
  void init({
    bool? isSignIn,
  });
}

class DeepLinkInfoImpl implements DeepLinkInfo {
  final AppLinks appLinks;
  final AppRouteInfo appRouteInfo;

  DeepLinkInfoImpl({
    required this.appLinks,
    required this.appRouteInfo,
  });

  @override
  void init({
    bool? isSignIn,
  }) {
    Logger.info('DeepLinkInfo init');

    appLinks.stringLinkStream.listen((data) {
      Logger.success('onAppLink: data $data');

      final dataMap = data.urlToMap;
      Logger.success('onAppLink: dataMap $dataMap');

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