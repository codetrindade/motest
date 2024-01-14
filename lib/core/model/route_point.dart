import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'route_point.g.dart';

@JsonSerializable()
class RoutePoint {
  String id;
  String address;
  int order;
  int crossed;
  MySQlPoint coordinates;

  RoutePoint({this.id, this.address, this.crossed, this.order, this.coordinates});

  factory RoutePoint.fromJson(Map<String, dynamic> map) => _$RoutePointFromJson(map);

  Map<String, dynamic> toJson() => _$RoutePointToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class MySQlPoint {
  String type;
  List<double> coordinates;

  MySQlPoint({this.type, this.coordinates});

  factory MySQlPoint.fromJson(Map<String, dynamic> map) => _$MySQlPointFromJson(map);

  Map<String, dynamic> toJson() => _$MySQlPointToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
