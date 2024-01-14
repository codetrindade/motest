// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDocument _$VehicleDocumentFromJson(Map<String, dynamic> json) {
  return VehicleDocument(
    id: json['id'] as String,
    status: json['status'] as String,
    obs: json['obs'] as String,
    createdAt: json['created_at'] as String,
    file: json['file'] as String,
    type: json['type'] as String,
    vehicleId: json['vehicle_id'] as String,
  );
}

Map<String, dynamic> _$VehicleDocumentToJson(VehicleDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'type': instance.type,
      'vehicle_id': instance.vehicleId,
      'file': instance.file,
      'obs': instance.obs,
      'created_at': instance.createdAt,
    };
