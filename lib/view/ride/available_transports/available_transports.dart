import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/presenter/available_transports_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/ride/available_transports/available_transports_item.dart';
import 'package:moveme/view/route/trip_route_item.dart';

import 'available_transports_view.dart';

class AvailableTransports extends StatefulWidget {
  final Ride ride;

  AvailableTransports({@required this.ride});

  @override
  _AvailableTransportsState createState() =>
      _AvailableTransportsState(ride: ride);
}

class _AvailableTransportsState extends BaseState<AvailableTransports>
    implements AvailableTransportsView {
  Ride ride;
  AvailableTransportsPresenter _presenter;
  bool _isLoading = true;
  List<Ride> ridesAvailable = [];

  _AvailableTransportsState({this.ride}) {
    _presenter = new AvailableTransportsPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.find(ride);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? new Container(
            color: Colors.white,
            child: new Center(
              child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.colorPrimary)),
            ),
          )
        : new Scaffold(
            appBar: new AppBar(
              backgroundColor: AppColors.colorBlueDark,
              elevation: 0.0,
              centerTitle: true,
              leading: new IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: AppColors.colorWhite, size: 16.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: new Text('Procurar Transporte',
                  style: AppTextStyle.textWhiteSmallBold),
            ),
            body: Container(
              child: new Column(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                        color: AppColors.colorBlueDark,
                        borderRadius: BorderRadius.vertical(
                            bottom:
                                Radius.circular(AppSizes.buttonCornerDouble))),
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new TripRouteItem(routes: ride.points),
                        new Container(
                          decoration:
                              BoxDecoration(color: AppColors.colorWhite),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 1.0,
                        ),
                        new Text('Data:',
                            style: AppTextStyle.textWhiteSmallBold),
                        new SizedBox(height: 5.0),
                        new Text(Util.convertDateFromString(ride.date) + ' ' + ride.time,
                            maxLines: 2,
                            style: AppTextStyle.textWhiteExtraSmall),
                        new SizedBox(height: 15.0)
                      ],
                    ),
                  ),
                  new Flexible(
                      child: Center(
                        child: ridesAvailable.isEmpty
                            ? new Text('Nenhum transporte encontrado',
                                style: AppTextStyle.textGreySmallBold)
                            : new ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: ridesAvailable.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return new AvailableTransportsItem(
                                      model: ridesAvailable[index],
                                      last: index == ridesAvailable.length - 1, payment: ride.payment);
                                }),
                      ))
                ],
              ),
            ),
          );
  }

  @override
  void onListTransportsSuccess(List<Ride> result) {
    setState(() {
      result.forEach((r) => r.reservations = ride.reservations);
      ridesAvailable = result;
      _isLoading = false;
    });
  }
}
