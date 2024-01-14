// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PusherData _$PusherDataFromJson(Map<String, dynamic> json) {
  return PusherData()
    ..command = json['command'] as String
    ..data = json['data'] == null
        ? null
        : ReceivedData.fromJson(json['data'] as Map<String, dynamic>)
    ..distance = (json['distance'] as num)?.toDouble()
    ..durationEstimate = (json['duration_estimate'] as num)?.toDouble()
    ..newPolyline = json['new_polyline'] as String;
}

Map<String, dynamic> _$PusherDataToJson(PusherData instance) =>
    <String, dynamic>{
      'command': instance.command,
      'data': instance.data,
      'distance': instance.distance,
      'duration_estimate': instance.durationEstimate,
      'new_polyline': instance.newPolyline,
    };

ReceivedData _$ReceivedDataFromJson(Map<String, dynamic> json) {
  return ReceivedData()
    ..routeId = json['route_id'] as String
    ..status = json['status'] as String
    ..driverId = json['driver_id'] as String
    ..lat = json['lat'] as String
    ..long = json['long'] as String
    ..newPolyline = json['new_polyline'] as String
    ..travelledDistance = json['travelled_distance'] as String
    ..duration = (json['duration'] as num)?.toDouble()
    ..distance = (json['distance'] as num)?.toDouble();
}

Map<String, dynamic> _$ReceivedDataToJson(ReceivedData instance) =>
    <String, dynamic>{
      'route_id': instance.routeId,
      'status': instance.status,
      'driver_id': instance.driverId,
      'lat': instance.lat,
      'long': instance.long,
      'new_polyline': instance.newPolyline,
      'travelled_distance': instance.travelledDistance,
      'duration': instance.duration,
      'distance': instance.distance,
    };
