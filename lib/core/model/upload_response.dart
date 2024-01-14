import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse {
  String message;
  dynamic data;

  UploadResponse({this.message, this.data});

  factory UploadResponse.fromJson(Map<String, dynamic> map) => _$UploadResponseFromJson(map);

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}