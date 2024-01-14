import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/user.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  String id;
  String message;
  String owner;
  bool seen;
  @JsonKey(name: 'created_at')
  DateTime createdAt;

  ChatMessage({this.id, this.message, this.owner, this.createdAt});

  factory ChatMessage.fromJson(Map<String, dynamic> map) => _$ChatMessageFromJson(map);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}