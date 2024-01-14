// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDriver _$UserDriverFromJson(Map<String, dynamic> json) {
  return UserDriver(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photo: json['photo'] as String,
    rating: json['rating'] as String,
  )
    ..token = json['token'] as String
    ..password = json['password'] as String
    ..driver = json['driver'] == null
        ? null
        : Driver.fromJson(json['driver'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserDriverToJson(UserDriver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'password': instance.password,
      'photo': instance.photo,
      'rating': instance.rating,
      'driver': instance.driver,
    };
