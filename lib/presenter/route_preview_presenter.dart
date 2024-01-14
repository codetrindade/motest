import 'package:moveme/base/base_presenter.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/service/config_service.dart';
import 'package:moveme/service/injector_service.dart';
import 'package:moveme/service/route_service.dart';
import 'package:moveme/view/route/route_preview/route_preview_view.dart';

class RoutePreviewPresenter extends BasePresenter {
  RoutePreviewView _view;
  RouteService _service;
  ConfigService _configService;

  RoutePreviewPresenter(this._view) {
    super.view = _view;
    _service = new Injector().routeService;
    _configService = new Injector().configService;
  }

  void getPreview(PreviewBody body) {
    _service
        .getPreview(body)
        .then((data) => _view.onGetPreviewSuccess(data))
        .catchError((error) =>
        super.onErrorBeforeLogin(error, (message) => _view.onError(message)));
  }

  void listPayments() {
    _configService.listPayments()
        .then((data) => _view.onListPaymentSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}