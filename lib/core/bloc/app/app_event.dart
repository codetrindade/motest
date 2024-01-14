import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/core/model/push_message.dart';
import 'package:moveme/model/user.dart';

class AppNewMessageEvent {
  PushMessage pushMessage;

  AppNewMessageEvent(this.pushMessage);
}

class CreateOrOpenNewChatEvent {
  String type;
  String id;

  CreateOrOpenNewChatEvent(this.type, this.id);
}

class UserChangedEvent {
  User user;

  UserChangedEvent({this.user});
}

class AppLoginEvent {
  User user;

  AppLoginEvent(this.user);
}

class AppLogoffEvent {
  AppLogoffEvent();
}

class UnauthenticatedEvent {
  UnauthenticatedEvent();
}

class RouteFinishedEvent {
  String id;

  RouteFinishedEvent({this.id});
}

class ChangeStateEvent {
  AppStateEnum state;
  ChangeStateEvent(this.state);
}