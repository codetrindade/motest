import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/model/vehicle.dart';

import 'address.dart';

part 'route_history.g.dart';

@JsonSerializable()
class RouteHistory {
  String id;
  String status;
  String payment;
  double price;
  double distance;
  @JsonKey(name: 'duration_estimate')
  int durationEstimate;
  @JsonKey(name: 'rating_driver')
  double ratingDriver;
  @JsonKey(name: 'rating_driver_observation')
  String ratingDriverObservation;
  @JsonKey(name: 'rating_user')
  double ratingUser;
  @JsonKey(name: 'rating_user_observation')
  String ratingUserObservation;
  @JsonKey(name: 'rating_vehicle')
  double ratingVehicle;
  @JsonKey(name: 'rating_vehicle_observation')
  String ratingVehicleObservation;
  @JsonKey(name: 'created_at')
  String createdAt;
  String driverId;
  @JsonKey(name: 'is_driver_favorite')
  bool isDriverFavorite;

  List<Address> points;
  User driver;
  Vehicle vehicle;

  RouteHistory();

  factory RouteHistory.fromJson(Map<String, dynamic> map) => _$RouteHistoryFromJson(map);

  Map<String, dynamic> toJson() => _$RouteHistoryToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}