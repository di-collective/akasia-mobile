import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/config/env_config.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/common/image_compress_info.dart';
import '../../../../../core/network/http/app_http_client.dart';
import '../../../../../core/ui/extensions/file_exception.dart';

abstract class AccountRemoteDataSource {
  Future<void> changeProfilePicture({
    required String accessToken,
    required File image,
  });
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final AppHttpClient appHttpClient;
  final ImageCompressInfo imageCompressInfo;

  const AccountRemoteDataSourceImpl({
    required this.appHttpClient,
    required this.imageCompressInfo,
  });

  @override
  Future<void> changeProfilePicture({
    required String accessToken,
    required File image,
  }) async {
    try {
      Logger.info(
          'changeProfilePicture accessToken: $accessToken, image: $image');

      File? compressedImage;
      // Compress image
      if (image.sizeInKb > 2000) {
        // if image size more than 2MB
        compressedImage = await imageCompressInfo.compressImage(
          file: image,
        );
      }

      // set default image
      compressedImage ??= image;

      // post image
      final result = await appHttpClient.post(
        url: "${EnvConfig.baseAkasiaApiUrl}/profile-picture",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        formData: FormData.fromMap({
          "image": await MultipartFile.fromFile(
            compressedImage.path,
            filename: compressedImage.fileName,
            contentType: MediaType(
              'image',
              compressedImage.extension,
            ),
          ),
        }),
      );
      Logger.success('changeProfilePicture result: $result');
    } catch (error) {
      Logger.error('changeProfilePicture error: $error');

      rethrow;
    }
  }
}
