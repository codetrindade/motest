import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/core/service/driver_service.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/view/favorite_drivers/favorite_drivers_view.dart';

class FavoriteDriversPresenter extends BasePresenter {
  FavoriteDriversView _view;
  DriverService _service;

  FavoriteDriversPresenter(this._view) {
    super.view = _view;
   // _service = new Injector().driverService;
  }
}