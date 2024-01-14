import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/component/maps/map_component.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/chat.dart';
import 'package:moveme/model/pusher_data.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/model/routeobj.dart';
import 'package:moveme/presenter/active_trip_presenter.dart';
import 'package:moveme/settings.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/route/trip_evaluation.dart';
import 'package:pusher/pusher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'active_trip_view.dart';

class ActiveTrip extends StatefulWidget {
  @override
  _ActiveTripState createState() => _ActiveTripState();
}

class _ActiveTripState extends BaseState<ActiveTrip> implements ActiveTripView {
  bool _canCancel = true;
  String time = '60';
  int seconds = 0;
  ActiveTripPresenter _presenter;
  bool _isLoading = true;
  PanelController _panelController;
  Widget _animatedPopUp = SizedBox();
  Set<Marker> points = Set<Marker>();
  Completer<GoogleMapController> mapController = Completer();
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  BitmapDescriptor imgDestination;
  BitmapDescriptor imgDriver;

  double distanceETA = 0;
  double durationEstimate = 0;
  DateTime arrivalTime = DateTime.now();
  bool stopEta = false;

  _ActiveTripState() {
    _presenter = ActiveTripPresenter(this);
    _panelController = PanelController();
    drawLine();
  }

  setBitmaps() async {
    imgDestination = BitmapDescriptor.fromBytes(await Util().getBytesFromCanvas(
        AppState.devicePixelRatio * 35, AppState.devicePixelRatio * 50, 'assets/images/start.png'));

    imgDriver = BitmapDescriptor.fromBytes(await Util().getBytesFromCanvas(
        AppState.devicePixelRatio * 35, AppState.devicePixelRatio * 50, 'assets/images/destination.png'));
  }

