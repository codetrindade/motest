import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/route_service.dart';
import 'package:moveme/view/route/trip_evaluation.dart';

class TripEvaluationPresenter extends BasePresenter {
  TripEvaluationView _view;
  RouteService _routeService;

  TripEvaluationPresenter(this._view){
    super.view = _view;
    _routeService = Injector().routeService;
  }

  void evaluate(id, ratingDriver, observationDriver,
      ratingVehicle, observationVehicle) {
    _routeService.evaluate(id, ratingDriver, observationDriver,
        ratingVehicle, observationVehicle)
        .then((data) => _view.onEvaluateSuccess())
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}