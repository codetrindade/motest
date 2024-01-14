import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  String email;
  @JsonKey(name: 'facebookid')
  String facebookId;
  String password;
  String type = 'mobile';

  LoginData({
    this.email,
    this.facebookId,
    this.password});

  factory LoginData.fromJson(Map<String, dynamic> map) => _$LoginDataFromJson(map);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}