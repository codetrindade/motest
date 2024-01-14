import 'dart:io';

import 'package:moveme/base/base_http.dart';
import 'package:moveme/model/response_server.dart';

class UploadService extends HttpBase {
  UploadService(String token) : super(token);

  Future<ResponseServer> upload(String type, String id, File img) async {
    return await postFile('upload', img, type, id)
        .then((data) => ResponseServer.fromJson(data));
  }
}