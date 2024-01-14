// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) {
  return Trip(
    distance: json['distance'] as String,
    durationEstimate: json['duration_estimate'] as String,
    polyline: json['polyline'] as String,
  );
}

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration_estimate': instance.durationEstimate,
      'polyline': instance.polyline,
    };
