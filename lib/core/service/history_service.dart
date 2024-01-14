import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/model/route_history.dart';

class HistoryService extends BaseService {
  Api _api;

  HistoryService() {
    this._api = locator.get<Api>();
  }

  Future<List<RouteHistory>> listRoutes() async {
    var data = getResponse(await _api.post('mobile/route/history', null));
    return (data as List).map((i) => new RouteHistory.fromJson(i)).toList();
  }

  Future<List<Ride>> listRides() async {
    var data = getResponse(await _api.post('mobile/ride/list', null));
    return (data as List).map((i) => new Ride.fromJson(i)).toList();
  }

  Future<RouteHistory> getById(String id) async {
    return RouteHistory.fromJson(getResponse(await _api.get('common/route/$id')));
  }
}