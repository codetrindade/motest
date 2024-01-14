import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/ride.dart';

class RideService extends HttpBase {
  RideService(String token) : super(token);

  Future<List<Ride>> find(Ride model) async {
    return await post('mobile/ride/find', model.toString())
        .then((data) => (data as List).map((i) => new Ride.fromJson(i)).toList());
  }

  Future<ResponseServer> apply(String ridePriceId, String payment, int reservations) async {
    return await post('mobile/ride/apply', '{"ride_price_id":"$ridePriceId","payment":"$payment","reservations":"$reservations"}')
        .then((data) => new ResponseServer.fromJson(data));
  }

  Future<List<Ride>> list() async {
    return await post('mobile/ride/list', null)
        .then((data) => (data as List).map((i) => new Ride.fromJson(i)).toList());
  }

  Future<ResponseServer> cancelRide(String rideId) async {
    return await post('mobile/ride/cancel', '{"ride_id":"$rideId"}')
        .then((data) => new ResponseServer.fromJson(data));
  }
}
