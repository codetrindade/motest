
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'mobile.g.dart';

@JsonSerializable()
class Mobile {
  String phone;
  @JsonKey(name: 'facebookid')
  String facebookId = '';
  String status;
  String photo;
  String cpf;

  Mobile({
    this.facebookId,
    this.phone,
    this.status,
    this.photo,
    this.cpf});

  factory Mobile.fromJson(Map<String, dynamic> map) => _$MobileFromJson(map);

  Map<String, dynamic> toJson() => _$MobileToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}