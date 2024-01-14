import 'dart:io';

import 'package:moveme/base/base_http.dart';
import 'package:moveme/base/base_view.dart';

class BasePresenter {
  BaseView view;

  BasePresenter({this.view});

  void onError(dynamic error, Function callback) {

    if (error is HttpException) {
      error.code == 401 ? view.onUnauthenticated() : callback(error.message);
      return;
    }

    if (error is NoSuchMethodError) {
      callback(error.toString());
      return;
    }

    if (error is SocketException) {
      callback('Verifique sua conexão com a rede!');
      return;
    }

    callback('Ops... ocorreu um erro inesperado :(');
  }

  void onErrorBeforeLogin(dynamic error, Function callback) {
    if (error is HttpException) {
      callback(error.message);
      return;
    }

    if (error is NoSuchMethodError) {
      callback(error.toString());
      return;
    }

    callback('Opss... ocorreu um erro inesperado :(');
  }
}
