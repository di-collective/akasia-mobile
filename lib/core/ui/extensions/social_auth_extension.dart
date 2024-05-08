import 'package:flutter/material.dart';

import '../../../app/config/asset_path.dart';
import 'build_context_extension.dart';

enum SocialAuth {
  apple,
  google,
}

extension SocialAuthExtension on SocialAuth {
  String get iconPath {
    switch (this) {
      case SocialAuth.apple:
        return AssetIconsPath.icApple;
      case SocialAuth.google:
        return AssetIconsPath.icGoogle;
    }
  }

  String signInLabel(BuildContext context) {
    switch (this) {
      case SocialAuth.apple:
        return context.locale.signInWithApple;
      case SocialAuth.google:
        return context.locale.signInWithGoogle;
    }
  }

  String signUpLabel(BuildContext context) {
    switch (this) {
      case SocialAuth.apple:
        return context.locale.signUpWithApple;
      case SocialAuth.google:
        return context.locale.signUpWithGoogle;
    }
  }
}
