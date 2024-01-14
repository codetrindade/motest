import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/driver.dart';
import 'package:moveme/model/mobile.dart';

part 'user_driver.g.dart';

@JsonSerializable()
class UserDriver {
  String id;
  String name;
  String email;
  String token;
  String password = '';
  String photo;
  String rating;

  Driver driver;

  UserDriver({this.id, this.name, this.email, this.photo, this.rating});

  factory UserDriver.fromJson(Map<String, dynamic> map) => _$UserDriverFromJson(map);

  Map<String, dynamic> toJson() => _$UserDriverToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
