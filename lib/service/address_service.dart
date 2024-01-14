import 'dart:io';

import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/response_server.dart';

class AddressService extends HttpBase {
  AddressService(String token) : super(token);

  Future<Address> getFromCoordinates(Address model) async {
    return await post('address', model.toString())
        .then((map) => Address.fromJson(map));
  }

  Future<List<Address>> getAutoCompleteResults(Address model) async {
    return await post('address/auto_complete', model.toString())
        .then((map) => (map as List).map((i) => new Address.fromJson(i)).toList());
  }

  Future<Address> createFavoritePlace(Address model) async {
    return await post('mobile/address/', model.toString())
    .then((map) => Address.fromJson(map));
  }

  Future<List<Address>> getList() async {
    return await get('mobile/address/')
        .then((map) => (map as List).map((i) => new Address.fromJson(i)).toList());
  }

  Future<ResponseServer> removeAddress(String id) async {
    return await delete('mobile/address/$id')
        .then((data) => ResponseServer.fromJson(data));
  }

}