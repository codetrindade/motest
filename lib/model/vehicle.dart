import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/vehicle_document.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  String id;
  @JsonKey(name: 'license_plate')
  String licensePlate;
  String model;
  String color;
  String type;
  int year;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  String obs;
  @JsonKey(name: 'admin_status')
  String adminStatus;
  String status;
  String rating;
  @JsonKey(name: 'rating_qtt')
  int ratingQtt;

  List<VehicleDocument> documents;
  VehicleDocument photo;

  @JsonKey(ignore: true)
  bool chosen = false;

  Vehicle(
      {this.id,
      this.licensePlate,
      this.model,
      this.color,
      this.type,
      this.year,
      this.createdAt,
      this.updatedAt,
      this.obs,
      this.adminStatus,
      this.documents,
      this.status,
      this.photo,
      this.ratingQtt,
      this.rating});

  factory Vehicle.fromJson(Map<String, dynamic> map) => _$VehicleFromJson(map);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
