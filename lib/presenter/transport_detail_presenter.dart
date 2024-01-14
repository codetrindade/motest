import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/ride_service.dart';
import 'package:moveme/view/ride/transport_detail/transport_detail_view.dart';

class TransportDetailPresenter extends BasePresenter {
  TransportDetailView _view;
  RideService _rideService;

  TransportDetailPresenter(this._view){
    super.view = _view;
    _rideService = new Injector().rideService;
  }

  void apply(String ridePriceId, String payment, int reservations) {
    _rideService.apply(ridePriceId, payment, reservations)
        .then((data) => _view.onApplySuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }

  void cancelRide(String rideId) {
    _rideService.cancelRide(rideId)
        .then((data) => _view.onCancelRideSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}