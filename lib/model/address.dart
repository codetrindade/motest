import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String id;
  String address;
  String alias;
  double lat;
  double long;
  double lng;
  int order;
  bool mainAddress;
  bool isFavorite;
  String type;

  Address(
      {this.id,
      this.address,
      this.lat,
      this.long,
      this.order,
      this.alias,
      this.mainAddress = false,
      this.type,
      this.isFavorite = false});

  factory Address.fromJson(Map<String, dynamic> map) => _$AddressFromJson(map);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
