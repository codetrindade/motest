import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/core/bloc/route/route_create_bloc.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/preview_body.dart';
import 'package:moveme/model/promocode.dart';
import 'package:moveme/theme.dart';

import 'package:moveme/view/route/active_trip/active_trip.dart';
import 'package:moveme/view/route/available_drivers_item.dart';
import 'package:moveme/view/route/trip_route_item.dart';
import 'package:moveme/widgets/loading_circle.dart';
import 'package:moveme/widgets/promocode_sheet.dart';
import 'package:provider/provider.dart';

class TripDriversList extends StatefulWidget {
  final List<Address> routes;
  final String gender;
  final String payment;
  final String cardId;

  TripDriversList({@required this.routes, @required this.payment, @required this.gender, @required this.cardId});

  @override
  _TripDriversListState createState() =>
      _TripDriversListState(routes: routes, payment: payment, gender: gender, cardId: cardId);
}

class _TripDriversListState extends BaseState<TripDriversList>
    with TickerProviderStateMixin
    implements AvailableDriverListener, RouteCreatedListener {
  RouteCreateBloc bloc;

  // todo remove from here
  List<Address> routes;
  String gender;
  String payment;
  String cardId;

  Animation<double> animation;
  AnimationController controller;

  _TripDriversListState({this.routes, this.payment, this.gender, this.cardId});

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      bloc.gender = this.gender;
      bloc.payment = this.payment;
      bloc.cardId = this.cardId;
      bloc.routes = this.routes;
      await bloc.getPromoCodes();
      await bloc.getDriversList(PreviewBody(payment: payment, payments: [payment], points: routes, gender: gender));
    });

    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 150.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> onConfirm() async {
    if (bloc.promocodes.isNotEmpty) {
      showPromoCodeSheet();
      return;
    }

    await createRoute(null);
  }

  Future<void> createRoute(Promocode code) async {
    controller.reverse();
    await bloc.createRoute(listener: this, code: code);
  }

  void showPromoCodeSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return PromocodeSheet(callback: (voucher) {
            createRoute(voucher);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RouteCreateBloc>(context);

    return bloc.isLoading
        ? LoadingCircle()
        : Material(
            color: AppColors.colorPrimary,
            child: SafeArea(
                child: Scaffold(
                    body: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                                backgroundColor: Colors.white,
                                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                                pinned: false,
                                floating: true,
                                elevation: 0.0,
                                automaticallyImplyLeading: false,
                                forceElevated: boxIsScrolled,
                                flexibleSpace: FlexibleSpaceBar(
                                    background: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.colorPrimary,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(top: 0.0),
                                              child: IconButton(
                                                  icon: Icon(Icons.arrow_back_ios,
                                                      color: AppColors.colorWhite, size: 16.0),
                                                  onPressed: () => Navigator.pop(context))),
                                          Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: 10, right: 30.0),
                                                  padding: EdgeInsets.only(bottom: 15.0),
                                                  child: TripRouteItem(routes: routes)))
                                        ]))))
                          ];
                        },
                        body: (bloc.model.drivers.isEmpty
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text('Não existem motoristas disponíveis nesta área no momento',
                                    textAlign: TextAlign.center, style: AppTextStyle.textBlueBold),
                              ))
                            : Column(children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                Flexible(
                                    child: ListView.builder(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        itemCount: bloc.model.drivers.length,
                                        itemBuilder: (BuildContext ctx, int index) {
                                          return AvailableDriversItem(model: bloc.model.drivers[index], listener: this);
                                        })),
                                SizedBox(height: 80)
                              ]))),
                    bottomSheet: Container(
                        transform: Matrix4.identity()..translate(0.0, animation != null ? animation.value : 0.0, 0.0),
                        color: Colors.white,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                            child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () => onConfirm(),
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                                    height: AppSizes.buttonHeight,
                                    decoration: BoxDecoration(
                                        color: AppColors.colorBlueLight, borderRadius: AppSizes.buttonCorner),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Confirmar Corrida', style: AppTextStyle.textWhiteSmallBold)
                                      ],
                                    )))))))));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void onChosen(String id) {
    bloc.setDriverChosen(id);
    controller.forward();
  }

  @override
  void onCreateRouteSuccess() {
    Navigator.of(context).pushReplacement(
        PageTransition(type: PageTransitionType.slideInUp, duration: Duration(milliseconds: 300), child: ActiveTrip()));
  }
}

abstract class RouteCreatedListener {
  void onCreateRouteSuccess();
}
