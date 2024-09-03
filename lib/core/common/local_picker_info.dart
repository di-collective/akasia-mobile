import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/logger.dart';

abstract class LocalPickerInfo {
  Future<File?> selectImage({
    required ImageSource imageSource,
  });
  Future<DateTime?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
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

  @override
  Future<DateTime?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    try {
      Logger.info('selectDate initialDate: $initialDate');

      final result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
      Logger.success('selectDate result: $result');

      return result;
    } catch (error) {
      Logger.error('selectDate error: $error');

      rethrow;
    }
  }
}
