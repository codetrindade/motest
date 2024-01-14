import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'user_status.g.dart';

@JsonSerializable()
class UserStatus {
  @JsonKey(name: 'current_route_id')
  String currentRouteId;
  @JsonKey(name: 'current_route_status')
  String currentRouteStatus;

  UserStatus({this.currentRouteId, this.currentRouteStatus});

  factory UserStatus.fromJson(Map<String, dynamic> map) => _$UserStatusFromJson(map);

  Map<String, dynamic> toJson() => _$UserStatusToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
