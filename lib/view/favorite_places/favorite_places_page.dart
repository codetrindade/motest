import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/theme.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'create_favorite_place.dart';

class FavoritePlacesPage extends StatefulWidget {
  @override
  _FavoritePlacesPageState createState() => _FavoritePlacesPageState();
}

class _FavoritePlacesPageState extends BaseState<FavoritePlacesPage> {
  AppBloc bloc;

  Address job;
  Address house;
  List<Address> addresses = List<Address>();
  bool _isLoading = true;

  //AppData appData;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadList());
    //appData = locator.get<AppData>();
    //loadList();
  }

  openCreate(Address address) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFavoritePlace(model: address)));

    loadList();
  }

  loadList() async {
    job = Address(address: 'Definir local...', alias: 'Trabalho', mainAddress: true, type: 'job');
    house = Address(address: 'Definir local...', alias: 'Casa', mainAddress: true, type: 'house');
    addresses = List<Address>();
    await bloc.loadAddresses();
    bloc.appData.addresses.asMap().forEach((index, address) {
      switch (address.type) {
        case 'house':
          house = address;
          house.mainAddress = true;
          break;
        case 'job':
          job = address;
          job.mainAddress = true;
          break;
        default:
          address.mainAddress = false;
          addresses.add(address);
          break;
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  void refreshList() {
    _isLoading = true;
    job = Address(address: 'Definir local...', alias: 'Trabalho', mainAddress: true, type: 'job');
    house = Address(address: 'Definir local...', alias: 'Casa', mainAddress: true, type: 'house');

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);

    return Scaffold(
      appBar: AppBarCustom(
          title: 'Locais favoritos', preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: _isLoading
          ? LoadingCircle()
          : Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      children: getAddress(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: FlatButton(
                      onPressed: () => openCreate(Address(
                          alias: 'Novo Local', type: 'others', address: 'Endereço do Local', mainAddress: false)),
                      child: Container(
                          height: AppSizes.buttonHeight,
                          decoration: BoxDecoration(color: AppColors.colorPrimary, borderRadius: AppSizes.buttonCorner),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text('Adicionar local', style: AppTextStyle.textWhiteExtraSmallBold)],
                            ),
                          ))),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            ),
    );
  }

  List<Widget> getAddress() {
    var items = List<Widget>();

    items.addAll([
      SizedBox(height: 20.0),
      Text('Favoritos', style: AppTextStyle.textBlueLightSmallBold),
      SizedBox(height: 5.0),
      //HOUSE
      GestureDetector(
        onTap: () => openCreate(Address.fromJson(house.toJson())),
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            children: <Widget>[
              Icon(MoveMeIcons.home, color: AppColors.colorPrimary),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Casa', style: AppTextStyle.textPurpleSmallBold),
                    Text(house.address,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyle.textGreyExtraSmall),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.arrow_forward_ios), iconSize: 16.0, onPressed: null)
            ],
          ),
        ),
      ),
      //JOB
      GestureDetector(
        onTap: () => openCreate(Address.fromJson(job.toJson())),
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          margin: EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            children: <Widget>[
              Icon(MoveMeIcons.work, color: AppColors.colorPrimary),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Trabalho', style: AppTextStyle.textPurpleSmallBold),
                    Text(job.address,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyle.textGreyExtraSmall),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.arrow_forward_ios), iconSize: 16.0, onPressed: null)
            ],
          ),
        ),
      ),
      //OTHERS
      Text('Outros locais salvos', style: AppTextStyle.textBlueLightSmallBold),
      SizedBox(height: 5.0),
    ]);

    addresses.forEach((item) {
      items.add(GestureDetector(
        onTap: () => openCreate(Address.fromJson(item.toJson())),
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            children: <Widget>[
              Icon(MoveMeIcons.star, color: AppColors.colorPrimary),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.alias, style: AppTextStyle.textPurpleSmallBold),
                    Text(item.address,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyle.textGreyExtraSmall),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.arrow_forward_ios), iconSize: 16.0, onPressed: null)
            ],
          ),
        ),
      ));
    });

    return items;
  }
}
