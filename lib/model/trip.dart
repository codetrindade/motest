import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/address.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  String distance;
  @JsonKey(name: 'duration_estimate')
  String durationEstimate;
  String polyline;

  Trip({
    this.distance,
    this.durationEstimate,
    this.polyline});

  factory Trip.fromJson(Map<String, dynamic> map) => _$TripFromJson(map);

  Map<String, dynamic> toJson() => _$TripToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}