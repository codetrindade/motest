import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/locator.dart';

import 'app_exception.dart';

class BaseService {
  getResponse(Response response) {
    print("StatusCode:${response.statusCode}");
    switch (response.statusCode) {
      case HttpStatus.created:
      case HttpStatus.ok:
        try {
          var data = json.decode(utf8.decode(response.bodyBytes));
          print(data);
          return data;
        } catch (e) {
          return {};
        }
        break;
      case HttpStatus.badRequest:
        var data = json.decode(utf8.decode(response.bodyBytes));
        if (data['error_description'] != null)
          throw new AppException(message: data['error_description']);
        else if (data['message'] != null)
          throw new AppException(message: data['message']);
        else
          throw new AppException(message: "Ocorreu um erro 400, sem tratamento.");
        break;
      case HttpStatus.internalServerError:
        try {
          var data = json.decode(utf8.decode(response.bodyBytes));
        } catch (e) {
          print(e);
        }
        throw new AppException(message: "Ocorreu um erro 500 na API.");
        break;
      case HttpStatus.gatewayTimeout:
        throw new AppException(message: "Ocorreu um erro de Timeout.");
        break;
      case HttpStatus.unauthorized:
        eventBus.fire(UnauthenticatedEvent());
        throw new AppException(message: "Sua sessão expirou, por favor, realize seu login novamente");
        break;
      default:
        throw new AppException(message: "Ocorreu um erro inesperado. " + response.statusCode.toString());
        break;
    }
  }
}
