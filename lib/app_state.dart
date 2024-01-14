import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/presenter/app_state_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/settings.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/login/login_main_page.dart';
import 'package:moveme/view/login/sms_page.dart';
import 'package:moveme/view/main/main_page.dart';
import 'package:flutter/services.dart';
import 'package:pusher/pusher.dart';

import 'base/base_view.dart';
import 'model/address.dart';
import 'model/routeobj.dart';

class AppState {
  //static User user;
  static int gpsOk;
  static LocationData pos;
  static bool isPusherActive = false;
  static int devicePixelRatio;

  RouteObj activeRoute = new RouteObj();

  CameraPosition initialPosition;
  AppStateListener listener;

  //AppStatePresenter _presenter;
  //  List<Address> addresses = new List<Address>();

  static Address myAddressNow = Address(order: 0);
  Pusher pusher;
  StreamController<PusherResult> streamController;
  StreamController<String> appStateError = StreamController<String>.broadcast();
  StreamController<double> gpsStreamController;

  static final AppState _instance = new AppState.internal();

  AppState.internal();

  factory AppState() {
    return _instance;
  }

  disposeGpsStream() {
    gpsStreamController.close();
  }

  initPusher(String token) {
    pusher = new Pusher();
    pusher.init(Settings.pusherAuth, token, Settings.pusherCluster, Settings.pusherKey);
    pusher.callback = sendPusherEvent;
    isPusherActive = true;
  }

  sendPusherEvent(PusherResult result) {
    if (streamController != null) streamController.add(result);
  }

  subscribeToAChannelPusher(String driverUserId, String event) {
    pusher.subscribeToAChannel(Settings.pusherDriverChannel + driverUserId, true);
    pusher.bindOnAChannel(Settings.pusherDriverChannel + driverUserId, event, true);
  }

//  initAddresses() {
//    _presenter = new AppStatePresenter(this);
//    _presenter.getAddressList();
//  }

//  Future<Widget> initialize() async {
//    Widget _defaultHome = new LoginMainPage();
//    var token = await Util.getPreference('TOKEN');
//    var data = await Util.getPreference('USER');
//    if (data != null) {
//      if (token != null) {
//        Injector().setToken(token);
//        setUser(User.fromJson(json.decode(data)));
//        if (user.status == 'register')
//          _defaultHome = new SmsPage();
//        else
//          _defaultHome = new MainPage();
//      }
//    }
//    return _defaultHome;
//  }

//  setUser(User u, {bool token = false}) {
//    if (u == null) {
//      Util.setPreference('TOKEN', null);
//      Util.setPreference('USER', null);
//      user = null;
//      return;
//    }
//
//    if (token) {
//      Util.setPreference('TOKEN', u.token);
//      new Injector().setToken(u.token);
//    }
//
//    Util.setPreference('USER', u.toString());
//    user = u;
//  }

  clearStorageData() {
    isPusherActive = false;
  }

//  Future<void> initGPS() async {
//    Location location = new Location();
//    location.changeSettings(accuracy: LocationAccuracy.navigation, interval: 300, distanceFilter: 20);
//
//    try {
//      pos = await location.getLocation();
//
//      location.onLocationChanged.listen((data) {
//        var d = Util.haversine(pos.latitude, pos.longitude, data.latitude, data.longitude) * 1000;
//
//        if (gpsStreamController != null && !gpsStreamController.isClosed && gpsStreamController.hasListener)
//          gpsStreamController.add(d);
//
//        pos = data;
//
//        if (activeRoute.status == 'in_progress') {
//          activeRoute.driverLong = data.longitude;
//          activeRoute.driverLat = data.latitude;
//        }
//      });
//
//      initialPosition = CameraPosition(
//        target: LatLng(pos.latitude, pos.longitude),
//        zoom: 15,
//      );
//
//      myAddressNow.lat = pos.latitude;
//      myAddressNow.long = pos.longitude;
//      myAddressNow.lng = pos.longitude;
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        gpsOk = 1;
//        print('rejected localization');
//        return;
//      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//        gpsOk = 2;
//        print('rejected never localization');
//        return;
//      } else if (e.code == 'ERROR') {
//        gpsOk = 3;
//        print(e.message);
//        return;
//      }
//      pos = null;
//    }
//    gpsOk = 0;
//  }

  // setActiveRoute(RouteObj r) {
  //   this.activeRoute = r;
  //   Util.setPreference('activeRoute', this.activeRoute.id.toString());
  // }
  //
  // clearActiveRoute() {
  //   this.activeRoute = null;
  //   Util.setPreference('activeRoute', null);
  // }

//  @override
//  void onAddressListSuccess(List<Address> result) {
//    //addresses = result;
//    listener.canShowAddresses();
//  }

//  @override
//  void onError(String message) {
//    appStateError.add('onError');
//  }

  dispose() {
    if (streamController != null) streamController.close();
    if (appStateError != null) appStateError.close();
  }

  @override
  void onUnauthenticated() {
    appStateError.add('onUnauthenticated');
  }
}

abstract class AppStateView extends BaseView {
  void onError(String message);

  void onAddressListSuccess(List<Address> addresses);
}

abstract class AppStateListener {
  void canShowAddresses();
}
