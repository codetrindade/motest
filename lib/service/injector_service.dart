import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/core/service/driver_service.dart';
import 'package:moveme/service/ride_service.dart';
import 'package:moveme/service/route_service.dart';
import 'package:moveme/service/upload_service.dart';
import 'package:moveme/service/user_service.dart';

import 'address_service.dart';
import '../core/service/card_service.dart';
import 'config_service.dart';

class Injector {
  //singleton
  static final Injector _instance = new Injector.internal();
  static String _token = '';

  Injector.internal();

  factory Injector() {
    return _instance;
  }

  void setToken(String token) {
    _token = token;
    locator.get<Api>().setToken(token, '');
  }

  UserService get userService {
    return new UserService(_token);
  }

  ConfigService get configService {
    return new ConfigService(_token);
  }
  //
  // DriverService get driverService {
  //   return new DriverService(_token);
  // }

  AddressService get addressService {
    return new AddressService(_token);
  }

  RouteService get routeService {
    return new RouteService(_token);
  }

  RideService get rideService {
    return new RideService(_token);
  }

  UploadService get uploadService {
    return new UploadService(_token);
  }

  // CardService get cardService {
  //   return new CardService(_token);
  // }
}
