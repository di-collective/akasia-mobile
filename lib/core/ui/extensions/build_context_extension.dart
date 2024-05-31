import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/service_locator.dart';
import '../widget/dialogs/toast_info.dart';
import '../widget/loadings/cubit/full_screen_loading/full_screen_loading_cubit.dart';
import 'toast_type_extension.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  Size get size => mediaQueryData.size;

  double get height => size.height;

  double get width => size.width;

  double get paddingTop => mediaQueryData.padding.top;

  double get paddingBottom => 20;

  double get phoneHeightWihtoutSafeArea {
    return height - paddingTop - paddingBottom;
  }

  double get viewInsetsBottom => mediaQueryData.viewInsets.bottom;

  ThemeData get theme => Theme.of(this);

  AppLocalizations get locale => AppLocalizations.of(this);

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  void get closeKeyboard => FocusScope.of(this).requestFocus(FocusNode());

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  T cubit<T extends StateStreamableSource<Object>>() =>
      BlocProvider.of<T>(this);

  Future<bool?> showToast({
    required ToastType type,
    required String message,
  }) async {
    try {
      return await sl<ToastInfo>().show(
        context: this,
        type: type,
        message: message,
      );
    } catch (_) {
      rethrow;
    }
  }

  double get paddingHorizontal {
    return 16;
  }

  double get paddingVertical {
    return height * 0.05;
  }

  void showFullScreenLoading({
    String? message,
  }) {
    BlocProvider.of<FullScreenLoadingCubit>(this).show(
      message: message,
    );
  }

  void get hideFullScreenLoading {
    BlocProvider.of<FullScreenLoadingCubit>(this).hide();
  }
}
