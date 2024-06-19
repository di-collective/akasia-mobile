import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../../core/common/image_compress_info.dart';
import '../../../../../core/config/env_config.dart';
import '../../../../../core/network/http/app_http_client.dart';
import '../../../../../core/ui/extensions/file_exception.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../models/profile_model.dart';

abstract class AccountRemoteDataSource {
  Future<ProfileModel> getProfile({
    required String accessToken,
  });
  Future<String?> changeProfilePicture({
    required String accessToken,
    required File image,
    required String? userId,
  });
  Future<void> updateProfile({
    required String accessToken,
    required ProfileEntity profile,
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
  Future<ProfileModel> getProfile({
    required String accessToken,
  }) async {
    try {
      Logger.info('getProfile accessToken: $accessToken');

      final result = await appHttpClient.get(
        url: "${EnvConfig.baseAkasiaApiUrl}/profile",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      Logger.success('getProfile result: $result');

      final data = result.data?['data'];

      return ProfileModel.fromJson(data);
    } catch (error) {
      Logger.error('getProfile error: $error');

      rethrow;
    }
  }

  @override
  Future<String?> changeProfilePicture({
    required String accessToken,
    required File image,
    required String? userId,
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
      final imageMultipartFile = await MultipartFile.fromFile(
        compressedImage.path,
        filename: compressedImage.fileName,
      );
      final result = await appHttpClient.patch(
        url: "${EnvConfig.baseAkasiaApiUrl}/profile/$userId/photo",
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
        formData: FormData.fromMap({
          'file': imageMultipartFile,
        }),
      );
      Logger.success('changeProfilePicture result: $result');

      final photoUrl = result.data?['data'];
      return photoUrl;
    } catch (error) {
      Logger.error('changeProfilePicture error: $error');

      rethrow;
    }
  }

  @override
  Future<void> updateProfile({
    required String accessToken,
    required ProfileEntity profile,
  }) async {
    try {
      Logger.info('updateProfile accessToken: $accessToken, profile: $profile');

      final result = await appHttpClient.patch(
        url: "${EnvConfig.baseAkasiaApiUrl}/profile/${profile.userId}",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'age': profile.age,
          'dob': profile.dob,
          'sex': profile.sex,
          'blood_type': profile.bloodType,
          'weight': profile.weight,
          'height': profile.height,
          'activity_level': profile.activityLevel,
          'allergies': profile.allergies,
          'ec_name': profile.ecName,
          'ec_relation': profile.ecRelation,
          'ec_country_code': profile.ecCountryCode,
          'ec_phone': profile.ecPhone,
        },
      );
      Logger.success('updateProfile result: $result');
    } catch (error) {
      Logger.error('updateProfile error: $error');

      rethrow;
    }
  }
}
