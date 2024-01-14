// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promocode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promocode _$PromocodeFromJson(Map<String, dynamic> json) {
  return Promocode(
    code: json['code'] as String,
    discount_type: json['discount_type'] as String,
    discount: json['discount'] as String,
    description: json['description'] as String,
    expire_at: json['expire_at'] == null
        ? null
        : DateTime.parse(json['expire_at'] as String),
  )..type = json['type'] as String;
}

Map<String, dynamic> _$PromocodeToJson(Promocode instance) => <String, dynamic>{
      'code': instance.code,
      'discount_type': instance.discount_type,
      'type': instance.type,
      'discount': instance.discount,
      'description': instance.description,
      'expire_at': instance.expire_at?.toIso8601String(),
    };
