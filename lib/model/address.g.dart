// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    id: json['id'] as String,
    address: json['address'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
    order: json['order'] as int,
    alias: json['alias'] as String,
    mainAddress: json['mainAddress'] as bool,
    type: json['type'] as String,
    isFavorite: json['isFavorite'] as bool,
  )..lng = (json['lng'] as num)?.toDouble();
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'alias': instance.alias,
      'lat': instance.lat,
      'long': instance.long,
      'lng': instance.lng,
      'order': instance.order,
      'mainAddress': instance.mainAddress,
      'isFavorite': instance.isFavorite,
      'type': instance.type,
    };
