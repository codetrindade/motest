import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/ui/view/splash_page.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/chat/chat_list_page.dart';
import 'package:moveme/view/history/history_list_page.dart';
import 'package:moveme/view/home/home_page.dart';
import 'package:moveme/view/informations/informations_page.dart';
import 'package:moveme/view/favorite_places/favorite_places_page.dart';
import 'package:android_intent/android_intent.dart';
import 'package:moveme/view/login/login_page.dart';
import 'package:moveme/view/login/register_page.dart';
import 'package:moveme/view/login/sms_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends BaseState<MainPage> {
  AppBloc bloc;

  //var pageIndex = 2;
  //PageController _pageController;
  AndroidIntent intent;

  //bool _isLoading = true;

  verifyGps() {
    Future.delayed(Duration(seconds: 1), () {
      switch (AppState.gpsOk) {
        case 0:
          break;
        case 1:
          Util.showMessage(
              context,
              'Atenção',
              'A permissão para uso do GPS foi desabilitada, para que o aplicativo continue '
                  'funcionando, por favor habilite o a permissão GPS para o aplicativo!');
          if (Platform.isAndroid) {
            intent = AndroidIntent(
                action: 'android.settings.APPLICATION_DETAILS_SETTINGS', data: 'package:app.profix.colab');
            intent.launch();
          }
          break;
        case 2:
          Util.showMessage(
              context,
              'Atenção',
              'A permissão para uso do GPS foi desabilitada, para que o aplicativo continue '
                  'funcionando, por favor habilite o a permissão GPS para o aplicativo!');
          if (Platform.isAndroid) {
            intent = AndroidIntent(
                action: 'android.settings.APPLICATION_DETAILS_SETTINGS', data: 'package:app.profix.colab');
            intent.launch();
          }
          break;
        case 3:
          Util.showMessage(
              context,
              'Atenção',
              'O GPS não está ativado, por favor, ative seu GPS para que o aplicativo continue '
                  'funcionando');
          if (Platform.isAndroid) {
            intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
            intent.launch();
          }
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
//    _pageController = PageController(initialPage: pageIndex);
//    try {
//      if (!AppState.isPusherActive) {
//        AppState().initPusher();
//        AppState().getGPS().then((_void) {
//          verifyGps();
//          AppState().listener = this;
//          AppState().initAddresses();
//          AppState().appStateError.stream.asBroadcastStream().listen((data) {
//            switch (data) {
//              case 'onUnauthenticated':
//                super.onUnauthenticated();
//                break;
//              case 'onError':
//                super.onError('Ocorreu um erro inesperado');
//                break;
//              default:
//                break;
//            }
//          });
//        });
//      }
//      //initPushMessage();
//      //initNotification();
//     } catch (error) {
//      print(error);
//    } finally {
//      _isLoading = false;
//    }
  }

  @override
  void dispose() {
    super.dispose();
//    _pageController.dispose();
  }

//  void bottomMenuTap(int index) {
//    setState(() {
//      this.pageIndex = index;
//      _pageController.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    AppState.devicePixelRatio = MediaQuery.of(context).devicePixelRatio.round();
    bloc = Provider.of<AppBloc>(context);

    switch (bloc.state) {
      case AppStateEnum.SPLASH:
        return SplashPage();
      case AppStateEnum.LOGIN:
        return LoginPage();
      case AppStateEnum.REGISTER:
        return RegisterPage();
      case AppStateEnum.SMS:
        return SmsPage();
      default:
        return Material(
          color: AppColors.colorPrimary,
          child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomPadding: false,
                body: bloc.isLoading
                    ? LoadingCircle()
                    : Stack(
                        children: <Widget>[
                          Container(
                            child: Builder(builder: (BuildContext context) {
                              switch (bloc.state) {
                                case AppStateEnum.CHAT_LIST:
                                  return ChatListPage();
                                case AppStateEnum.HISTORY:
                                  return HistoryListPage();
                                case AppStateEnum.HOME:
                                  return HomePage();
                                case AppStateEnum.FAVORITE:
                                  return FavoritePlacesPage();
                                default:
                                  return InformationsPage();
                              }
                            }),
//                        PageView(
//                          controller: _pageController,
//                          physics: NeverScrollableScrollPhysics(),
//                          children: <Widget>[
//                            ChatListPage(),
//                            HistoryListPage(),
//                            HomePage(),
//                            FavoritePlacesPage(),
//                            InformationsPage()
//                          ],
//                        ),
                          ),
                          //BOTTOM BAR
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  border: Border.all(color: AppColors.colorBlueLight),
                                  borderRadius:
                                      BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: 10.0),
                                  IconButton(
                                      onPressed: () => bloc.changeState(AppStateEnum.CHAT_LIST),
                                      icon: Icon(MoveMeIcons.speech_bubble,
                                          size: 30.0,
                                          color: bloc.state == AppStateEnum.CHAT_LIST
                                              ? AppColors.colorBlueLight
                                              : AppColors.colorGrey)),
                                  IconButton(
                                      onPressed: () => bloc.changeState(AppStateEnum.HISTORY),
                                      icon: Icon(MoveMeIcons.parked_car,
                                          size: 30.0,
                                          color: bloc.state == AppStateEnum.HISTORY
                                              ? AppColors.colorBlueLight
                                              : AppColors.colorGrey)),
                                  IconButton(
                                      onPressed: () => bloc.changeState(AppStateEnum.HOME),
                                      icon: Icon(MoveMeIcons.web_page_home,
                                          size: 30.0,
                                          color: bloc.state == AppStateEnum.HOME
                                              ? AppColors.colorBlueLight
                                              : AppColors.colorGrey)),
                                  IconButton(
                                      onPressed: () => bloc.changeState(AppStateEnum.FAVORITE),
                                      icon: Icon(MoveMeIcons.heart,
                                          size: 30.0,
                                          color: bloc.state == AppStateEnum.FAVORITE
                                              ? AppColors.colorBlueLight
                                              : AppColors.colorGrey)),
                                  IconButton(
                                      onPressed: () => bloc.changeState(AppStateEnum.PROFILE),
                                      icon: Icon(MoveMeIcons.perfil,
                                          size: 30.0,
                                          color: bloc.state == AppStateEnum.PROFILE
                                              ? AppColors.colorBlueLight
                                              : AppColors.colorGrey)),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
          ),
        );
    }
  }

//  @override
//  void canShowAddresses() {
//    setState(() {
//      _isLoading = false;
//    });
//  }
}
