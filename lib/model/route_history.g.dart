// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteHistory _$RouteHistoryFromJson(Map<String, dynamic> json) {
  return RouteHistory()
    ..id = json['id'] as String
    ..status = json['status'] as String
    ..payment = json['payment'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..distance = (json['distance'] as num)?.toDouble()
    ..durationEstimate = json['duration_estimate'] as int
    ..ratingDriver = (json['rating_driver'] as num)?.toDouble()
    ..ratingDriverObservation = json['rating_driver_observation'] as String
    ..ratingUser = (json['rating_user'] as num)?.toDouble()
    ..ratingUserObservation = json['rating_user_observation'] as String
    ..ratingVehicle = (json['rating_vehicle'] as num)?.toDouble()
    ..ratingVehicleObservation = json['rating_vehicle_observation'] as String
    ..createdAt = json['created_at'] as String
    ..driverId = json['driverId'] as String
    ..isDriverFavorite = json['is_driver_favorite'] as bool
    ..points = (json['points'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..driver = json['driver'] == null
        ? null
        : User.fromJson(json['driver'] as Map<String, dynamic>)
    ..vehicle = json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RouteHistoryToJson(RouteHistory instance) =>
    <String, dynamic>{
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
      'rating_vehicle': instance.ratingVehicle,
      'rating_vehicle_observation': instance.ratingVehicleObservation,
      'created_at': instance.createdAt,
      'driverId': instance.driverId,
      'is_driver_favorite': instance.isDriverFavorite,
      'points': instance.points,
      'driver': instance.driver,
      'vehicle': instance.vehicle,
    };
