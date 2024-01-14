import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/component/maps/map_component.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/presenter/home_page_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/address_route/address_route_page.dart';
import 'package:moveme/view/favorite_places/create_favorite_place.dart';
import 'package:moveme/view/route/route_preview/route_preview.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../../app_state.dart';
import 'home_page_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> implements OnMapChanged {
  AppBloc bloc;

  openOrigin() {
    Navigator.of(context).push(PageTransition(
        type: PageTransitionType.slideInUp,
        duration: Duration(milliseconds: 300),
        child: AddressRoutePage(myAddressNow: bloc.appData.myAddressNow, isEditingOrigin: true)));
  }

  openDestiny() {
    Navigator.of(context).push(PageTransition(
        type: PageTransitionType.slideInUp,
        duration: Duration(milliseconds: 300),
        child: AddressRoutePage(myAddressNow: bloc.appData.myAddressNow, isEditingOrigin: false)));
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    return Stack(children: <Widget>[
      // MAP
      Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: bloc.isLoadingGPS
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary)))
              : Stack(children: [
                  MapComponent(
                      canAutoRefreshInitialPosition: true,
                      initialPosition:
                          CameraPosition(target: bloc.appData.pos, zoom: bloc.appData.zoom),
                      listener: this),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 40.0),
                          child: Icon(Icons.location_on, size: 50.0, color: AppColors.colorPrimary))),
                ])),
      // ADDRESS FAVORITE
      Container(
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                FlatButton(
                    onPressed: () => openOrigin(),
                    padding: EdgeInsets.all(0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                      SizedBox(width: 15.0),
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 14.0),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text(bloc.appData.myAddressNow.alias == null ? 'Origem' : bloc.appData.myAddressNow.alias,
                                style: AppTextStyle.textWhiteSmallBold),
                            Text(bloc.appData.myAddressNow.address ?? 'Aguarde',
                                maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true, style: AppTextStyle.textWhiteSmall)
                          ])),
                      Icon(Icons.arrow_forward_ios, color: AppColors.colorWhite, size: 14.0),
                      SizedBox(width: 14.0)
                    ]))
              ])),
      // DESTINY
      Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, left: 20.0, right: 20.0),
          child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => openDestiny(),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  decoration: BoxDecoration(
                      color: AppColors.colorWhite,
                      border: Border.all(color: AppColors.colorPrimary),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                      children: <Widget>[Expanded(child: Text('Qual é o seu destino?', style: AppTextStyle.textGreySmall))]))))
    ]);
  }

  @override
  void onMapChanged(CameraPosition newPosition) {
    if (newPosition == null) return;
    setState(() {
      bloc.appData.myAddressNow.address = 'Procurando...';
      bloc.appData.myAddressNow.lat = newPosition.target.latitude;
      bloc.appData.myAddressNow.lng = newPosition.target.longitude;
      bloc.getAddressNow();
    });
  }
}
