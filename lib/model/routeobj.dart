import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/core/model/route_point.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/model/vehicle.dart';

import 'driver.dart';

part 'routeobj.g.dart';

@JsonSerializable()
class RouteObj {
  String id;
  String status;
  String payment;
  double price;
  double distance;
  @JsonKey(name: 'duration_estimate')
  double durationEstimate;
  @JsonKey(name: 'rating_driver')
  String ratingDriver;
  @JsonKey(name: 'rating_driver_observation')
  String ratingDriverObservation;
  @JsonKey(name: 'rating_user')
  String ratingUser;
  @JsonKey(name: 'rating_user_observation')
  String ratingUserObservation;
  @JsonKey(name: 'created_at')
  String createdAt;

  User driver;

  @JsonKey(name: 'travelled_distance', defaultValue: 0, nullable: true)
  double travelledDistance;

  String origin;
  String destination;

  @JsonKey(name: 'polyline_driver_to_me')
  String polylineDriverToMe;
  @JsonKey(name: 'duration_driver_to_me')
  double durationDriverToMe;
  @JsonKey(name: 'distance_driver_to_me')
  double distanceDriverToMe;

  @JsonKey(name: 'routePolyline')
  String routePolyline;
  Vehicle vehicle;
  double driverLat;
  double driverLong;
  List<RoutePoint> points;

  @JsonKey(ignore: true)
  CameraPosition initialPosition;
  @JsonKey(ignore: true)
  Set<Marker> marks = Set<Marker>();
  @JsonKey(ignore: true)
  List<LatLng> listPoints = List<LatLng>();

  RouteObj(
      {this.id,
      this.status,
      this.driver,
      this.createdAt,
      this.destination,
      this.distance,
      this.distanceDriverToMe,
      this.driverLat,
      this.driverLong,
      this.durationDriverToMe,
      this.durationEstimate,
      this.routePolyline,
      this.vehicle,
      this.points});

  factory RouteObj.fromJson(Map<String, dynamic> map) => _$RouteObjFromJson(map);

  Map<String, dynamic> toJson() => _$RouteObjToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
