import 'dart:io';

import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/model/upload_response.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:http/http.dart' as http;

class UploadService extends BaseService {
  Api _api;

  UploadService() {
    this._api = locator.get<Api>();
  }

  Future<UploadResponse> uploadDocument(String type, File file, {String id}) async {
    var url = "upload/$type";
    if (id != null) url += "/$id";
    var streamedResponse = await _api.postFile(url, file);
    return UploadResponse.fromJson(getResponse(await http.Response.fromStream(streamedResponse)));
  }
}