import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'response_server.g.dart';


@JsonSerializable()
class ResponseServer {
  String message;

  ResponseServer({this.message});

  factory ResponseServer.fromJson(Map<String, dynamic> map) => _$ResponseServerFromJson(map);

  Map<String, dynamic> toJson() => _$ResponseServerToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}