import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/user_driver.dart';

class DriverService extends BaseService {
  Api _api;

  DriverService() {
    this._api = locator.get<Api>();
  }

  Future<List<UserDriver>> listFavoriteDrivers() async {
    //return await post('mobile/favorite', null).then((data) => UserDriver.fromJson(data));
    var data = getResponse(await _api.post('mobile/favorite/list', null));
    return (data as List).map((i) => new UserDriver.fromJson(i)).toList();
  }

  Future<void> favoriteDriver(String driverId) async {
    getResponse(await _api.post('mobile/favorite/', '{"favorite_id":"$driverId"}'));
  }
}
