import 'dart:async';

import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/login_data.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/token.dart';
import 'package:moveme/model/user.dart';

class UserService extends HttpBase {
  UserService(String token) : super(token);

  Future<User> register(User model) async {
    return await post('register', model.toString())
        .then((data) => User.fromJson(data));
  }

  Future<ResponseServer> forgot(LoginData model) async {
    return await post('forgot', model.toString())
        .then((data) => ResponseServer.fromJson(data));
  }

  Future<User> login(LoginData model) async {
    return await post('login', model.toString())
        .then((data) => User.fromJson(data));
  }

  Future<ResponseServer> confirmSms(String code, String phone) async {
    return await post('phone', '{"sms_code":"$code","phone":"$phone"}')
        .then((data) => ResponseServer.fromJson(data));
  }

  Future<User> updateProfile(User model) async {
    return await put('update', model.toString())
        .then((data) => User.fromJson(data));
  }

  Future<ResponseServer> password(String oldPassword, password) async {
    return await put('password', '{"old_password": "$oldPassword", "password":"$password"}')
        .then((data) => ResponseServer.fromJson(data));
  }
}