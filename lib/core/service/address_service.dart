import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/response_server.dart';

class NewAddressService extends BaseService {
  Api _api;

  NewAddressService() {
    this._api = locator.get<Api>();
  }

  Future<Address> getFromCoordinates(Address model) async {
    return Address.fromJson(getResponse(await _api.post('address', model.toString())));
  }

  Future<List<Address>> getAutoCompleteResults(Address model) async {
    var data = getResponse(await _api.post('address/auto_complete', model.toString()));
    return (data as List).map((i) => new Address.fromJson(i)).toList();
  }

  Future<Address> createFavoritePlace(Address model) async {
    return Address.fromJson(getResponse(await _api.post('mobile/address/', model.toString())));
  }

  Future<List<Address>> getList() async {
    var data = getResponse(await _api.get('mobile/address/'));
    return (data as List).map((i) => new Address.fromJson(i)).toList();
  }

  Future<ResponseServer> removeAddress(String id) async {
    return ResponseServer.fromJson(getResponse(await _api.delete('mobile/address/$id')));
  }
}
