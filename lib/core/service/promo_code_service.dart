import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/promocode.dart';

class PromoCodeService extends BaseService {
  Api _api;

  PromoCodeService() {
    this._api = locator.get<Api>();
  }

  Future<List<Promocode>> listMyCodes() async {
    var data = getResponse(await _api.post('mobile/promocode/get-my', null));
    return (data as List).map((i) => Promocode.fromJson(i)).toList();
  }
}