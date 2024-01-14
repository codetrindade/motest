import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'pusher_data.g.dart';

@JsonSerializable()
class PusherData {
  String command;
  ReceivedData data;
  double distance;
  @JsonKey(name: 'duration_estimate')
  double durationEstimate;
  @JsonKey(name: 'new_polyline')
  String newPolyline;

  PusherData();
  factory PusherData.fromJson(Map<String, dynamic> map) => _$PusherDataFromJson(map);

  Map<String, dynamic> toJson() => _$PusherDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class ReceivedData {
  @JsonKey(name: 'route_id')
  String routeId;
  String status;
  @JsonKey(name: 'driver_id')
  String driverId;
  String lat;
  String long;
  @JsonKey(name: 'new_polyline')
  String newPolyline;
  @JsonKey(name: 'travelled_distance')
  String travelledDistance;
  double duration;
  double distance;

  ReceivedData();

  factory ReceivedData.fromJson(Map<String, dynamic> map) => _$ReceivedDataFromJson(map);

  Map<String, dynamic> toJson() => _$ReceivedDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}