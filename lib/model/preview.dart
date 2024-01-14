import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/driver.dart';
import 'package:moveme/model/trip.dart';
import 'package:moveme/model/user.dart';

part 'preview.g.dart';

@JsonSerializable()
class Preview {
  Trip trip;
  List<PreviewItem> drivers = new List(0);

  Preview();

  factory Preview.fromJson(Map<String, dynamic> map) => _$PreviewFromJson(map);

  Map<String, dynamic> toJson() => _$PreviewToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class PreviewItem {
  PreviewItem({this.driverDistance, this.driverDuration, this.favorite, this.price, this.user});

  @JsonKey(name: 'driver_distance')
  String driverDistance;
  @JsonKey(name: 'driver_duration')
  String driverDuration;
  double price;
  User user;
  bool favorite;

  @JsonKey(ignore: true)
  bool chosen = false;

  factory PreviewItem.fromJson(Map<String, dynamic> map) => _$PreviewItemFromJson(map);

  Map<String, dynamic> toJson() => _$PreviewItemToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
