import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:moveme/core/base/dialog_service.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/core/service/api_service.dart';
import 'package:moveme/core/service/card_service.dart';
import 'package:moveme/core/service/chat_service.dart';
import 'package:moveme/core/service/history_service.dart';
import 'package:moveme/core/service/login_service.dart';
import 'package:moveme/core/service/promo_code_service.dart';
import 'package:moveme/core/service/push_service.dart';
import 'package:moveme/core/service/route_service.dart';
import 'package:moveme/core/service/set_config_service.dart';
import 'package:moveme/core/service/driver_service.dart';
import 'package:moveme/core/service/upload_service.dart';
import 'package:moveme/core/service/user_service.dart';
import 'package:moveme/ui/manager/navigation_manager.dart';

import 'core/service/address_service.dart';
import 'core/service/sac_service.dart';

GetIt locator = GetIt.instance;
EventBus eventBus = EventBus();

void setupLocator() {
  locator.registerLazySingleton(() => AppData());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationManager());
  locator.registerLazySingleton(() => PushService());

  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => SetConfigService());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => DriverService());
  locator.registerLazySingleton(() => HistoryService());
  locator.registerLazySingleton(() => NewAddressService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UploadService());
  locator.registerLazySingleton(() => RouteService());
  locator.registerLazySingleton(() => LoginService());
  locator.registerLazySingleton(() => SacService());
  locator.registerLazySingleton(() => CardService());
  locator.registerLazySingleton(() => PromoCodeService());
}
