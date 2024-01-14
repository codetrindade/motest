import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/model/user_status.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/user.dart';

class UserService extends BaseService {
  Api _api;

  UserService() {
    this._api = locator.get<Api>();
  }

  Future<User> updateProfile(User model) async {
    return User.fromJson(getResponse(await _api.put('profile/update', model.toString())));
  }

  Future<UserStatus> getStatus() async {
    return UserStatus.fromJson(getResponse(await _api.get('mobile/get-status')));
  }

  Future<bool> changeDisplayMyPhone() async {
    return getResponse(await _api.put('common/change_display_my_phone', null));
  }

  Future<User> register(User model) async {
    return User.fromJson(getResponse(await _api.post('register', model.toString())));
  }
}
