import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/core/bloc/card/card_bloc.dart';
import 'package:moveme/core/bloc/chat/chat_bloc.dart';
import 'package:moveme/core/bloc/driver/driver_favorite_bloc.dart';
import 'package:moveme/core/bloc/history/history_bloc.dart';
import 'package:moveme/core/bloc/login/login_bloc.dart';
import 'package:moveme/core/bloc/profile/profile_bloc.dart';
import 'package:moveme/core/bloc/register/register_bloc.dart';
import 'package:moveme/core/bloc/route/route_create_bloc.dart';
import 'package:moveme/core/bloc/sac/sac_bloc.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/ui/manager/dialog_manager.dart';
import 'package:moveme/ui/manager/navigation_manager.dart';
import 'package:moveme/ui/view/splash_page.dart';
import 'package:moveme/view/chat/chat_page.dart';
import 'package:moveme/view/history/route_resume.dart';
import 'package:moveme/view/login/login_main_page.dart';
import 'package:moveme/view/main/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moveme/view/route/active_trip/active_trip.dart';
import 'package:moveme/widgets/crop_page.dart';
import 'package:provider/provider.dart';
import 'package:load/load.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    setupLocator();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppBloc()),
      ChangeNotifierProvider(create: (context) => ChatBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => DriverFavoriteBloc()),
      ChangeNotifierProvider(create: (context) => ProfileBloc()),
      ChangeNotifierProvider(create: (context) => RouteCreateBloc()),
      ChangeNotifierProvider(create: (context) => LoginBloc()),
      ChangeNotifierProvider(create: (context) => RegisterBloc()),
      ChangeNotifierProvider(create: (context) => HistoryBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => SacBloc()),
      ChangeNotifierProvider(create: (context) => CardBloc()),

    ], child: MovemeApp()));
  });
}

class MovemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: LoadingProvider(
          loadingWidgetBuilder: (ctx, data) =>
              Container(
                  color: Colors.white,
                  child: Center(child: Container(height: 40, width: 40, child: CircularProgressIndicator()))),
          child: MaterialApp(
              builder: (context, widget) =>
                  Navigator(onGenerateRoute: (settings) =>
                      MaterialPageRoute(builder: (context) => DialogManager(child: widget))),
              title: 'Moveme',
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              home: MainPage(),
              routes: <String, WidgetBuilder>{
                '/login': (BuildContext context) => LoginMainPage(),
                '/home': (BuildContext context) => MainPage(),
                '/chat_page': (BuildContext context) => ChatPage(),
                '/crop': (BuildContext context) => CropPage(),
                '/new_route': (BuildContext context) => ActiveTrip(),
                '/route_resume': (BuildContext context) => RouteResume()
              },
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              navigatorKey: locator<NavigationManager>().navigatorKey,
              supportedLocales: [const Locale('pt', 'BR')])),
    );
  }
}
