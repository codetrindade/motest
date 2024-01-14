import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:location/location.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/core/base/app_exception.dart';
import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/service/address_service.dart';
import 'package:moveme/core/service/push_service.dart';
import 'package:moveme/core/service/route_service.dart';
import 'package:moveme/core/service/set_config_service.dart';
import 'package:moveme/core/service/user_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/routeobj.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/util/util.dart';
import 'package:package_info/package_info.dart';

enum AppStateEnum { LOGIN, SPLASH, REGISTER, SMS, CHAT_LIST, HISTORY, HOME, FAVORITE, PROFILE }

class AppBloc extends BaseBloc {
  var appData = locator.get<AppData>();
  var firebase = locator.get<PushService>();
  var setConfigService = locator.get<SetConfigService>();
  var pushService = locator.get<PushService>();
  var addressService = locator.get<NewAddressService>();
  var userService = locator.get<UserService>();
  var routeService = locator.get<RouteService>();

  var isLoadingGPS = true;

  String version = '';

  AppBloc() {
    super.state = AppStateEnum.SPLASH;
    eventBus.on().listen((event) async {
      if (event is AppNewMessageEvent) {
        if (event.pushMessage.type == 'approved') {
          pushService.showNotification(event.pushMessage);
        }
      }

      if (event is AppLoginEvent) {
        setUser(event.user, token: true);
        homeInitialize();
      }

      if (event is UserChangedEvent) {
        setUser(event.user);
      }

      if (event is AppLogoffEvent) {
        firebase.token = null;
        await setConfigService.setConfig();
        changeState(AppStateEnum.LOGIN);
      }

      if (event is ChangeStateEvent) {
        changeState(event.state);
      }

      if (event is UnauthenticatedEvent) {
        logout();
        dialogService.showDialog('Sessão expirada', 'Sua sessão expirou, faça login novamente.');
      }
    });
  }

  initialize() {
    Future.delayed(Duration(seconds: 3), () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      this.version = "${packageInfo.version}(${packageInfo.buildNumber})";

      var token = await Util.getPreference('TOKEN');
      var data = await Util.getPreference('USER');
      if (data != null && token != null) {
        Injector().setToken(token);
        var user = User.fromJson(json.decode(data));
        appData.user = user;
        appData.isAuthenticate = true;
        // AppState.user = user;
        // AppState().setUser(user);
        eventBus.fire(AppLoginEvent(user));
        return;
      }
      changeState(AppStateEnum.LOGIN);
    });
  }

  homeInitialize() async {
    try {
      setLoading(true);
      if (appData.user.status == 'register')
        changeState(AppStateEnum.SMS);
      else
        changeState(AppStateEnum.HOME);
      await firebase.initialize();
      await setConfigService.setConfig();
      AppState().initPusher(appData.user.token);
      await loadAddresses();
      initGPS();
      //await getAddressNow();
      await getRouteStatus();
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> initGPS() async {
    try {

      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        //await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        return;
      }
      var lastLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation, timeLimit: Duration(seconds: 10));
      setLocationDefault(LatLng(lastLocation.latitude, lastLocation.longitude), 18);
    } catch (e) {
      print(e);
      setLocationDefault(LatLng(-15.7744228, -48.0772753), 2);
      dialogService.showDialog('Atenção', 'Não foi possível obter sua localização, selecione sua posição no mapa.');
      // if (e.code == 'PERMISSION_DENIED') {
      //   //gpsOk = 1;
      //   print('rejected localization');
      //   return;
      // } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      //   //gpsOk = 2;
      //   print('rejected never localization');
      //   return;
      // } else if (e.code == 'ERROR') {
      //   //gpsOk = 3;
      //   print(e.message);
      //   return;
      // }
      //pos = null;
    } finally {
      isLoadingGPS = false;
      getAddressNow();
      notifyListeners();
    }
    //gpsOk = 0;
  }

  setLocationDefault(LatLng pos, double zoom) {
    appData.pos = pos;
    appData.zoom = zoom;
    appData.myAddressNow.lat = appData.pos.latitude;
    appData.myAddressNow.long = appData.pos.longitude;
  }

  loadAddresses() async {
    try {
      appData.addresses = await addressService.getList();
    } catch (error) {
      super.onError(error);
    }
  }

  getAddressNow() async {
    try {
      //appData.myAddressNow.id = new Uuid().v1();
      appData.myAddressNow.alias = 'Origem';
      appData.myAddressNow.type = 'others';
      appData.myAddressNow.mainAddress = false;

      var result = await addressService.getFromCoordinates(appData.myAddressNow);
      appData.myAddressNow.address = result.address;
    } catch (error) {
      //super.onError(error);
    } finally {
      notifyListeners();
    }
  }

  setUser(User u, {bool token = false}) {
    if (u == null) {
      Util.setPreference('TOKEN', null);
      Util.setPreference('USER', null);
      appData.user = null;
      appData.isAuthenticate = false;
      return;
    }

    if (token) {
      Util.setPreference('TOKEN', u.token);
      new Injector().setToken(u.token);
    }

    Util.setPreference('USER', u.toString());
    appData.user = u;
    appData.isAuthenticate = true;
  }

  getRouteStatus() async {
    try {
      var status = await userService.getStatus();
      if (status.currentRouteStatus == 'accepted' || status.currentRouteStatus == 'in_progress') {
        var route = await routeService.getRouteById(status.currentRouteId);
        if (route.status == 'accepted' || route.status == 'in_progress') {
          AppState().activeRoute = RouteObj();
          AppState().activeRoute.id = route.id;
          AppState().activeRoute.price = route.price;
          AppState().activeRoute.status = route.status;
          AppState().activeRoute.driver = route.driver;
          AppState().activeRoute.vehicle = route.vehicle;
          AppState().activeRoute.payment = route.payment;
          AppState().activeRoute.distance = route.distance;
          AppState().activeRoute.createdAt = route.createdAt;
          AppState().activeRoute.origin = route.points.first.address;
          AppState().activeRoute.destination = route.points.last.address;
          AppState().activeRoute.durationEstimate = route.durationEstimate;
          AppState().activeRoute.polylineDriverToMe = route.polylineDriverToMe;
          AppState().activeRoute.durationDriverToMe = route.durationDriverToMe;
          AppState().activeRoute.distanceDriverToMe = route.distanceDriverToMe;
          AppState().activeRoute.listPoints = Util.decodePolyline(AppState().activeRoute.polylineDriverToMe);
          AppState().subscribeToAChannelPusher(route.driver.id, 'statusRoute');
          navigationManager.navigateTo('/new_route');
        }
      }
    } catch (e) {
      super.onError(e);
    }
  }

  void logout() {
    setUser(null);
    AppState().clearStorageData();
    changeState(AppStateEnum.LOGIN);
  }
}
