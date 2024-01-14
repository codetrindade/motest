// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardData _$CardDataFromJson(Map<String, dynamic> json) {
  return CardData()
    ..id = json['id'] as String
    ..brand = json['brand'] as String
    ..cardId = json['card_id'] as String
    ..cardNumber = json['card_number'] as String
    ..holderName = json['holder_name'] as String
    ..favorite = json['favorite'] as bool
    ..cardValidate = json['card_validate'] as String
    ..cardToken = json['card_token'] as String
    ..zipCode = json['zipcode'] as String
    ..neighborhood = json['neighborhood'] as String
    ..street = json['street'] as String
    ..complement = json['complement'] as String
    ..streetNumber = json['street_number'] as String
    ..city = json['city'] as String
    ..state = json['state'] as String
    ..document = json['document'] as String;
}

Map<String, dynamic> _$CardDataToJson(CardData instance) => <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'card_id': instance.cardId,
      'card_number': instance.cardNumber,
      'holder_name': instance.holderName,
      'favorite': instance.favorite,
      'card_validate': instance.cardValidate,
      'card_token': instance.cardToken,
      'zipcode': instance.zipCode,
      'neighborhood': instance.neighborhood,
      'street': instance.street,
      'complement': instance.complement,
      'street_number': instance.streetNumber,
      'city': instance.city,
      'state': instance.state,
      'document': instance.document,
    };
