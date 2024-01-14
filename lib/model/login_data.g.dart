// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return LoginData(
    email: json['email'] as String,
    facebookId: json['facebookid'] as String,
    password: json['password'] as String,
  )..type = json['type'] as String;
}

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'email': instance.email,
      'facebookid': instance.facebookId,
      'password': instance.password,
      'type': instance.type,
    };
