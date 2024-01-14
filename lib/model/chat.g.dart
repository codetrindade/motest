// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
    id: json['id'] as String,
    lastMessage: json['last_message'] == null
        ? null
        : ChatMessage.fromJson(json['last_message'] as Map<String, dynamic>),
    unreadMessages: json['unread_messages'] as int,
    ridePassengerId: json['ride_passenger_id'] as String,
    type: json['type'] as String,
    messages: (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : ChatMessage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..tripId = json['trip_id'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..routeId = json['route_id'] as String
    ..driver = json['driver'] == null
        ? null
        : User.fromJson(json['driver'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'unread_messages': instance.unreadMessages,
      'last_message': instance.lastMessage,
      'ride_passenger_id': instance.ridePassengerId,
      'trip_id': instance.tripId,
      'type': instance.type,
      'user': instance.user,
      'route_id': instance.routeId,
      'driver': instance.driver,
      'messages': instance.messages,
    };
