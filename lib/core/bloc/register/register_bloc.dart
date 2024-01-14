import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/service/user_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/user.dart';

class RegisterBloc extends BaseBloc {
  var registerService = locator.get<UserService>();
  bool showPassword = false;
  bool showConfirmPassword = false;

  register(User model) async {
    try {
      setLoading(true);
      model.type = 'mobile';
      var user = await registerService.register(model);
      eventBus.fire(AppLoginEvent(user));
    } catch (e) {
      super.onError(e);
    } finally {
      Future.delayed(Duration(seconds: 3), () => setLoading(false));
    }
  }
}
