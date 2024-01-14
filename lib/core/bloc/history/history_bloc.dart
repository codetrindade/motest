import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/service/driver_service.dart';
import 'package:moveme/core/service/history_service.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/model/route_history.dart';

class HistoryBloc extends BaseBloc {
  List<Ride> historyRide = [];
  List<RouteHistory> historyRoute = [];
  RouteHistory model;
  var appData = locator.get<AppData>();
  var driverService = locator.get<DriverService>();
  var historyService = locator.get<HistoryService>();

  HistoryBloc() {
    eventBus.on<RouteFinishedEvent>().listen((event) {
      this.getRouteHistoryById(event.id);
    });
  }

  favoriteDriver(String driverId) async {
    try {
      setLoading(true);
      await driverService.favoriteDriver(driverId);
      await this.getRouteHistory();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getRouteHistory() async {
    try {
      setLoading(true);
      historyRoute = await historyService.listRoutes();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getRideHistory() async {
    try {
      setLoading(true);
      historyRide = await historyService.listRides();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getRouteHistoryById(String id) async {
    try {
      setLoading(true);
      model = await historyService.getById(id);
      model.driver.vehicle = model.vehicle;
      navigationManager.navigateTo('/route_resume');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getModel(String id) async {
    try {
      setLoading(true);
      model = await historyService.getById(id);
      model.driver.vehicle = model.vehicle;
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}