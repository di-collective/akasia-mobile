import 'package:akasia365mc/app/di/depedency_injection.dart';
import 'package:akasia365mc/core/ui/extensions/toast_type_parsing.dart';
import 'package:akasia365mc/core/ui/widget/dialogs/toast_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  Size get size => mediaQueryData.size;

  double get height => size.height;

  double get width => size.width;

  double get paddingTop => mediaQueryData.padding.top;

  double get paddingBottom => mediaQueryData.padding.bottom;

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
}
