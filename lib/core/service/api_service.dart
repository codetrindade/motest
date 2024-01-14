import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:moveme/settings.dart';
import 'package:path/path.dart';

import 'dart:async';
import 'package:http_parser/http_parser.dart';

class Api {
  String baseURL = Settings.baseURL;
  String token = '';
  String refreshToken = '';

  Api();

  void setToken(String token, String refreshToken) {
    this.token = token;
    this.refreshToken = refreshToken;
  }

  getHeaders() {
    var header = new Map<String, String>();
    header['Content-Type'] = 'application/json';
    header['Accept'] = 'application/json';

    print("BEAR TOKEN: " + token);
    if (token.isNotEmpty) header[HttpHeaders.authorizationHeader] = 'Bearer ' + token;

    return header;
  }

  getHeadersFile() {
    var header = new Map<String, String>();
    header['Accept'] = 'application/json, text/plain, */*';
    header['Content-Type'] = 'multipart/form-data';

    print("BEAR TOKEN: " + token);
    if (token.isNotEmpty) header[HttpHeaders.authorizationHeader] = 'Bearer ' + token;

    return header;
  }

  Future<Response> get(String url) {
    print("GET: ${baseURL + url}");
    return http.get(baseURL + url, headers: getHeaders());
  }

  Future<Response> getOutBaseUrl(String url) {
    print("GET: $url");
    return http.get(url, headers: getHeaders());
  }

  Future<Response> post(String url, String _body) {
    print("POST: ${baseURL + url}");
    print("BODY: $_body");
    return http.post(baseURL + url, body: _body, headers: getHeaders());
  }

  Future<Response> postFormEncoded(String url, String _body) async {
    print("POST: ${baseURL + url}");
    print("BODY: $_body");

    var request = new http.Request('POST', Uri.parse(baseURL + url));

    request.headers.addAll(<String, String>{'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*'});

    List<int> bodyBytes = utf8.encode(_body);
    request.bodyBytes = bodyBytes;
    var stream = await request.send();
    return await http.Response.fromStream(stream);
  }

  Future<Response> put(String url, String _body) {
    print("PUT: ${baseURL + url}");
    print("BODY: $_body");
    return http.put(baseURL + url, body: _body, headers: getHeaders());
  }

  Future<Response> delete(String url) {
    print("DELETE: ${baseURL + url}");
    return http.delete(baseURL + url, headers: getHeaders());
  }

  Future<dynamic> postFiles(String url, List<File> files) async {
    print("POST FILE: ${baseURL + url}");

    var request = new http.MultipartRequest('POST', Uri.parse(baseURL + url));

    request.headers.addAll(getHeaders());

    var index = 0;
    for (var file in files) {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      request.files.add(new http.MultipartFile('file$index', stream, length, filename: basename(file.path)));
      index++;
    }

    var response = await request.send();
    print("RESPONSE CODE:" + response.statusCode.toString());
    var _body = '';
    response.stream.transform(utf8.decoder).listen((result) => _body = result);
    print("RESPONSE:" + _body);
    var data = json.decode(_body);
    if (response.statusCode != HttpStatus.ok) {
      throw new HttpException(data['message']);
    }
    return data;
  }

  Future<dynamic> postFile(String url, File file) async {
    print("POST FILE: ${baseURL + url}");

    var request = new http.MultipartRequest('POST', Uri.parse(baseURL + url));

    request.headers.addAll(getHeaders());

    var stream = new http.ByteStream(file.openRead().cast());
    var length = await file.length();
    request.files.add(new http.MultipartFile('file', stream, length, filename: basename(file.path)));

    return await request.send();
  }

  Future<dynamic> putFile(String url, File file, MediaType type) async {
    print("PUT FILE: ${baseURL + url}");

    var request = new http.MultipartRequest('PUT', Uri.parse(baseURL + url));

    request.headers.addAll(getHeadersFile());

    if (file != null) {
      var stream = new http.ByteStream(file.openRead().cast());
      var length = await file.length();
      request.files
          .add(new http.MultipartFile('file', stream, length, filename: basename(file.path), contentType: type));
    }
    return await request.send();
  }
}
