// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatus _$UserStatusFromJson(Map<String, dynamic> json) {
  return UserStatus(
    currentRouteId: json['current_route_id'] as String,
    currentRouteStatus: json['current_route_status'] as String,
  );
}

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String, dynamic>{
      'current_route_id': instance.currentRouteId,
      'current_route_status': instance.currentRouteStatus,
    };
