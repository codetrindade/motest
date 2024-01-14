import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:moveme/app_state.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/core/bloc/app/app_data.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/presenter/address_page_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/route/address_item.dart';
import 'package:moveme/view/route/map_address/map_address.dart';
import 'package:moveme/view/route/route_preview/route_preview.dart';
import 'package:uuid/uuid.dart';

import 'address_route_page_view.dart';

class AddressRoutePage extends StatefulWidget {
  final Address myAddressNow;
  final bool isEditingOrigin;

  AddressRoutePage({@required this.myAddressNow, this.isEditingOrigin});

  @override
  _AddressRoutePageState createState() => _AddressRoutePageState(myAddressNow: myAddressNow, isEditingOrigin: isEditingOrigin);
}

class _AddressRoutePageState extends BaseState<AddressRoutePage>
    with TickerProviderStateMixin
    implements AddressRoutePageView, SelectedPlaceListener, AddressPageListener {
  bool _isLoading = false;
  bool _isSearchingAddress = false;
  bool _canAddAddress = true;
  bool isEditingOrigin = false;
  bool _showConfirmBtn = false;
  String _searchAddress;
  AddressRoutePagePresenter _presenter;
  Address myAddressNow;
  List<AddressItem> selectedRoutes = List<AddressItem>();
  List<AddressItem> addressSearchResult = List<AddressItem>();
  Animation<double> animation;
  AnimationController controller;

  AppData appData;

  Timer _debounce;
  var _search = TextEditingController();

  _AddressRoutePageState({this.myAddressNow, this.isEditingOrigin}) {
    _presenter = AddressRoutePagePresenter(this);
    this.appData = locator.get<AppData>();
  }

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearchChanged);
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 150.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    if (this.isEditingOrigin) _search.text = myAddressNow.address;
  }

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    controller.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_search.text.length > 5) {
        if (_searchAddress != _search.text) {
          setState(() {
            _isSearchingAddress = true;
          });
          _presenter.getAutoCompleteResults(Address(address: _search.text));
          _searchAddress = _search.text;
        }
      } else {
        setState(() {
          addressSearchResult.clear();
          _isSearchingAddress = false;
        });
      }
    });
  }

  onConfirmRoutes() {
    selectedRoutes.removeWhere((item) => item.isEmpty);
    if (selectedRoutes.isEmpty) {
      addEmpty();
      Util.showMessage(context, 'Atenção', 'Favor selecionar pelo menos 1 endereço');
      return;
    }
    var routes = List<Address>();
    myAddressNow.id = Uuid().v1();
    routes.add(myAddressNow);
    selectedRoutes.asMap().forEach((index, item) => routes.add(item.model));
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.slideInUp, duration: Duration(milliseconds: 300), child: RoutePreview(routes: routes)));
  }

  Future<void> setMapAddress() async {
    if (!_canAddAddress) {
      Util.showMessage(context, 'Atenção', 'Você já selecionou o número máximo de destinos');
      return;
    }
    _isLoading = true;
    var a = await Navigator.of(context)
        .push(PageTransition(type: PageTransitionType.slideInUp, duration: Duration(milliseconds: 300), child: MapAddress()));

    if (a != null) addAddressInList(a);

    setState(() {
      _isLoading = false;
    });
  }

  List<Widget> buildAddressItems() {
    var addressItems = List<Widget>();

    if (selectedRoutes.length > 0) {
      selectedRoutes.forEach((item) => addressItems.add(item));

      addressItems.add(Container(
        color: AppColors.colorPrimary,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
        height: 1,
      ));
    }

    if (_isSearchingAddress) {
      addressSearchResult.clear();
      addressItems.add(SizedBox(height: 20.0));
      addressItems.add(Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary)),
      ));
    } else
      addressSearchResult.forEach((item) => addressItems.add(item));

    if (_canAddAddress && !_isSearchingAddress) {
      addressItems.add(Container(
          height: MediaQuery.of(context).size.height * 0.08,
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              color: AppColors.colorWhite,
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1)),
          child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: setMapAddress,
              child: Row(children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(width: 20.0),
                Expanded(child: Text('Defina o local no mapa', style: AppTextStyle.textGreySmall)),
                Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
              ]))));
      if (addressSearchResult == null || addressSearchResult.isEmpty)
        appData.addresses.asMap().forEach((index, item) {
          item.isFavorite = true;
          addressItems.add(AddressItem(model: item, listener: this, clickListener: this, isFromSelectAddressList: true));
        });
    }

    return addressItems;
  }

  void addEmpty() {
    if (selectedRoutes.length < 3)
      selectedRoutes.add(AddressItem(
          model: Address(order: selectedRoutes.length + 1, id: Uuid().v1(), address: 'Adicionar um ponto'),
          clickListener: this,
          listener: this,
          isEmpty: true));
  }

  void addAddressInList(Address address) {
    if (isEditingOrigin) {
      setState(() {
        myAddressNow = address;
        myAddressNow.order = 0;
        _search.text = '';
        isEditingOrigin = false;
      });
      return;
    }
    if (!_canAddAddress) {
      Util.showMessage(context, 'Atenção', 'Você já selecionou o número máximo de destinos');
      return;
    }
    address.id = Uuid().v1();
    address.order = selectedRoutes.length + 1;
    FocusScope.of(context).requestFocus(FocusNode());

    addressSearchResult.clear();
    _search.text = '';
    var empty = selectedRoutes.firstWhere((item) => item.isEmpty, orElse: () => null);

    if (empty != null) {
      selectedRoutes.removeWhere((item) => item.model.id == empty.model.id);
      address.order--;
      selectedRoutes.add(AddressItem(model: address, listener: this));
      if (selectedRoutes.length <= 2)
        addEmpty();
      else
        _canAddAddress = false;
      controller.forward();
      _showConfirmBtn = true;
    } else {
      selectedRoutes.add(AddressItem(model: address, listener: this));
      onConfirmRoutes();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: AppColors.colorWhite,
            child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorPrimary))),
          )
        : Material(
            color: AppColors.colorPrimary,
            child: SafeArea(
                child: Scaffold(
                    body: Column(children: <Widget>[
                      Stack(children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingOrigin = !isEditingOrigin;
                              });
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height * (isEditingOrigin ? 0.15 : 0.15),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    top: 15,
                                    bottom: 00.0,
                                    left: MediaQuery.of(context).size.width * 0.13,
                                    right: MediaQuery.of(context).size.width * 0.1),
                                decoration: BoxDecoration(
                                    color: AppColors.colorPrimary,
                                    borderRadius:
                                        BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Ponto de partida', style: AppTextStyle.textWhiteSmallBold),
                                      Text(
                                          !isEditingOrigin
                                              ? myAddressNow.address
                                              : 'Digite o ponto de partida ou escolha no mapa.',
                                          style: AppTextStyle.textWhiteSmall,
                                          maxLines: 2)
                                    ]))),
                        Container(
                            margin: EdgeInsets.only(top: 0),
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
                                onPressed: () => Navigator.pop(context))),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            margin: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: MediaQuery.of(context).size.height * (isEditingOrigin ? 0.12 : 0.12)),
                            decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                borderRadius: BorderRadius.circular(40.0),
                                border: Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1)),
                            child: Row(children: <Widget>[
                              SizedBox(width: 20.0),
                              Expanded(
                                  child: TextField(
                                      style: AppTextStyle.textGreySmall,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      autofocus: true,
                                      textAlign: TextAlign.start,
                                      controller: _search,
                                      decoration: InputDecoration(
                                          filled: false,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          hintText: isEditingOrigin ? 'Qual é o Ponto de partida' : 'Qual é o seu destino?'))),
                              selectedRoutes.isEmpty && !isEditingOrigin
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (!_canAddAddress) {
                                            Util.showMessage(
                                                context, 'Atenção', 'Você já selecionou o número máximo de destinos');
                                            return;
                                          }
                                          addEmpty();
                                        });
                                      },
                                      icon: Icon(Icons.add, color: AppColors.colorPrimary, size: 26.0))
                                  : SizedBox()
                            ]))
                      ]),
                      Expanded(child: ListView(padding: EdgeInsets.only(bottom: 20.0), children: buildAddressItems()))
                    ]),
                    bottomNavigationBar: Container(
                        transform: Matrix4.identity()..translate(0.0, animation != null ? animation.value : 0.0, 0.0),
                        color: Colors.white,
                        child: Container(
                            height: MediaQuery.of(context).size.height * (_showConfirmBtn ? 0.08 : 0.0),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: _showConfirmBtn ? 10.0 : 0.0, bottom: _showConfirmBtn ? 10.0 : 0.0),
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                                color: AppColors.colorBlueLight,
                                borderRadius: BorderRadius.circular(40.0),
                                border: Border.all(color: AppColors.colorBlueLight, style: BorderStyle.solid, width: 1)),
                            child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: onConfirmRoutes,
                                child: Text('Confirmar', style: AppTextStyle.textWhiteSmallBold)))))));
  }

  @override
  void onError(String message) {
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onGetAutoCompleteResultsSuccess(List<Address> result) {
    result.forEach((item) =>
        addressSearchResult.add(AddressItem(model: item, listener: this, clickListener: this, isFromSelectAddressList: true)));
    setState(() {
      _isSearchingAddress = false;
    });
  }

  @override
  void onSelectAddress(Address address) {
    addAddressInList(address);
  }

  @override
  void onChangeAddress(Address address) {
    var index = selectedRoutes.indexWhere((a) => a.model.id == address.id);
    selectedRoutes.removeAt(index);
    address.order = index + 1;
    selectedRoutes.insert(index, AddressItem(model: address, listener: this));
  }

  @override
  void onRemoveAddress(Address address) {
    var index = selectedRoutes.indexWhere((a) => a.model.id == address.id);
    setState(() {
      selectedRoutes.removeAt(index);
      var Index = 1;

      for (var a in selectedRoutes) {
        a.model.order = Index;
        Index++;
      }
      _canAddAddress = true;
      if (selectedRoutes.isEmpty) {
        controller.reverse();
        _showConfirmBtn = false;
      }
    });
  }

  @override
  void onEmptyClick(Address address) {
    setMapAddress();
  }
}
