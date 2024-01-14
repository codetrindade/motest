import 'dart:async';

import 'package:moveme/base/base_http.dart';
import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/card/card.dart';
import 'package:moveme/model/response_server.dart';

class CardService extends BaseService {
  Api api;

  CardService() {
    api = locator.get<Api>();
  }

  Future<ResponseServer> addCard(CardData model) async {
    return ResponseServer.fromJson(getResponse(await api.post('common/card', model.toString())));
  }

  Future<List<CardData>> listCard() async {
    var data = getResponse(await api.get('common/card'));
    return (data as List).map((i) => new CardData.fromJson(i)).toList();
  }

  Future<ResponseServer> removeCard(String id) async {
    return ResponseServer.fromJson(getResponse(await api.delete('common/card/$id')));
  }

  Future<CardData> getAddress(String zipCode) async {
    return CardData.fromJson(getResponse(await api.get("general/address_from_zip_code/$zipCode")));
  }
}
