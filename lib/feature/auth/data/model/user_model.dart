import '../../domain/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String token;
  final String refreshToken;

  UserModel({
    required this.token,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  User toUser() => User(token: token, refreshToken: refreshToken);
}
