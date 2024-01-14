import 'package:flutter/material.dart';

class NavigationManager {
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  void goBack({dynamic param}) {
    return navigatorKey.currentState.pop(param);
  }

  Future<void> goBackUntil() {
    return navigatorKey.currentState.pushNamedAndRemoveUntil('/splash', ModalRoute.withName(''));
  }
}