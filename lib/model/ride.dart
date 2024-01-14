import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  String id;
  double price;
  String date;
  String time;
  int reservations;
  @JsonKey(name: 'auto_confirm')
  bool autoConfirm = false;
  double distance;
  @JsonKey(name: 'duration')
  double duration;
  List<Address> points;
  bool back;
  @JsonKey(name: 'distance_start')
  double distanceStart;
  @JsonKey(name: 'distance_end')
  double distanceEnd;
  @JsonKey(name: 'start_address')
  String startAddress;
  @JsonKey(name: 'end_address')
  String endAddress;
  String polyline;
  Ride destiny;
  double lat;
  double long;
  @JsonKey(name: 'driver_name')
  String driverName;
  String photo;
  @JsonKey(name: 'start_time')
  String startTime;
  @JsonKey(name: 'end_time')
  String endTime;

  @JsonKey(name: 'price_id')
  String priceId;
  String payment;

  String status;
  @JsonKey(name: 'ride_passenger_id')
  String ridePassengerId;

  Ride({
    this.distance,
    this.duration,
    this.polyline,
    this.back = false});

  factory Ride.fromJson(Map<String, dynamic> map) => _$RideFromJson(map);

  Map<String, dynamic> toJson() => _$RideToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
