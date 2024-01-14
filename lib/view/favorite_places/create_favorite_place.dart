import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/presenter/create_favorite_place_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/route/address_item.dart';
import 'package:moveme/view/route/map_address/map_address.dart';

import 'create_favorite_place_view.dart';

class CreateFavoritePlace extends StatefulWidget {
  final Address model;
  //final Function parentRefresh;

  CreateFavoritePlace({@required this.model});

  @override
  _CreateFavoritePlaceState createState() =>
      _CreateFavoritePlaceState(model: model);
}

class _CreateFavoritePlaceState extends BaseState<CreateFavoritePlace>
    with TickerProviderStateMixin
    implements CreateFavoritePlaceView, SelectedPlaceListener {

  Timer _debounce;
  var _address = new TextEditingController();
  var _alias = new TextEditingController();

  bool _isSearchingAddress = false;
  bool _isLoading = false;
  String _searchAddress;
  CreateFavoritePlacePresenter _presenter;
  List<AddressItem> addressSearchResult = new List<AddressItem>();
  Animation<double> animation;
  AnimationController controller;

  bool typingAlias = false;
  bool typingAddress = false;
  bool isBottomSheetVisible = false;

  Address model;

  _CreateFavoritePlaceState({this.model}) {
    _presenter = new CreateFavoritePlacePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _address.addListener(_onSearchChanged);

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 150.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    if (model.id != null && model.id.isNotEmpty) {
      setState(() {
        _alias.text = model.alias;
        controller.forward();
        isBottomSheetVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _address.removeListener(_onSearchChanged);
    _address.dispose();
    controller.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_address.text.length > 5) {
        if (_searchAddress != _address.text) {
          setState(() {
            _isSearchingAddress = true;
          });
          _presenter
              .getAutoCompleteResults(new Address(address: _address.text));
          _searchAddress = _address.text;
        }
      } else {
        setState(() {
          addressSearchResult.clear();
          _isSearchingAddress = false;
        });
      }
    });
  }

  Future<void> setMapAddress() async {
    addressSearchResult.clear();
    var a = await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new MapAddress()));

    if (a != null) {
      model.address = (a as Address).address;
      model.lat = (a as Address).lat;
      model.long = (a as Address).long;
      if (!model.mainAddress) {
        setState(() {
          controller.forward();
          isBottomSheetVisible = true;
        });
      } else {
        _isLoading = true;
        _presenter.createFavoritePlace(model);
      }
    }
  }

  List<Widget> getAddresses() {
    List<Widget> items = new List<Widget>();

    if (_isSearchingAddress) {
      addressSearchResult.clear();
      items.add(new SizedBox(height: 20.0));
      items.add(new Center(
        child: new CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(AppColors.colorPrimary)),
      ));
    } else
      addressSearchResult.forEach((item) => items.add(item));

    items.add(new Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
              color: AppColors.colorPrimary,
              style: BorderStyle.solid,
              width: 1)),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: setMapAddress,
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.location_on,
              color: AppColors.colorPrimary,
            ),
            new SizedBox(width: 20.0),
            new Expanded(
                child: new Text('Defina o local no mapa',
                    style: AppTextStyle.textGreySmall)),
            new Icon(Icons.arrow_forward_ios,
                size: 16.0, color: AppColors.colorPrimary)
          ],
        ),
      ),
    ));
    items.add(new SizedBox(height: MediaQuery.of(context).size.height * 0.2));
    return items;
  }

  btnSaveAction() {
    _isLoading = true;
    setState(() {});
    if (_alias.text.isNotEmpty)
      model.alias = _alias.text;
    else {
      model.alias = model.address.split(",").first;
    }
    _presenter.createFavoritePlace(model);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.colorPrimary))))
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Stack(
                        children: <Widget>[
                          Container(
                              decoration: new BoxDecoration(
                                  color: AppColors.colorTextGreyLight,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      if (!model.mainAddress)
                                        setState(() {
                                          typingAlias = true;
                                        });
                                    },
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        margin: EdgeInsets.only(
                                            bottom: 5.0,
                                            left: 20.0,
                                            right: 20.0,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        decoration: BoxDecoration(
                                            color: AppColors.colorWhite,
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            border: Border.all(
                                                color: AppColors.colorPrimary,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        child: typingAlias
                                            ? TextField(
                                                style:
                                                    AppTextStyle.textGreySmall,
                                                keyboardType:
                                                    TextInputType.text,
                                                textAlign: TextAlign.start,
                                                autofocus: typingAlias,
                                                enableSuggestions: false,
                                                controller: _alias,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Nome do local',
                                                ),
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Text(
                                                    model.alias,
                                                    style: AppTextStyle
                                                        .textGreySmallBold,
                                                  )
                                                ],
                                              )),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    margin: EdgeInsets.only(
                                        bottom: 20.0,
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: AppColors.colorWhite,
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        border: Border.all(
                                            color: AppColors.colorPrimary,
                                            style: BorderStyle.solid,
                                            width: 1)),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (model.id == null) {
                                            setState(() {
                                              typingAddress = true;
                                              model.lat = null;
                                              model.long = null;
                                              model.address = '';
                                              controller.reverse();
                                              isBottomSheetVisible = false;
                                            });
                                          }
                                        },
                                        child: typingAddress
                                            ? TextField(
                                                style:
                                                    AppTextStyle.textGreySmall,
                                                keyboardType:
                                                    TextInputType.text,
                                                textAlign: TextAlign.start,
                                                controller: _address,
                                                autofocus: typingAddress,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      model.address != null &&
                                                              model.address
                                                                  .isNotEmpty
                                                          ? model.address
                                                          : 'Endereço do local',
                                                ),
                                              )
                                            : Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Text(model.address,
                                                          style: AppTextStyle
                                                              .textGreySmallBold,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                  model.id != null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              typingAddress =
                                                                  true;
                                                              model.lat = null;
                                                              model.long = null;
                                                              model.address =
                                                                  '';
                                                              controller
                                                                  .reverse();
                                                              isBottomSheetVisible =
                                                                  false;
                                                            });
                                                          },
                                                          child: Container(
                                                              child: Icon(
                                                                  Icons.edit,
                                                                  color: AppColors
                                                                      .colorGrey,
                                                                  size: 30.0)),
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          new Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.03),
                              decoration: BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0))),
                              child: new Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    child: new IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: AppColors.colorWhite,
                                            size: 16.0),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  new Center(
                                    child: new Text(model.alias,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.textWhiteSmallBold),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: new ListView(
                        padding: EdgeInsets.all(0),
                        children: getAddresses(),
                      ),
                    ),
                  ],
                ),
                isBottomSheetVisible
                    ? new Align(
                        alignment: Alignment.bottomCenter,
                        child: new Container(
                          transform: Matrix4.identity()
                            ..translate(0.0,
                                animation != null ? animation.value : 0.0, 0.0),
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height *
                              (model.id != null &&
                                      model.id.isNotEmpty &&
                                      !model.mainAddress
                                  ? 0.2
                                  : 0.1),
                          width: MediaQuery.of(context).size.width,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              model.id != null && model.id.isNotEmpty
                                  ? new FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        Util.showConfirm(
                                            context,
                                            'Atenção',
                                            'Deseja realmente excluir este endereço?',
                                            'Sim',
                                            'Não', () {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          _presenter.removeAddress(model.id);
                                        });
                                      },
                                      child: new Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          height: AppSizes.buttonHeight,
                                          decoration: BoxDecoration(
                                              color: AppColors.colorPurple,
                                              borderRadius:
                                                  AppSizes.buttonCorner),
                                          child: new Center(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Text('Excluir',
                                                    style: AppTextStyle
                                                        .textWhiteSmallBold)
                                              ],
                                            ),
                                          )))
                                  : new SizedBox(),
                              model.mainAddress
                                  ? new SizedBox()
                                  : new FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: btnSaveAction,
                                      child: new Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          height: AppSizes.buttonHeight,
                                          decoration: BoxDecoration(
                                              color: AppColors.colorPrimary,
                                              borderRadius:
                                                  AppSizes.buttonCorner),
                                          child: new Center(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new Text('Salvar',
                                                    style: AppTextStyle
                                                        .textWhiteSmallBold)
                                              ],
                                            ),
                                          )))
                            ],
                          ),
                        ))
                    : new SizedBox()
              ],
            ),
          );
  }

  @override
  void onCreateFavoritePlaceSuccess(Address address) {
    Navigator.pop(context, address);
  }

  @override
  void onDeleteFavoritePlaceSuccess() {
    Navigator.pop(context);
  }

  @override
  void onError(String message) {
    _isLoading = false;
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onGetAutoCompleteResultsSuccess(List<Address> result) {
    result.forEach((item) => addressSearchResult.add(new AddressItem(
        model: item, clickListener: this, isFromSelectAddressList: true)));
    setState(() {
      _isSearchingAddress = false;
    });
  }

  @override
  void onSelectAddress(Address address) {
    model.address = address.address;
    model.lat = address.lat;
    model.long = address.long;
    if (model.mainAddress) {
      setState(() {
        _isLoading = true;
        _presenter.createFavoritePlace(model);
      });
    } else {
      addressSearchResult.clear();
      typingAddress = false;
      controller.forward();
      isBottomSheetVisible = true;
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {});
    }
  }

  @override
  void onRemoveSuccess(ResponseServer result) {
    Navigator.pop(context);
  }
}
