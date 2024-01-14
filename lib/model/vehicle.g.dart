// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'] as String,
    licensePlate: json['license_plate'] as String,
    model: json['model'] as String,
    color: json['color'] as String,
    type: json['type'] as String,
    year: json['year'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    obs: json['obs'] as String,
    adminStatus: json['admin_status'] as String,
    documents: (json['documents'] as List)
        ?.map((e) => e == null
            ? null
            : VehicleDocument.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: json['status'] as String,
    photo: json['photo'] == null
        ? null
        : VehicleDocument.fromJson(json['photo'] as Map<String, dynamic>),
    ratingQtt: json['rating_qtt'] as int,
    rating: json['rating'] as String,
  );
}

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'license_plate': instance.licensePlate,
      'model': instance.model,
      'color': instance.color,
      'type': instance.type,
      'year': instance.year,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'obs': instance.obs,
      'admin_status': instance.adminStatus,
      'status': instance.status,
      'rating': instance.rating,
      'rating_qtt': instance.ratingQtt,
      'documents': instance.documents,
      'photo': instance.photo,
    };
