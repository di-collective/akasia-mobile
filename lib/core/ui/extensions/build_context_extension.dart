import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/local_picker_info.dart';
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

  Future<bool?> showErrorToast({
    required String message,
  }) async {
    try {
      return await _showToast(
        type: ToastType.error,
        message: message,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> showSuccessToast({
    required String message,
  }) async {
    try {
      return await _showToast(
        type: ToastType.success,
        message: message,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> showWarningToast({
    required String message,
  }) async {
    try {
      return await _showToast(
        type: ToastType.warning,
        message: message,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> showInfoToast({
    required String message,
  }) async {
    try {
      return await _showToast(
        type: ToastType.info,
        message: message,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> _showToast({
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

  void updateFullScreenLoading({
    String? message,
  }) {
    BlocProvider.of<FullScreenLoadingCubit>(this).update(
      message: message,
    );
  }

  void get hideFullScreenLoading {
    BlocProvider.of<FullScreenLoadingCubit>(this).hide();
  }

  ScreenHeightType get screenHeightType {
    if (height < 600) {
      return ScreenHeightType.small;
    } else if (height < 800) {
      return ScreenHeightType.medium;
    } else {
      return ScreenHeightType.large;
    }
  }

  Future<DateTime?> selectDate({
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    try {
      return await sl<LocalPickerInfo>().selectDate(
        context: this,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

enum ScreenHeightType {
  small,
  medium,
  large,
}
