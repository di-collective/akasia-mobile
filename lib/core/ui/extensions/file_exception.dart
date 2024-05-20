import 'dart:io';

extension FileException on File? {
  String? get fileName {
    if (this == null || this?.path == null) {
      return null;
    }

    return this!.path.split('/').last;
  }

  String get extension {
    if (this == null || this?.path == null) {
      return '';
    }

    return this!.path.split('.').last;
  }

  int get sizeInKb {
    if (this == null || this?.path == null) {
      return 0;
    }

    return this!.lengthSync() ~/ 1024;
  }
}
