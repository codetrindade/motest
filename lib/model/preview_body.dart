import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/address.dart';

part 'preview_body.g.dart';

@JsonSerializable()
class PreviewBody {
  List<String> payments = [];
  List<Address> points;
  String payment;
  String gender;
  @JsonKey(name: 'card_id')
  String cardId;
  String promocode;

  @JsonKey(name: 'driver_id')
  String driverId;

  PreviewBody({this.payment, this.gender, this.driverId, this.payments, this.points, this.cardId, this.promocode});

  factory PreviewBody.fromJson(Map<String, dynamic> map) => _$PreviewBodyFromJson(map);

  Map<String, dynamic> toJson() => _$PreviewBodyToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}