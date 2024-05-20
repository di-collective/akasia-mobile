import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../app/observers/logger.dart';
import '../ui/extensions/file_exception.dart';
import 'directory_info.dart';

abstract class ImageCompressInfo {
  Future<File> compressImage({
    required File file,
  });
}

class ImageCompressInfoImpl implements ImageCompressInfo {
  final DirectoryInfo directoryInfo;

  const ImageCompressInfoImpl({
    required this.directoryInfo,
  });

  @override
  Future<File> compressImage({
    required File file,
  }) async {
    try {
      Logger.info('compressImage file $file, size ${file.sizeInKb}');

      // create new file in documents directory
      final newFile = await directoryInfo.createNewFileInDocumentsDirectory(
        fileName: file.fileName!,
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        newFile.path,
        quality: 50,
      );
      Logger.success('compressImage result $result');
      if (result == null) {
        throw Exception('Failed to compress image');
      }

      final resultFile = File(result.path);
      Logger.success('compressImage size ${resultFile.sizeInKb}');

      return resultFile;
    } catch (error) {
      Logger.error('compressImage error $error');

      rethrow;
    }
  }
}
