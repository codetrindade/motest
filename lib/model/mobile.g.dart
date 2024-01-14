// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mobile _$MobileFromJson(Map<String, dynamic> json) {
  return Mobile(
    facebookId: json['facebookid'] as String,
    phone: json['phone'] as String,
    status: json['status'] as String,
    photo: json['photo'] as String,
    cpf: json['cpf'] as String,
  );
}

Map<String, dynamic> _$MobileToJson(Mobile instance) => <String, dynamic>{
      'phone': instance.phone,
      'facebookid': instance.facebookId,
      'status': instance.status,
      'photo': instance.photo,
      'cpf': instance.cpf,
    };
