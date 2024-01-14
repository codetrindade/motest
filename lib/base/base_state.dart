import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_view.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/util/util.dart';

abstract class BaseState<T extends StatefulWidget> extends State<StatefulWidget> implements BaseView {
  BaseState() : super();

  @override
  void onUnauthenticated() {
    Util.showMessage(context, 'Sessão expirada', 'Por favor efetue o login novamente');
    eventBus.fire(UnauthenticatedEvent());
    //this.onLogout();
  }

//  void onLogout() {
//    AppState().clearStorageData();
//    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
//  }

  Future<bool> getAuthenticated() async {
    var data = await Util.getPreference('TOKEN');
    return (data != null);
  }

  void onError(String message) {
    Util.showMessage(context, 'Erro', message);
  }
}
