import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/service/upload_service.dart';
import 'package:moveme/core/service/user_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/user.dart';

class ProfileBloc extends BaseBloc {
  var userService = locator.get<UserService>();
  var uploadService = locator.get<UploadService>();
  var appData = locator.get<AppData>();
  bool showMyPhone = false;

  updateProfile(User model) async {
    try {
      setLoading(true);
      var result = await userService.updateProfile(model);
      eventBus.fire(UserChangedEvent(user: result));
      dialogService.showDialog('Sucesso', 'Dados alterados com sucesso');
      navigationManager.goBack();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  chooseImage(ImageSource source) async {
    try {
      var pickedFile = await ImagePicker().getImage(
          source: source, preferredCameraDevice: CameraDevice.front, maxHeight: 600, maxWidth: 600);
      if (pickedFile != null) {
        var img = await navigationManager.navigateTo('/crop', arguments: File(pickedFile.path));
        var result = await uploadService.uploadDocument('user-photo', img);
        appData.user.photo = result.message;
        eventBus.fire(UserChangedEvent(user: appData.user));
      }
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  changeDisplayMyPhone() async {
    try {
      setLoading(true);
      showMyPhone = await userService.changeDisplayMyPhone();
      appData.user.displayMyPhone = showMyPhone;
      eventBus.fire(UserChangedEvent(user: appData.user));
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}
