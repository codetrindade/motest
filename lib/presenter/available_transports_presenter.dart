import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/ride_service.dart';
import 'package:moveme/view/ride/available_transports/available_transports_view.dart';

class AvailableTransportsPresenter extends BasePresenter {
  AvailableTransportsView _view;
  RideService _rideService;

  AvailableTransportsPresenter(this._view){
    super.view = _view;
    _rideService = new Injector().rideService;
  }

  void find(Ride model) {
    _rideService.find(model)
        .then((data) => _view.onListTransportsSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}