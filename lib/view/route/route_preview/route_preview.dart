import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/maps/map_component.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/payment.dart';
import 'package:moveme/model/preview.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/model/routeobj.dart';
import 'package:moveme/presenter/route_preview_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/login/sms_page.dart';
import 'package:moveme/view/payment/card_list_page.dart';
import 'package:moveme/view/route/route_preview/route_preview_view.dart';
import 'package:moveme/view/route/trip_drivers/trip_drivers_list.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:moveme/view/ride/search_transport.dart';

class RoutePreview extends StatefulWidget {
  final List<Address> routes;

  RoutePreview({@required this.routes});

  @override
  _RoutePreviewState createState() => _RoutePreviewState(routes: routes);
}

class _RoutePreviewState extends BaseState<RoutePreview> implements RoutePreviewView, OnMapChanged {
  AppBloc bloc;
  bool _isLoading = true;
  List<Address> routes;
  List<Payment> paymentWays = new List<Payment>();
  String paymentChosen;
  String cardId;

  PanelController _controller;
  PageController _pageController;

  RoutePreviewPresenter _presenter;

  _RoutePreviewState({this.routes}) {
    _presenter = new RoutePreviewPresenter(this);
    _controller = new PanelController();
  }

  bool verifyPending() {
    if (bloc.appData.user.status == 'register') {
      Util.showMessage(context, 'Atenção', 'Conclua sua ativação para usar esta funcionalidade!');
      Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.slideInUp,
          duration: Duration(milliseconds: 300),
          child: SmsPage(fromProfile: true)));
      return true;
    }
    return false;
  }

  Widget panelGenre() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('Gênero do motorista', style: AppTextStyle.textWhiteSmallBold),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.slideInUp,
                duration: Duration(milliseconds: 300),
                child: TripDriversList(routes: routes, payment: paymentChosen, gender: 'whatever', cardId: cardId)));
          },
          padding: EdgeInsets.all(0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(30.0)),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('Não Filtrar', style: AppTextStyle.textWhiteSmall)),
                Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
              ],
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.slideInUp,
                duration: Duration(milliseconds: 300),
                child: TripDriversList(routes: routes, payment: paymentChosen, gender: 'female', cardId: cardId)));
          },
          padding: EdgeInsets.all(0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(30.0)),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('Feminino', style: AppTextStyle.textWhiteSmall)),
                Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
              ],
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.slideInUp,
                duration: Duration(milliseconds: 300),
                child: TripDriversList(routes: routes, payment: paymentChosen, gender: 'male', cardId: cardId)));
          },
          padding: EdgeInsets.all(0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(30.0)),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('Masculino', style: AppTextStyle.textWhiteSmall)),
                Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget panelModal() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Viagens instantâneas', style: AppTextStyle.textWhiteSmallBold),
          FlatButton(
            onPressed: () {
              if (verifyPending()) return;
              if (!verifyPayments()) return;
              this.changePage(2);
            },
            padding: EdgeInsets.all(0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/icons/car_compact_branco.png'),
                    height: 10.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(child: Text('Automóvel', style: AppTextStyle.textWhiteSmall)),
                  Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Viagens Programadas', style: AppTextStyle.textWhiteSmallBold),
          FlatButton(
            onPressed: () {
              if (verifyPending()) return;
              if (routes.length > 2) {
                Util.showMessage(context, 'Atenção', 'Só é permitido escolher 1 destino para esta categoria');
                return;
              }
              Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 300),
                  child: SearchTransport(routes: routes, payments: [paymentChosen])));
            },
            padding: EdgeInsets.all(0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/icons/car_compact_branco.png'),
                    height: 10.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(child: Text('Carona', style: AppTextStyle.textWhiteSmall)),
                  Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
                ],
              ),
            ),
          ),
          /*FlatButton(
            onPressed: () {
              if (verifyPending()) return;
              if (routes.length > 2) {
                Util.showMessage(context, 'Atenção', 'Só é permitido escolher 1 destino para esta categoria');
                return;
              }
              Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.slideInUp,
                  duration: Duration(milliseconds: 300),
                  child: SearchTransport(routes: routes, payments: paymentChosen, isHelicopter: true)));
            },
            padding: EdgeInsets.all(0),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/icons/car_compact_branco.png'),
                    height: 10.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(child: Text('Helicóptero', style: AppTextStyle.textWhiteSmall)),
                  Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 16)
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget panelPayment() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: getPaymentWays()),
    );
  }

  List<Widget> getPaymentWays() {
    var payments = List<Widget>();

    payments
        .add(Text('Forma de pagamento', style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center));

    paymentWays.forEach((item) {
      payments.add(FlatButton(
        onPressed: () => setActivePayment(item),
        padding: EdgeInsets.all(0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding:
              EdgeInsets.symmetric(horizontal: 15.0, vertical: MediaQuery.of(context).size.height * 0.01),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorWhite, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            children: <Widget>[
              Icon(getIcon(item.payment), color: Colors.white, size: 30.0),
              SizedBox(width: 20.0),
              Expanded(child: Text(item.translated, style: AppTextStyle.textWhiteSmall)),
              item.chosen ? Icon(Icons.done, color: AppColors.colorWhite, size: 16) : SizedBox()
            ],
          ),
        ),
      ));
    });

    return payments;
  }

  IconData getIcon(String payment) {
    switch (payment) {
      case 'online':
        return Icons.add_to_home_screen;
      case 'money':
        return MoveMeIcons.banknote;
      default:
        return Icons.credit_card;
    }
  }

  bool verifyPayments() {
    paymentWays.forEach((pay) {
      if (pay.chosen) paymentChosen = pay.payment;
    });

    if (paymentChosen.isEmpty) {
      changePage(0);
      Util.showMessage(context, 'Atenção', 'Escolha pelo menos uma forma de pagamento');
      return false;
    }

    changePage(1);
    return true;
  }

  changePage(int page) {
    setState(() {
      _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  setActivePayment(Payment p) async {
    if (p.payment == 'online') {
      this.cardId = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CardListPage(isSelection: true)));
      if (cardId == null) return;
    }

    paymentWays.forEach((pa) {
      pa.chosen = false;
    });
    paymentWays.firstWhere((pa) => pa.payment == p.payment).chosen = true;
    setState(() {});
    verifyPayments();
  }

  doPreviewAction(Preview preview) async {
    AppState().activeRoute = new RouteObj();
    try {
      for (int i = 0; i < routes.length; i++) {
        await setPoints(i, routes.length);
      }

      AppState().activeRoute.listPoints = Util.decodePolyline(preview.trip.polyline);
      var center = Util.computeCentroid(AppState().activeRoute.listPoints);
      var distance = Util.distanceToCenter(center, AppState().activeRoute.listPoints);
      var zoom = Util.calculateZoomByWidthAndDistance(MediaQuery.of(context).size.width, distance);

      AppState().activeRoute.initialPosition = new CameraPosition(target: center, zoom: zoom);
      _isLoading = false;
      setState(() {});

      AppState().activeRoute.routePolyline = preview.trip.polyline;

      Future.delayed(Duration(seconds: 2), () async {
        setState(() {});
        _controller.open();
      });
    } catch (ex) {
      if (ex != null)
        Util.showMessage(
            context, 'Erro', 'Ocorreu um erro inesperado, por favor contate nosso suporte! ' + ex.toString());
      else
        Util.showMessage(context, 'Erro', 'Ocorreu um erro inesperado, por favor contate nosso suporte!');
      print(ex);
    }
  }

  setPoints(int i, int count) async {
    String asset;
    switch (i) {
      case 3:
        asset = 'assets/images/destination.png';
        break;
      case 2:
        asset = count == 3 ? 'assets/images/destination.png' : 'assets/images/stop2.png';
        break;
      case 1:
        asset = count == 2 ? 'assets/images/destination.png' : 'assets/images/stop1.png';
        break;
      case 0:
        asset = 'assets/images/start.png';
        break;
    }

    BitmapDescriptor img = BitmapDescriptor.fromBytes(await Util()
        .getBytesFromCanvas(AppState.devicePixelRatio * 35, AppState.devicePixelRatio * 50, asset));

    AppState().activeRoute.marks.add(new Marker(
        markerId: new MarkerId(routes[i].id),
        position: new LatLng(routes[i].lat, routes[i].long),
        icon: img));
  }

  drawLine() {
    Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
    final PolylineId polylineId = PolylineId('linha1');

    final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: false,
        color: AppColors.colorBlueDark,
        width: AppState.devicePixelRatio,
        points: AppState().activeRoute.listPoints);

    polyLines[polylineId] = polyline;

    return polyLines;
  }

  @override
  void initState() {
    super.initState();
    _presenter.listPayments();
    _pageController = new PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    return _isLoading
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary))))
        : Scaffold(
            appBar: PreferredSize(child: AppBar(elevation: 0.0), preferredSize: Size.fromHeight(0.0)),
            body: Stack(children: <Widget>[
              SlidingUpPanel(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  minHeight: MediaQuery.of(context).size.height * 0.1,
                  controller: _controller,
                  color: Colors.transparent,
                  parallaxEnabled: true,
                  parallaxOffset: 0.5,
                  panel: Container(
                      decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0))),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _controller.close();
                              },
                              child: Container(
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 13.0,
                                          bottom: 13.0,
                                          left: MediaQuery.of(context).size.width * 0.44,
                                          right: MediaQuery.of(context).size.width * 0.44),
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      decoration: BoxDecoration(
                                          color: Colors.white, borderRadius: BorderRadius.circular(8.0))))),
                          Expanded(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: AppColors.colorPrimary,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0))),
                                  child: PageView(
                                    controller: _pageController,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[panelPayment(), panelModal(), panelGenre()],
                                  )))
                        ],
                      )),
                  collapsed: Container(
                      decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0))),
                      child: FlatButton(
                          onPressed: () => _controller.open(),
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                Container(
                                    height: MediaQuery.of(context).size.height * 0.04,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 13.0,
                                            bottom: 7.0,
                                            left: MediaQuery.of(context).size.width * 0.3,
                                            right: MediaQuery.of(context).size.width * 0.3),
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        decoration: BoxDecoration(
                                            color: Colors.white, borderRadius: BorderRadius.circular(8.0)))),
                                Text('Escolher modalidade', style: AppTextStyle.textBoldWhiteMedium),
                              ])))),
                  body: Container(
                      child: MapComponent(
                          points: AppState().activeRoute.marks,
                          canAutoRefreshInitialPosition: false,
                          polyLines: drawLine(),
                          initialPosition: AppState().activeRoute.initialPosition,
                          listener: this))),
              Container(
                  margin: EdgeInsets.only(top: 20.0, left: 10.0),
                  //padding: EdgeInsets.only(right: 5.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorPrimary),
                  child: IconButton(
                      padding: EdgeInsets.only(left: 6),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.0),
                      onPressed: () {
                        if (_pageController.page == 1)
                          changePage(0);
                        else if (_pageController.page == 2)
                          changePage(1);
                        else
                          Navigator.pop(context);
                      }))
            ]));
  }

  @override
  void onError(String message) {
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onGetPreviewSuccess(Preview preview) {
    doPreviewAction(preview);
  }

  @override
  void onMapChanged(CameraPosition newPosition) {
    // TODO: implement onMapChanged
  }

  @override
  void onListPaymentSuccess(List<Payment> result) {
    paymentWays = result;
    var body = new PreviewBody();
    body.points = routes;
    _presenter.getPreview(body);
  }
}
