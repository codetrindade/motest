// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutePoint _$RoutePointFromJson(Map<String, dynamic> json) {
  return RoutePoint(
    id: json['id'] as String,
    address: json['address'] as String,
    crossed: json['crossed'] as int,
    order: json['order'] as int,
    coordinates: json['coordinates'] == null
        ? null
        : MySQlPoint.fromJson(json['coordinates'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RoutePointToJson(RoutePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'order': instance.order,
      'crossed': instance.crossed,
      'coordinates': instance.coordinates,
    };

MySQlPoint _$MySQlPointFromJson(Map<String, dynamic> json) {
  return MySQlPoint(
    type: json['type'] as String,
    coordinates: (json['coordinates'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
  );
}

Map<String, dynamic> _$MySQlPointToJson(MySQlPoint instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
