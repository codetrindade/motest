// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewBody _$PreviewBodyFromJson(Map<String, dynamic> json) {
  return PreviewBody(
    payment: json['payment'] as String,
    gender: json['gender'] as String,
    driverId: json['driver_id'] as String,
    payments: (json['payments'] as List)?.map((e) => e as String)?.toList(),
    points: (json['points'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    cardId: json['card_id'] as String,
    promocode: json['promocode'] as String,
  );
}

Map<String, dynamic> _$PreviewBodyToJson(PreviewBody instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'points': instance.points,
      'payment': instance.payment,
      'gender': instance.gender,
      'card_id': instance.cardId,
      'promocode': instance.promocode,
      'driver_id': instance.driverId,
    };
