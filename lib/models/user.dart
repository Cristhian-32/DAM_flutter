import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  String name;
  String email;
  String password;

  UserModel({required this.name, required this.email, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class TokenModel {
  bool status;
  String message;
  String accessToken;
  String tokenType;
  String expiresAt;
  List<String> roles;
  ProfileModel profile;
  //String name;

  TokenModel(
      {required this.status,
      required this.message,
      required this.accessToken,
      required this.tokenType,
      required this.expiresAt,
      required this.roles,
      required this.profile});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      status: json['status'],
      message: json['message'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresAt: json['expires_at'],
      roles: List<String>.from(json['roles']),
      profile: ProfileModel.fromJson(json['profile']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt,
      'roles': roles,
      'profile': profile.toJson(),
    };
  }
}

@JsonSerializable()
class ProfileModel {
  String name;
  String email;

  ProfileModel({
    required this.name,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': name,
      'email': email,
    };
  }
}
