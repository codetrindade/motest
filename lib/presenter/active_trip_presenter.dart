import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/route_service.dart';
import 'package:moveme/view/route/active_trip/active_trip_view.dart';

class ActiveTripPresenter extends BasePresenter {
  ActiveTripView _view;
  RouteService _routeService;

  ActiveTripPresenter(this._view) {
    super.view = _view;
    _routeService = new Injector().routeService;
  }

  void cancelRoute(String routeId) {
    _routeService.cancelRoute(routeId)
        .then((data) => _view.onCancelSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }

}