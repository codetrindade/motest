import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/route_history.dart';
import 'package:moveme/model/routeobj.dart';

class RouteService extends HttpBase {
  RouteService(String token) : super(token);

  Future<Preview> getPreview(PreviewBody body) async {
    return await post('mobile/route/polyline', body.toString()).then((map) => Preview.fromJson(map));
  }

  Future<Preview> getPreviewAfterDriverChosen(PreviewBody body) async {
    return await post('mobile/route/preview', body.toString()).then((map) => Preview.fromJson(map));
  }

  Future<RouteObj> createRoute(PreviewBody body) async {
    return await post('mobile/route/create', body.toString()).then((map) => RouteObj.fromJson(map));
  }

  Future<ResponseServer> cancelRoute(String routeId) async {
    return await post('mobile/route/cancel', '{"route_id":"$routeId"}')
        .then((map) => ResponseServer.fromJson(map));
  }

  Future<ResponseServer> evaluate(
      id, ratingDriver, observationDriver, ratingVehicle, observationVehicle) async {
    return await post(
            'mobile/route/evaluate',
            '{"id":"$id","rating_driver":$ratingDriver,"rating_driver_observation":"$observationDriver",'
                '"rating_vehicle":$ratingVehicle,"rating_vehicle_observation":"$observationVehicle"}')
        .then((map) => ResponseServer.fromJson(map));
  }

  Future<List<RouteHistory>> listHistory() async {
    return await post('mobile/route/history', null)
        .then((data) => (data as List).map((i) => new RouteHistory.fromJson(i)).toList());
  }
}