  animatedPopUp(message) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            decoration:
                BoxDecoration(color: AppColors.colorPrimary, borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Text(message, style: AppTextStyle.textWhiteSmallBold, maxLines: 2))
              ],
            )));
  }

  startListeningPusher() {
    AppState().streamController = StreamController<PusherResult>.broadcast();
    AppState().streamController.stream.asBroadcastStream().listen((data) {
      var pusher = PusherData.fromJson(data.data);
      switch (data.event) {
        case 'statusRoute':
          switch (pusher.data.status) {
            case 'refused':
              AppState().pusher.unSubscribeToAChannel(Settings.pusherDriverChannel + pusher.data.driverId);
              Navigator.pop(context);
              _canCancel = false;
              Util.showMessage(context, 'Atenção', 'O motorista recusou esta viagem');
              break;
            case 'accepted':
              setState(() {
                AppState().activeRoute.status = 'accepted';

                AppState().pusher.bindOnAChannel(
                    Settings.pusherDriverChannel + AppState().activeRoute.driver.id, 'driverPosition', true);

                AppState().pusher.bindOnAChannel(
                    Settings.pusherDriverChannel + AppState().activeRoute.driver.id, 'driverTrigger', true);

                seconds = 59;
                _canCancel = false;
                _panelController.close();
                _animatedPopUp =
                    animatedPopUp('O motorista já está a caminho, espere por ele no ponto de partida!');
              });
              break;
            case 'canceled':
              AppState().pusher.unSubscribeToAChannel(Settings.pusherDriverChannel + pusher.data.driverId);
              _canCancel = false;
              Navigator.pop(context);
              Util.showMessage(context, 'Atenção', 'Esta viagem foi cancelada');
              break;
            case 'in_progress':
              _canCancel = false;
              clearAnimatedPopUp();
              break;
            case 'finished':
              AppState().pusher.unSubscribeToAChannel(Settings.pusherDriverChannel + pusher.data.driverId);
              _canCancel = false;
              Navigator.pop(context);
              eventBus.fire(RouteFinishedEvent(id: AppState().activeRoute.id));
              break;
            case 'recalculating':
              setState(() {
                AppState().activeRoute.listPoints = Util.decodePolyline(pusher.data.newPolyline);
                AppState().activeRoute.travelledDistance = 0;
                if (AppState().activeRoute.status == 'in_progress') {
                  AppState().activeRoute.durationEstimate = pusher.data.duration;
                  AppState().activeRoute.distance = pusher.data.distance;
                } else {
                  AppState().activeRoute.distanceDriverToMe = pusher.data.distance;
                  AppState().activeRoute.durationDriverToMe = pusher.data.duration;
                }
                drawLine();
                updateMyPos();
                setPoints();
                setCameraPos();
                updateCamera();
              });
              break;
            default:
              break;
          }
          break;
        case 'driverPosition':
          if (pusher.command == 'waiting') {
            setState(() {
              AppState().activeRoute.listPoints.clear();
            });
            _animatedPopUp = animatedPopUp('O motorista acaba de chegar ao ponto de encontro!');
            clearAnimatedPopUp();
            return;
          } else {
            setState(() {
              AppState().activeRoute.driverLat = double.parse(pusher.data.lat);
              AppState().activeRoute.driverLong = double.parse(pusher.data.long);
              AppState().activeRoute.travelledDistance = double.parse(pusher.data.travelledDistance);
              drawLine();
              updateMyPos();
              setPoints();
              setCameraPos();
              updateCamera();
            });
          }
          break;
        case 'driverTrigger':
          setState(() {
            AppState().activeRoute.travelledDistance = 0;
            AppState().activeRoute.routePolyline = pusher.newPolyline;
            AppState().activeRoute.driverLat = double.parse(pusher.data.lat);
            AppState().activeRoute.driverLong = double.parse(pusher.data.long);
            AppState().activeRoute.marks.clear();
            AppState().activeRoute.listPoints = Util.decodePolyline(pusher.newPolyline);
            if (pusher.data.status == 'in_progress') {
              AppState().activeRoute.status = pusher.data.status;
              AppState().activeRoute.durationEstimate = pusher.durationEstimate;
              AppState().activeRoute.distance = pusher.distance;
              AppState().gpsStreamController = StreamController<double>.broadcast();
              AppState().gpsStreamController.stream.listen((d) {
                setState(() {
                  updateMyPos();
                  setPoints();
                  setCameraPos();
                  updateCamera();
                });
              });
            } else {
              AppState().activeRoute.durationDriverToMe = pusher.durationEstimate;
              AppState().activeRoute.distanceDriverToMe = pusher.distance;
              if (pusher.data.status == 'accepted') {
                AppState().activeRoute.status = pusher.data.status;
                startPeriodicETA();
              }
            }
            drawLine();
            updateMyPos();
            setPoints();
            setCameraPos();
            updateCamera();
          });
          break;
      }
    });
  }

  setPoints() {
    points.clear();
    if (AppState().activeRoute.listPoints.isEmpty) {
      points.add(Marker(
          markerId: MarkerId('User'),
          icon: imgDestination,
          position: LatLng(AppState.pos.latitude, AppState.pos.longitude)));
      return;
    }
    points.add(Marker(
        markerId: MarkerId('Driver'),
        icon: imgDriver,
        position: LatLng(AppState().activeRoute.listPoints.last.latitude,
            AppState().activeRoute.listPoints.last.longitude)));
    points.add(Marker(
        markerId: MarkerId('User'),
        icon: imgDestination,
        position: LatLng(AppState().activeRoute.listPoints.first.latitude,
            AppState().activeRoute.listPoints.first.longitude)));
  }

  updateMyPos() {
    if (AppState().activeRoute.listPoints.isEmpty || AppState().activeRoute.listPoints.length == 1) return;

    LatLng posPin1 = AppState().activeRoute.listPoints[0];
    double driverLat = AppState().activeRoute.driverLat;
    double driverLong = AppState().activeRoute.driverLong;

    double distancePin1 = Util.haversine(driverLat, driverLong, posPin1.latitude, posPin1.longitude) * 1000.0;

    LatLng posPin2 = AppState().activeRoute.listPoints[1];
    double distancePin2 = Util.haversine(driverLat, driverLong, posPin2.latitude, posPin2.longitude) * 1000.0;

    if (distancePin2 < distancePin1) {
      print('REMOVE FIRST POINT');
      if (AppState().activeRoute.listPoints.length > 1) AppState().activeRoute.listPoints.removeAt(0);
      return;
    }
  }

  setCameraPos() {
    if (AppState().activeRoute.listPoints.isEmpty) return;
    var center = Util.computeCentroid(AppState().activeRoute.listPoints);
    var distance = Util.distanceToCenter(center, AppState().activeRoute.listPoints);
    var zoom = Util.calculateZoomByWidthAndDistance(MediaQuery.of(context).size.width, distance);
    AppState().activeRoute.initialPosition = CameraPosition(target: center, zoom: zoom);
  }

  drawLine() {
    final PolylineId polylineId = PolylineId('linha1');

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: false,
      color: AppColors.colorPrimary,
      width: AppState.devicePixelRatio,
      points: AppState().activeRoute.listPoints,
    );

    polyLines[polylineId] = polyline;
  }

  canCancel() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      try {
        seconds++;
        if (seconds == 60) {
//          setState(() {
//            _canCancel = false;
//            _panelController.close();
//            _animatedPopUp = animatedPopUp('O motorista já está a caminho, espere por ele no ponto de partida!');
//          });
//          clearAnimatedPopUp();
          if (_canCancel) cancelRoute();
          t.cancel();
        }
        setState(() {
          time = (60 - seconds).toString();
        });
      } catch (ex) {
        t.cancel();
      }
    });
  }

  clearAnimatedPopUp() {
    setState(() {
      _animatedPopUp = SizedBox();
    });
  }

  cancelRoute() {
    _presenter.cancelRoute(AppState().activeRoute.id);
    setState(() {
      _isLoading = true;
    });
    AppState().pusher.unSubscribeToAChannel(Settings.pusherDriverChannel + AppState().activeRoute.driver.id);
  }

  startPeriodicETA() {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (!mounted)
        t.cancel();
      else
        calculateETA();
    });
  }

  calculateETA() {
    if (stopEta) {
      arrivalTime = DateTime.now();
      distanceETA = 0;
      durationEstimate = 0;
      AppState().activeRoute.travelledDistance = 0;
      return;
    }

    if (AppState().activeRoute.status == 'in_progress') {
      var a = AppState().activeRoute.distance - ((AppState().activeRoute.travelledDistance ?? 0) / 1000);
      distanceETA = a > 0 ? a : 0;
      durationEstimate = AppState().activeRoute.durationEstimate *
          distanceETA /
          (AppState().activeRoute.distance > 0 ? AppState().activeRoute.distance : 1);
      arrivalTime = DateTime.now().add(Duration(minutes: durationEstimate.round()));
    } else {
      var a = AppState().activeRoute.distanceDriverToMe -
          ((AppState().activeRoute.travelledDistance ?? 0) / 1000);
      distanceETA = a > 0 ? a : 0;
      durationEstimate = AppState().activeRoute.durationDriverToMe *
          distanceETA /
          (AppState().activeRoute.distanceDriverToMe > 0 ? AppState().activeRoute.distanceDriverToMe : 1);
      arrivalTime = DateTime.now().add(Duration(minutes: durationEstimate.round()));
    }
  }

  openChat() {
    eventBus.fire(CreateOrOpenNewChatEvent('route', AppState().activeRoute.id));
  }

  callDriver() {
    var phone = AppState().activeRoute.driver.phone.replaceAll('-', '');
    launch('tel://$phone');
  }

  Future<void> updateCamera() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(AppState().activeRoute.initialPosition));
  }

  init() async {
    await setBitmaps();
    setPoints();
    startListeningPusher();
    if (AppState().activeRoute.status == 'pending') {
      canCancel();
      Future.delayed(Duration(seconds: 2), () {
        _panelController.open();
      });
    } else
      _canCancel = false;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    AppState().streamController = null;
    AppState().gpsStreamController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
    calculateETA();
    Future.microtask(() {
      var center = Util.computeCentroid(AppState().activeRoute.listPoints);
      var distance = Util.distanceToCenter(center, AppState().activeRoute.listPoints);
      var zoom = Util.calculateZoomByWidthAndDistance(MediaQuery.of(context).size.width, distance);
      AppState().activeRoute.initialPosition = CameraPosition(target: center, zoom: zoom);
    });
  }

  isNullOrEmpty(dynamic val) {
    return val == null || val.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                  elevation: 0.0,
                ),
                preferredSize: Size.fromHeight(0.0)),
            body: _isLoading
                ? LoadingCircle()
                : SlidingUpPanel(
                    minHeight: MediaQuery.of(context).size.height * 0.15,
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                    backdropTapClosesPanel: !_canCancel,
                    parallaxEnabled: true,
                    color: Colors.transparent,
                    controller: _panelController,
                    parallaxOffset: 0.5,
                    backdropEnabled: true,
                    borderRadius: BorderRadius.circular(30.0),
                    panel: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: Colors.transparent,
                        child: Stack(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              decoration: BoxDecoration(
                                  gradient: appGradient,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 30.0),
                                    Text('Origem:', style: AppTextStyle.textPurpleSmallBold),
                                    Text(AppState().activeRoute.origin,
                                        style: AppTextStyle.textWhiteSmallBold,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Text('Destino:', style: AppTextStyle.textPurpleSmallBold),
                                    Text(AppState().activeRoute.destination,
                                        style: AppTextStyle.textWhiteSmallBold,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1),
                                    Container(
                                        height: 1,
                                        color: AppColors.colorWhite,
                                        margin: EdgeInsets.symmetric(vertical: 10.0)),
                                    Row(children: <Widget>[
                                      if (AppState().activeRoute.driver.photo != null)
                                        ClipOval(
                                          child: FadeInImage.assetNetwork(
                                              image: AppState().activeRoute.driver.photo,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              placeholder: 'assets/images/user.png'),
                                        )
                                      else
                                        ClipOval(
                                            child: Image(
                                                image: AssetImage('assets/images/user.png'), height: 40)),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                            Text(AppState().activeRoute.driver.name,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: AppTextStyle.textWhiteSmallBold),
                                            SizedBox(height: 5.0),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text(AppState().activeRoute.vehicle.model,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.clip,
                                                        style: AppTextStyle.textWhiteSmallBold)),
                                                Text('•', style: AppTextStyle.textWhiteSmallBold),
                                                SizedBox(width: 5.0),
                                                Text(AppState().activeRoute.vehicle.licensePlate,
                                                    style: AppTextStyle.textWhiteSmallBold),
                                                SizedBox(width: 5.0)
                                              ],
                                            )
                                          ]))
                                    ]),
                                    Container(
                                        height: 1,
                                        color: AppColors.colorWhite,
                                        margin: EdgeInsets.symmetric(vertical: 10.0)),
                                    _canCancel
                                        ? FlatButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () => cancelRoute(),
                                            child: Container(
                                                margin: EdgeInsets.only(bottom: 20.0),
                                                height: AppSizes.buttonHeight,
                                                decoration: BoxDecoration(
                                                    color: AppColors.colorPurple,
                                                    borderRadius: AppSizes.buttonCorner),
                                                child: Center(
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                      Text('Cancelar Corrida' + ' (' + time + ')',
                                                          style: AppTextStyle.textWhiteSmallBold)
                                                    ]))))
                                        : Container(
                                            padding: EdgeInsets.only(bottom: 20.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  GestureDetector(
                                                      onTap: () => openChat(),
                                                      child: Container(
                                                          padding: EdgeInsets.all(10.0),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border:
                                                                  Border.all(color: AppColors.colorWhite)),
                                                          child: Icon(MoveMeIcons.speech_bubble,
                                                              color: Colors.white))),
                                                  if (!isNullOrEmpty(AppState().activeRoute.driver.phone))
                                                    GestureDetector(
                                                        onTap: () => callDriver(),
                                                        child: Container(
                                                            padding: EdgeInsets.all(10.0),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                border:
                                                                    Border.all(color: AppColors.colorWhite)),
                                                            child: Icon(MoveMeIcons.phone_call,
                                                                color: Colors.white)))
                                                ]))
                                  ])),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.colorWhite,
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                          color: AppColors.colorPrimary, width: 1, style: BorderStyle.solid)),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            NumberFormat.currency(
                                                    locale: 'pt_BR',
                                                    name: '',
                                                    symbol: 'R\$',
                                                    decimalDigits: 2)
                                                .format(AppState().activeRoute.price),
                                            style: AppTextStyle.textPurpleSmallBold)
                                      ])))
                        ])),
                    collapsed: GestureDetector(
                        onTap: () => _panelController.open(),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                                gradient: appGradient,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 4.0,
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      decoration: BoxDecoration(
                                          color: Colors.white, borderRadius: BorderRadius.circular(30.0))),
                                  SizedBox(height: 15.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(durationEstimate.round().toString() + ' min',
                                          style: AppTextStyle.textWhiteSmallBold),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Text('•', style: AppTextStyle.textWhiteSmallBold)),
                                      Text(Util.timeHourFormatter.format(arrivalTime),
                                          style: AppTextStyle.textWhiteBigBold),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Text('•', style: AppTextStyle.textWhiteSmallBold)),
                                      Text(distanceETA.toStringAsFixed(1) + ' km',
                                          style: AppTextStyle.textWhiteSmallBold)
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Flexible(
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                        Flexible(
                                            child: Text(AppState().activeRoute.vehicle.model,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: AppTextStyle.textWhiteSmallBold)),
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                                            child: Text('•', style: AppTextStyle.textWhiteSmallBold)),
                                        Text(AppState().activeRoute.vehicle.licensePlate,
                                            maxLines: 1, style: AppTextStyle.textWhiteSmall),
                                      ]))
                                ]))),
                    body: Stack(
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: MapComponent(
                                points: points,
                                controller: mapController,
                                polyLines: polyLines,
                                showGoToStartButton: false,
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                                canAutoRefreshInitialPosition: false,
                                initialPosition: AppState().activeRoute.initialPosition,
                                listener: null)),
                        AnimatedSwitcher(duration: const Duration(milliseconds: 800), child: _animatedPopUp)
                      ],
                    ))));
  }

  @override
  void onCancelSuccess(ResponseServer result) {
    Navigator.pop(context);
  }

  @override
  void onError(String message) {
    // TODO: implement onError
  }

  @override
  void onGetChatSuccess(Chat data) {}
}
