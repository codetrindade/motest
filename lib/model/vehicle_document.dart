import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_document.g.dart';

@JsonSerializable()
class VehicleDocument {
  String id;
  String status;
  String type;
  @JsonKey(name: 'vehicle_id')
  String vehicleId;
  String file;
  String obs;
  @JsonKey(name: 'created_at')
  String createdAt;

  VehicleDocument(
      {this.id, this.status, this.obs, this.createdAt, this.file, this.type, this.vehicleId});

  factory VehicleDocument.fromJson(Map<String, dynamic> map) => _$VehicleDocumentFromJson(map);

  Map<String, dynamic> toJson() => _$VehicleDocumentToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
