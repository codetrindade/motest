import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/vehicle.dart';

import 'driver.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String email;
  String token;
  String password = '';
  String type = 'mobile';
  String status;
  @JsonKey(name: 'sms_code')
  String smsCode;
  String document;
  @JsonKey(name: 'facebookid')
  String facebookId;
  @JsonKey(name: 'use_facebook_photo')
  bool useFacebookPhoto;
  String photo;
  String phone;
  Driver driver;
  String rating;
  @JsonKey(name: 'rating_qtt')
  int ratingQtt;
  Vehicle vehicle;

  bool displayMyPhone;

  User(
      {this.id,
      this.name,
      this.photo,
      this.document,
      this.useFacebookPhoto,
      this.displayMyPhone,
      this.email,
      this.rating,
      this.ratingQtt,
      this.facebookId,
      this.phone,
      this.driver,
      this.status,
      this.type,
      this.password,
      this.smsCode,
      this.token,
      this.vehicle});

  factory User.fromJson(Map<String, dynamic> map) => _$UserFromJson(map);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
