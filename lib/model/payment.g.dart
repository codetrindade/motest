// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
    payment: json['payment'] as String,
    translated: json['translated'] as String,
  )..chosen = json['chosen'] as bool;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'payment': instance.payment,
      'translated': instance.translated,
      'chosen': instance.chosen,
    };
