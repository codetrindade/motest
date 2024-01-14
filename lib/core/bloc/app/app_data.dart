import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/user.dart';

class AppData {
  User user;
  List<Address> addresses = List<Address>();
  bool isAuthenticate = false;

  LatLng pos = LatLng(-21.9549806, -49.0232348);
  double zoom = 18;
  //CameraPosition initialPosition;
  Address myAddressNow = Address(order: 0);
}
