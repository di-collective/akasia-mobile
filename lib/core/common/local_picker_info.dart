import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../utils/logger.dart';

abstract class LocalPickerInfo {
  Future<File?> selectImage({
    required ImageSource imageSource,
  });
}

class LocalPickerInfoImpl implements LocalPickerInfo {
  final ImagePicker imagePicker;

  const LocalPickerInfoImpl({
    required this.imagePicker,
  });

  @override
  Future<File?> selectImage({
    required ImageSource imageSource,
  }) async {
    try {
      Logger.info('selectImage imageSource: $imageSource');

      // TODO: Check permission
      // TODO: Request permission again

      final result = await imagePicker.pickImage(
        source: imageSource,
      );
      Logger.success('selectImage result: $result');

      if (result == null) {
        return null;
      }

      return File(result.path);
    } catch (error) {
      Logger.error('selectImage error: $error');

      rethrow;
    }
  }
}
