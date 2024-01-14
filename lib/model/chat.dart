import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:moveme/model/chat_message.dart';
import 'package:moveme/model/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  String id;
  @JsonKey(name: 'unread_messages')
  int unreadMessages;
  @JsonKey(name: 'last_message')
  ChatMessage lastMessage;
  @JsonKey(name: 'ride_passenger_id')
  String ridePassengerId;
  @JsonKey(name: 'trip_id')
  String tripId;
  String type;
  User user;
  @JsonKey(name: 'route_id')
  String routeId;
  User driver;
  List<ChatMessage> messages = [];

  Chat({this.id, this.lastMessage, this.unreadMessages, this.ridePassengerId, this.type, this.messages});

  factory Chat.fromJson(Map<String, dynamic> map) => _$ChatFromJson(map);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}