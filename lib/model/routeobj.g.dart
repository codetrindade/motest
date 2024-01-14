// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routeobj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteObj _$RouteObjFromJson(Map<String, dynamic> json) {
  return RouteObj(
    id: json['id'] as String,
    status: json['status'] as String,
    driver: json['driver'] == null
        ? null
        : User.fromJson(json['driver'] as Map<String, dynamic>),
    createdAt: json['created_at'] as String,
    destination: json['destination'] as String,
    distance: (json['distance'] as num)?.toDouble(),
    distanceDriverToMe: (json['distance_driver_to_me'] as num)?.toDouble(),
    driverLat: (json['driverLat'] as num)?.toDouble(),
    driverLong: (json['driverLong'] as num)?.toDouble(),
    durationDriverToMe: (json['duration_driver_to_me'] as num)?.toDouble(),
    durationEstimate: (json['duration_estimate'] as num)?.toDouble(),
    routePolyline: json['routePolyline'] as String,
    vehicle: json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    points: (json['points'] as List)
        ?.map((e) =>
            e == null ? null : RoutePoint.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..payment = json['payment'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..ratingDriver = json['rating_driver'] as String
    ..ratingDriverObservation = json['rating_driver_observation'] as String
    ..ratingUser = json['rating_user'] as String
    ..ratingUserObservation = json['rating_user_observation'] as String
    ..travelledDistance = (json['travelled_distance'] as num)?.toDouble() ?? 0
    ..origin = json['origin'] as String
    ..polylineDriverToMe = json['polyline_driver_to_me'] as String;
}

Map<String, dynamic> _$RouteObjToJson(RouteObj instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'payment': instance.payment,
      'price': instance.price,
      'distance': instance.distance,
      'duration_estimate': instance.durationEstimate,
      'rating_driver': instance.ratingDriver,
      'rating_driver_observation': instance.ratingDriverObservation,
      'rating_user': instance.ratingUser,
      'rating_user_observation': instance.ratingUserObservation,
      'created_at': instance.createdAt,
      'driver': instance.driver,
      'travelled_distance': instance.travelledDistance,
      'origin': instance.origin,
      'destination': instance.destination,
      'polyline_driver_to_me': instance.polylineDriverToMe,
      'duration_driver_to_me': instance.durationDriverToMe,
      'distance_driver_to_me': instance.distanceDriverToMe,
      'routePolyline': instance.routePolyline,
      'vehicle': instance.vehicle,
      'driverLat': instance.driverLat,
      'driverLong': instance.driverLong,
      'points': instance.points,
    };
