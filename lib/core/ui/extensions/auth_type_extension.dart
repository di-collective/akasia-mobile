import 'package:flutter/material.dart';

import '../../../app/config/asset_path.dart';
import 'build_context_extension.dart';

enum AuthType {
  emailPassword,
  apple,
  google,
}

extension AuthTypeExtension on AuthType {
  String? get iconPath {
    switch (this) {
      case AuthType.emailPassword:
        return null;
      case AuthType.apple:
        return AssetIconsPath.icApple;
      case AuthType.google:
        return AssetIconsPath.icGoogle;
    }
  }

  String? signInLabel(BuildContext context) {
    switch (this) {
      case AuthType.emailPassword:
        return null;
      case AuthType.apple:
        return context.locale.signInWithApple;
      case AuthType.google:
        return context.locale.signInWithGoogle;
    }
  }

  String? signUpLabel(BuildContext context) {
    switch (this) {
      case AuthType.emailPassword:
        return null;
      case AuthType.apple:
        return context.locale.signUpWithApple;
      case AuthType.google:
        return context.locale.signUpWithGoogle;
    }
  }
}
