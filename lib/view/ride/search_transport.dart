import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/ride.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'dart:async';

import 'package:moveme/view/route/trip_route_item.dart';

import 'available_transports/available_transports.dart';

class SearchTransport extends StatefulWidget {
  final List<Address> routes;
  final List<String> payments;
  final bool isHelicopter;

  SearchTransport(
      {@required this.routes,
      @required this.payments,
      this.isHelicopter = false});

  @override
  _SearchTransportState createState() => _SearchTransportState(
      routes: routes, payments: payments, isHelicopter: isHelicopter);
}

class _SearchTransportState extends BaseState<SearchTransport> {
  DateTime _dateTimePicked = new DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  DateTime _datePicked = new DateTime.now().add(new Duration(days: 31));
  final formatterDate = new DateFormat('yyyy-MM-dd');
  final formatterTime = new DateFormat('HH:mm');
  Ride model;
  int people = 1;
  int maxPeople = 6;
  List<Address> routes;
  List<String> payments;
  bool isHelicopter;

  _SearchTransportState({this.routes, this.payments, this.isHelicopter});

  changePeopleQuantity(bool add) {
    setState(() {
      people = people + (add ? 1 : -1);
      if (people == 0) people = 1;
      if (people == maxPeople + 1) people = maxPeople;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay(
            hour: _dateTimePicked.hour, minute: _dateTimePicked.minute));

    if (picked != null) {
      setState(() {
        _dateTimePicked =
            new DateTime(0, 0, 0, picked.hour, picked.minute, 0, 0, 0);
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _datePicked,
        firstDate: _datePicked,
        lastDate: _datePicked.add(new Duration(days: 720)));

    if (picked != null) {
      setState(() {
        _datePicked = picked;
        _dateTimePicked = new DateTime(_datePicked.year, _datePicked.month,
            _datePicked.day, _dateTimePicked.hour, _dateTimePicked.minute);
      });
    }
  }

  searchRides() {
    model = new Ride();
    model.date = formatterDate.format(_datePicked);
    model.time = formatterTime.format(_dateTimePicked);
    model.reservations = people;
    model.payment = payments.first;

    model.points = [];

    routes.asMap().forEach((index, r) {
      if (index == 0) {
        model.lat = r.lat;
        model.long = r.long;
      } else {
        model.destiny = new Ride();
        model.destiny.lat = r.lat;
        model.destiny.long = r.long;
      }
      model.points.add(new Address(
          order: index, lat: r.lat, long: r.long, address: r.address));
    });

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new AvailableTransports(ride: model)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        title: new Text(
            isHelicopter ? 'Procurar Helicóptero' : 'Procurar Carona',
            style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: new ListView(
          children: <Widget>[
            new TripRouteItem(routes: routes),
            new Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              margin: EdgeInsets.symmetric(vertical: 8),
              height: 1.0,
            ),
            new FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                _selectDate(context);
              },
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Data:',
                            style: AppTextStyle.textWhiteSmallBold),
                        new Text(Util.dateTimeFormatter.format(_datePicked),
                            style: AppTextStyle.textWhiteSmall),
                      ],
                    ),
                  ),
                  new Icon(Icons.arrow_forward_ios,
                      size: 16.0, color: AppColors.colorWhite)
                ],
              ),
            ),
            new Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              margin: EdgeInsets.symmetric(vertical: 8),
              height: 1.0,
            ),
            new FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                _selectTime(context);
              },
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Horário:',
                            style: AppTextStyle.textWhiteSmallBold),
                        new Text(Util.timeFormatter.format(_dateTimePicked),
                            style: AppTextStyle.textWhiteSmall),
                      ],
                    ),
                  ),
                  new Icon(Icons.arrow_forward_ios,
                      size: 16.0, color: AppColors.colorWhite)
                ],
              ),
            ),
            isHelicopter
                ? new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  )
                : new SizedBox(),
            isHelicopter
                ? new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {},
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('Bagagem:',
                                  style: AppTextStyle.textWhiteSmallBold),
                              new Text('Insira o peso da sua bagagem',
                                  style: AppTextStyle.textWhiteSmall),
                            ],
                          ),
                        ),
                        new Icon(Icons.arrow_forward_ios,
                            size: 16.0, color: AppColors.colorWhite)
                      ],
                    ),
                  )
                : new SizedBox(),
            new Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              margin: EdgeInsets.symmetric(vertical: 8),
              height: 1.0,
            ),
            new Text('Número de Reservas:',
                style: AppTextStyle.textWhiteSmallBold),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(people.toString() + ' Pessoas',
                          style: AppTextStyle.textWhiteSmall),
                    ],
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new IconButton(
                      iconSize: 16,
                      onPressed: () {
                        changePeopleQuantity(false);
                      },
                      icon: new Icon(Icons.remove,
                          size: 16.0, color: AppColors.colorWhite),
                    ),
                    new Container(
                        padding: EdgeInsets.all(0.0),
                        height: 27.0,
                        width: 27.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.colorWhite,
                                style: BorderStyle.solid,
                                width: 1.0),
                            borderRadius: AppSizes.buttonCorner * 0.30),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(people.toString(),
                                style: AppTextStyle.textWhiteExtraSmallBold),
                          ],
                        )),
                    new IconButton(
                      iconSize: 16,
                      onPressed: () {
                        changePeopleQuantity(true);
                      },
                      icon: new Icon(Icons.add,
                          size: 16.0, color: AppColors.colorWhite),
                    ),
                  ],
                ),
              ],
            ),
            new Container(
              decoration: BoxDecoration(color: AppColors.colorWhite),
              margin: EdgeInsets.only(top: 8, bottom: 20.0),
              height: 1.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.colorGradientSecondary,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: new FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => searchRides(),
            child: new Container(
                height: AppSizes.buttonHeight,
                decoration: BoxDecoration(
                    color: AppColors.colorBlueLight,
                    borderRadius: AppSizes.buttonCorner),
                child: new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('Procurar',
                          style: AppTextStyle.textWhiteSmallBold)
                    ],
                  ),
                ))),
      ),
    );
  }
}
