import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> map) => _$TokenFromJson(map);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}