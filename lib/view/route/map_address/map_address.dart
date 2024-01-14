import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/maps/map_component.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/presenter/map_address_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:uuid/uuid.dart';

import 'map_address_view.dart';

class MapAddress extends StatefulWidget {
  final Address selectedAddress;

  MapAddress({this.selectedAddress});

  @override
  _MapAddressState createState() => _MapAddressState(selectedAddress: selectedAddress);
}

class _MapAddressState extends BaseState<MapAddress> implements OnMapChanged, MapAddressView {
  AppData appData;

  CameraPosition _newPosition;
  CameraPosition initialPosition;

  MapAddressPresenter _presenter;

  bool _isSearching = false;
  Address selectedAddress;

  _MapAddressState({this.selectedAddress}) {
    appData = locator.get<AppData>();
    _presenter = new MapAddressPresenter(this);

    if (selectedAddress != null) {
      initialPosition = new CameraPosition(
        target: LatLng(selectedAddress.lat, selectedAddress.long),
        zoom: 18,
      );
      _newPosition = initialPosition;
    } else {
      selectedAddress = new Address(address: 'Qual é o seu destino?', id: new Uuid().v1());
      initialPosition = new CameraPosition(
        target: appData.pos,
        zoom: 18,
      );
    }
  }

  void onSelectAddress() {
    if (_isSearching) return;
    if (_newPosition == null) {
      Util.showMessage(context, 'Atenção', 'Mova o mapa para selecionar um destino!');
      return;
    }
    selectedAddress.lat = _newPosition.target.latitude;
    selectedAddress.long = _newPosition.target.longitude;
    Navigator.pop(context, selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: new Text('Escolha seu destino', style: AppTextStyle.textWhiteSmallBold),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            child: new Stack(
              children: <Widget>[
                new MapComponent(
                    canAutoRefreshInitialPosition: false, initialPosition: initialPosition, listener: this),
                new Center(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 40.0),
                        child: new Icon(Icons.location_on, size: 50.0, color: AppColors.colorPrimary))),
              ],
            ),
          ),
          new Stack(
            children: <Widget>[
              new Container(
                height: MediaQuery.of(context).size.height * 0.05,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
              ),
              /*new Container(
                margin: EdgeInsets.only(top: 30.0),
                child: new IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 16.0),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),*/
              new Container(
                height: MediaQuery.of(context).size.height * 0.08,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    color: AppColors.colorWhite,
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1)),
                child: new Center(
                  child: new Text(
                    selectedAddress.address,
                    style: AppTextStyle.textGreySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: new FlatButton(
                onPressed: onSelectAddress,
                child: new Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                  decoration:
                      new BoxDecoration(color: AppColors.colorPrimary, borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(_isSearching ? 'Procurando...' : 'Confirmar', style: AppTextStyle.textBoldWhiteMedium),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void onMapChanged(CameraPosition newPosition) {
    if (newPosition == null) return;
    setState(() {
      _newPosition = newPosition;
      selectedAddress.address = 'Procurando...';
      _isSearching = true;
      selectedAddress.lat = null;
      selectedAddress.long = null;
    });
    _presenter.getFromCoordinates(new Address(lat: _newPosition.target.latitude, long: _newPosition.target.longitude));
  }

  @override
  void onError(String message) {
    setState(() {
      selectedAddress.address = 'Qual é o seu destino?';
      _isSearching = false;
    });
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onGetFromCoordinatesSuccess(Address address) {
    setState(() {
      _isSearching = false;
      selectedAddress.address = address.address;
      selectedAddress.lat = address.lat;
      selectedAddress.long = address.long;
    });
  }
}
