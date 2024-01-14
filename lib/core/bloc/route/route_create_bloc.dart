import 'package:moveme/app_state.dart';
import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/service/promo_code_service.dart';
import 'package:moveme/core/service/route_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/model/promocode.dart';
import 'package:moveme/model/routeobj.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/route/trip_drivers/trip_drivers_list.dart';

class RouteCreateBloc extends BaseBloc {
  var routeService = locator.get<RouteService>();
  var promoCodeService = locator.get<PromoCodeService>();
  Preview model = Preview();
  String driverChosen = '';
  List<Address> routes;
  String payment;
  String gender;
  String cardId;
  List<Promocode> promocodes = List();

  getPromoCodes() async {
    try {
      promocodes = await promoCodeService.listMyCodes();
    } catch (e) {
      super.onError(e);
    }
  }

  getDriversList(PreviewBody body) async {
    try {
      setLoading(true);
      model = await routeService.getDriversList(body);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  setDriverChosen(String id) {
    try {
      driverChosen = id;
      model.drivers.forEach((element) {
        element.chosen = (element.user.id == id);
      });
    } catch (e) {
      super.onError(e);
    } finally {
      notifyListeners();
    }
  }

  createRoute({RouteCreatedListener listener, Promocode code}) async {
    try {
      setLoading(true);
      var body = PreviewBody(
          points: this.routes,
          driverId: this.driverChosen,
          payment: this.payment,
          cardId: this.cardId,
          promocode: code?.code);
      var route = await routeService.createRoute(body);
      AppState().activeRoute = RouteObj();
      AppState().activeRoute.id = route.id;
      AppState().activeRoute.price = route.price;
      AppState().activeRoute.status = route.status;
      AppState().activeRoute.driver = route.driver;
      AppState().activeRoute.vehicle = route.vehicle;
      AppState().activeRoute.payment = route.payment;
      AppState().activeRoute.distance = route.distance;
      AppState().activeRoute.createdAt = route.createdAt;
      AppState().activeRoute.origin = routes.first.address;
      AppState().activeRoute.destination = routes.last.address;
      AppState().activeRoute.durationEstimate = route.durationEstimate;
      AppState().activeRoute.polylineDriverToMe = route.polylineDriverToMe;
      AppState().activeRoute.durationDriverToMe = route.durationDriverToMe;
      AppState().activeRoute.distanceDriverToMe = route.distanceDriverToMe;
      AppState().activeRoute.listPoints = Util.decodePolyline(AppState().activeRoute.polylineDriverToMe);
      AppState().subscribeToAChannelPusher(route.driver.id, 'statusRoute');
      listener.onCreateRouteSuccess();
    } catch (e) {
      super.onError(e);
    } finally {
      Future.delayed(Duration(seconds: 5), () {
        setLoading(false);
      });
    }
  }
}
