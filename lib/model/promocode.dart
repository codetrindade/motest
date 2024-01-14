import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'promocode.g.dart';

@JsonSerializable()
class Promocode {
  String code;
  String discount_type;
  String type;
  String discount;
  String description;
  DateTime expire_at;

  Promocode({this.code, this.discount_type, this.discount, this.description, this.expire_at});

  factory Promocode.fromJson(Map<String, dynamic> map) => _$PromocodeFromJson(map);

  Map<String, dynamic> toJson() => _$PromocodeToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
