import 'package:moveme/core/base/base_bloc.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/user_driver.dart';
import 'package:moveme/core/service/driver_service.dart';

class DriverFavoriteBloc extends BaseBloc {
  var driverService = locator.get<DriverService>();

  List<UserDriver> list;

  // DriverFavoriteBloc() {
  //   initState()
  // }

  Future<void> get() async {
    try {
      setLoading(true);
      this.list = await driverService.listFavoriteDrivers();
    } catch (error) {
      super.onError(error);
    } finally {
      setLoading(false);
    }
  }

  favoriteDriver(String driverId) async {
    try {
      setLoading(true);
      await driverService.favoriteDriver(driverId);
      await this.get();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}
