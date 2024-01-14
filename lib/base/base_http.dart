import 'dart:async';

import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:moveme/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

class HttpException {
  var message = '';
  var code = 0;

  HttpException({this.message, this.code});
}

class HttpStatus {
  static const OK = 200;
  static const BadRequest = 400;
  static const Unathorized = 401;
  static const ServerError = 500;
}

class HttpBase {
  var _token = '';

  //Dio _dio;

  HttpBase(this._token);

  getHeaders() {
    var header = new Map<String, String>();
    header['Content-Type'] = 'application/json';
    header['Accept'] = 'application/json';

    //print("TOKEN:" + _token);

    if (_token != null)
      header[HttpHeaders.authorizationHeader] = 'Bearer ' + _token;

    return header;
  }

  Future<dynamic> get(String url) {
    print("GET: " + Settings.baseURL + url);
    return http
        .get(Settings.baseURL + url, headers: getHeaders())
        .then((response) {
      print("RESPONSE CODE:" + response.statusCode.toString());
      print("RESPONSE:" + response.body);

      var data = json.decode(response.body);
      if (response.statusCode != HttpStatus.OK) {
        throw new HttpException(
            message: data['message'], code: response.statusCode);
      }
      //print(data);
      return data;
    });
  }

  Future<dynamic> post(String url, String _body) {
    print("POST: " + Settings.baseURL + url);
    print("BODY: $_body");
    return http
        .post(Settings.baseURL + url, body: _body, headers: getHeaders())
        .then((response) {
      print("RESPONSE CODE:" + response.statusCode.toString());
      print("RESPONSE:" + response.body);
      var data = json.decode(response.body);
      if (response.statusCode != HttpStatus.OK) {
        throw new HttpException(
            message: data['message'], code: response.statusCode);
      }
      return data;
    });
  }

  Future<dynamic> put(String url, String _body) {
    print("PUT: " + Settings.baseURL + url);
    print("BODY: $_body");
    return http
        .put(Settings.baseURL + url, headers: getHeaders(), body: _body)
        .then((response) {
      print("RESPONSE CODE:" + response.statusCode.toString());
      print("RESPONSE:" + response.body);
      var data = json.decode(response.body);
      if (response.statusCode != HttpStatus.OK) {
        throw new HttpException(
            message: data['message'], code: response.statusCode);
      }
      return data;
    });
  }

  Future<dynamic> delete(String url) {
    print("DELETE: " + Settings.baseURL + url);
    return http
        .delete(Settings.baseURL + url, headers: getHeaders())
        .then((response) {
      print("RESPONSE CODE:" + response.statusCode.toString());
      print("RESPONSE:" + response.body);
      var data = json.decode(response.body);
      if (response.statusCode != HttpStatus.OK) {
        throw new HttpException(
            message: data['message'], code: response.statusCode);
      }
      return data;
    });
  }

  Future<dynamic> postFile(
      String url, File file, String type, String id) async {
    print("POST: " + Settings.baseURL + url);
    print("BODY: $file");
    print("BODY: $type");
    print("BODY: $id");

    var request =
        new http.MultipartRequest('POST', Uri.parse(Settings.baseURL + url));

    var header = new Map<String, String>();
    //header['Content-Type'] = 'application/x-www-form-urlencoded';

    if (_token.isNotEmpty)
      header[HttpHeaders.authorizationHeader] = 'Bearer ' + _token;

    request.headers.addAll(header);

    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    request.files.add(new http.MultipartFile('file', stream, length,
        filename: basename(file.path),
        contentType: new MediaType('image', 'jpg')));

    request.fields['type'] = type;
    request.fields['id'] = id;

    var response = await request.send();
    print("RESPONSE CODE:" + response.statusCode.toString());
    var _body = '';
    await response.stream
        .transform(utf8.decoder)
        .listen((result) => _body = result);
    print("RESPONSE:" + _body);
    var data = json.decode(_body);
    if (response.statusCode != HttpStatus.OK) {
      throw new HttpException(
          message: data['message'], code: response.statusCode);
    }
    return data;
  }
}
