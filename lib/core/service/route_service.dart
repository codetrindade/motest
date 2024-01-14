import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/model/routeobj.dart';

class RouteService extends BaseService {
  Api _api;

  RouteService() {
    this._api = locator.get<Api>();
  }

  Future<Preview> getDriversList(PreviewBody body) async {
    return Preview.fromJson(getResponse(await _api.post('mobile/route/preview', body.toString())));
  }

  Future<RouteObj> createRoute(PreviewBody body) async {
    return RouteObj.fromJson(getResponse(await _api.post('mobile/route/create', body.toString())));
  }

  Future<RouteObj> getRouteById(String id) async {
    return RouteObj.fromJson(getResponse(await _api.get('mobile/route/$id')));
  }
}