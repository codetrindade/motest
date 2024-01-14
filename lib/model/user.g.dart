// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    name: json['name'] as String,
    photo: json['photo'] as String,
    document: json['document'] as String,
    useFacebookPhoto: json['use_facebook_photo'] as bool,
    displayMyPhone: json['displayMyPhone'] as bool,
    email: json['email'] as String,
    rating: json['rating'] as String,
    ratingQtt: json['rating_qtt'] as int,
    facebookId: json['facebookid'] as String,
    phone: json['phone'] as String,
    driver: json['driver'] == null
        ? null
        : Driver.fromJson(json['driver'] as Map<String, dynamic>),
    status: json['status'] as String,
    type: json['type'] as String,
    password: json['password'] as String,
    smsCode: json['sms_code'] as String,
    token: json['token'] as String,
    vehicle: json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'password': instance.password,
      'type': instance.type,
      'status': instance.status,
      'sms_code': instance.smsCode,
      'document': instance.document,
      'facebookid': instance.facebookId,
      'use_facebook_photo': instance.useFacebookPhoto,
      'photo': instance.photo,
      'phone': instance.phone,
      'driver': instance.driver,
      'rating': instance.rating,
      'rating_qtt': instance.ratingQtt,
      'vehicle': instance.vehicle,
      'displayMyPhone': instance.displayMyPhone,
    };
