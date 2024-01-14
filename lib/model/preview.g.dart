// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preview _$PreviewFromJson(Map<String, dynamic> json) {
  return Preview()
    ..trip = json['trip'] == null
        ? null
        : Trip.fromJson(json['trip'] as Map<String, dynamic>)
    ..drivers = (json['drivers'] as List)
        ?.map((e) =>
            e == null ? null : PreviewItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PreviewToJson(Preview instance) => <String, dynamic>{
      'trip': instance.trip,
      'drivers': instance.drivers,
    };

PreviewItem _$PreviewItemFromJson(Map<String, dynamic> json) {
  return PreviewItem(
    driverDistance: json['driver_distance'] as String,
    driverDuration: json['driver_duration'] as String,
    favorite: json['favorite'] as bool,
    price: (json['price'] as num)?.toDouble(),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PreviewItemToJson(PreviewItem instance) =>
    <String, dynamic>{
      'driver_distance': instance.driverDistance,
      'driver_duration': instance.driverDuration,
      'price': instance.price,
      'user': instance.user,
      'favorite': instance.favorite,
    };
