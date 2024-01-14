import 'dart:convert';

class PushMessage {
  String title;
  String body;
  String type;
  String id;
  bool isBackground;

  PushMessage({this.title, this.body, this.type, this.id, this.isBackground});

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['title'] = title;
    map['body'] = body;
    map['type'] = type;
    map['id'] = id;
    return map;
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

  factory PushMessage.toPush(dynamic data) {

    return PushMessage(
        title: data['notification']['title'] as String,
        body: data['notification']['body'] as String,
        type: data['data']['type'] as String,
        id: data['data']['id'] as String
    );
  }

  factory PushMessage.toNotification(dynamic data) {

    return PushMessage(
        title: data['title'] as String,
        body: data['body'] as String,
        type: data['type'] as String,
        id: data['id'] as String
    );
  }

  factory PushMessage.toBackground(dynamic data) {

    return PushMessage(
        title: data['aps']['alert']['title'] as String,
        body: data['aps']['alert']['body'] as String,
        type: data['type'] as String,
        id: data['id'] as String
    );
  }

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    return PushMessage(
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        id: json['id'] as String);
  }
}
