import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/route_service.dart';
import 'package:moveme/view/route/trip_drivers/trip_drivers_view.dart';

class TripDriversPresenter extends BasePresenter {
  TripDriversView _view;
  RouteService _service;

  TripDriversPresenter(this._view) {
    super.view = _view;
    _service = new Injector().routeService;
  }

  void getPreviewAfterDriverChosen(PreviewBody body) {
    _service
        .getPreviewAfterDriverChosen(body)
        .then((data) => _view.onGetPreviewSuccess(data))
        .catchError((error) =>
        super.onErrorBeforeLogin(error, (message) => _view.onError(message)));
  }

  void createRoute(PreviewBody body) {
    _service
        .createRoute(body)
        .then((data) => _view.onCreateRouteSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onCreateRouteError(message)));
  }
}