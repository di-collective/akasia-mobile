import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app/di/depedency_injection.dart';
import '../widget/dialogs/toast_info.dart';
import 'theme_data_extension.dart';
import 'toast_type_parsing.dart';

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
    return width * 0.05;
  }

  double get paddingVertical {
    return height * 0.05;
  }

  void selectCountryCode({
    required Function(Country) onSelect,
  }) {
    final textTheme = theme.appTextTheme;
    final colorScheme = theme.appColorScheme;

    showCountryPicker(
      context: this,
      showPhoneCode: true,
      onSelect: onSelect,
      favorite: [
        'ID',
      ],
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        textStyle: textTheme.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        searchTextStyle: textTheme.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        inputDecoration: InputDecoration(
          hintText: locale.startTypingToSearch,
          hintStyle: textTheme.bodyLarge.copyWith(
            color: colorScheme.onSurfaceBright,
          ),
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.fromLTRB(
            12,
            18.5,
            12,
            20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colorScheme.surfaceDim,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colorScheme.primaryContainer,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
