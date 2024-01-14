import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/core/bloc/card/card_bloc.dart';
import 'package:moveme/model/card/card.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/UpperCaseTextFormatter.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/widgets/loading_circle.dart';
import 'package:moveme/widgets/text_field_custom.dart';
import 'package:provider/provider.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

import 'card_placeholder.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends BaseState<CardPage> {
  CardBloc bloc;

  PageController pageController = PageController(initialPage: 0);
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  CardData card = new CardData();
  var pageIndex = 0;

  var _nameController = TextEditingController();
  var _numberController = MaskedTextController(mask: '0000 0000 0000 0000');
  var _validateController = MaskedTextController(mask: '00/0000');
  var _cvvController = TextEditingController();

  var _nameFocus = FocusNode();
  var _numberFocus = FocusNode();
  var _validateFocus = FocusNode();
  var _cvvFocus = FocusNode();

  var _zipCode = MaskedTextController(mask: '00000-000');
  var _cpf = MaskedTextController(mask: '000.000.000-00');
  var _cpfFocus = FocusNode();
  var _zipCodeFocus = FocusNode();
  var _neighbohood = TextEditingController();
  var _neighbohoodFocus = FocusNode();
  var _complement = TextEditingController();
  var _complementFocus = FocusNode();
  var _enableNeighbohood = true;
  var _street = TextEditingController();
  var _streetFocus = FocusNode();
  var _enableStreet = true;
  var _streetNumber = TextEditingController();
  var _streetNumberFocus = FocusNode();
  var _city = TextEditingController();
  var _cityFocus = FocusNode();
  var _enableCity = true;
  var _state = MaskedTextController(mask: 'AA');
  var _stateFocus = FocusNode();
  var _enableState = true;

  _CardPageState() {}

  void onPrev() {
    pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
    //bloc.changePageIndex(bloc.pageIndex - 1);
    //onFocus();
  }

  void onNext() {
    if (pageIndex <= 2 && onValidatedCard()) {
      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      return;
    }
    if (pageIndex == 3) {
      FocusScope.of(context).requestFocus(_cpfFocus);
    }
  }

  void onFocus() {
    switch (pageIndex) {
      case 1:
        FocusScope.of(context).requestFocus(_nameFocus);
        break;
      case 2:
        FocusScope.of(context).requestFocus(_validateFocus);
        break;
      case 3:
        FocusScope.of(context).requestFocus(_cvvFocus);
        break;
      default:
        FocusScope.of(context).requestFocus(_numberFocus);
        break;
    }
  }

  bool onValidatedCard() {
    //CARD NUMBER
    if (pageIndex == 0 && card.cardNumber.length < 19) {
      Util.showMessage(context, 'Atenção', 'Digite um numero de cartão válido.');
      return false;
    }

    //CARD NAME
    if (pageIndex == 1 && card.holderName.length <= 5) {
      Util.showMessage(context, 'Atenção', 'Digite um nome válido.');
      return false;
    }

    //VALIDATE
    if (pageIndex == 2 && card.cardValidate.length <= 6) {
      Util.showMessage(context, 'Atenção', 'Preecha a validade do cartão.');
      return false;
    }

    //COD CVV
    if (pageIndex == 3 && card.cardCvv.length <= 3) {
      Util.showMessage(context, 'Atenção', 'Preecha o codigo de segurança do cartão.');
      return false;
    }
    return true;
  }

  bool onValidate() {
    if (card.cardNumber.length < 19) {
      Util.showMessage(context, 'Atenção', 'Digite um numero de cartão válido.');
      return false;
    }

    if (!CPF.isValid(card.document)) {
      Util.showMessage(context, 'Atenção', 'Digite um CPF válido.');
      return false;
    }

    if (card.holderName.length <= 5) {
      Util.showMessage(context, 'Atenção', 'Digite um nome válido.');
      return false;
    }

    if (card.cardValidate.length <= 6) {
      Util.showMessage(context, 'Atenção', 'Preecha a validade do cartão.');
      return false;
    }

    if (card.cardCvv.length < 3) {
      Util.showMessage(context, 'Atenção', 'Preecha o codigo de segurança do cartão.');
      return false;
    }

    if (card.street.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha o endereço.');
      return false;
    }

    if (card.document.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha o CPF.');
      return false;
    }

    if (card.streetNumber.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha o numero do endereço.');
      return false;
    }

    if (card.neighborhood.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha o bairro.');
      return false;
    }
    if (card.city.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha a cidade.');
      return false;
    }
    if (card.state.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preecha o estado.');
      return false;
    }
    return true;
  }

  getAddressByZipCode() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var address = await bloc.getAddressByZipCode(_zipCode.text);
    if (address == null) {
      _enableState = true;
      _enableCity = true;
      _enableStreet = true;
      _enableNeighbohood = true;
      bloc.setLoading(false);
      return;
    }
    _street.text = address.street;
    _enableStreet = address.street.isEmpty;
    _neighbohood.text = address.neighborhood;
    _enableNeighbohood = address.neighborhood.isEmpty;
    _city.text = address.city;
    _enableCity = address.city.isEmpty;
    _state.text = address.state;
    _enableState = address.state.isEmpty;
    FocusScope.of(context).requestFocus(_streetNumberFocus);
    bloc.setLoading(false);
  }

  saveCard() async {
    card.city = _city.text;
    card.neighborhood = _neighbohood.text;
    card.state = _state.text;
    card.street = _street.text;
    card.zipCode = _zipCode.text;
    card.complement = _complement.text;
    card.streetNumber = _streetNumber.text;
    card.document = _cpf.text.replaceAll('.', '').replaceAll('-', '');

    if (!onValidate()) return;
    var newModel = CardData.fromJson(card.toJson());
    newModel.cardCvv = card.cardCvv;
    bloc.addCard(newModel);
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<CardBloc>(context);
    return Scaffold(
      appBar: AppBarCustom(
          title: "Adicionar Cartão",
          callback: () => Navigator.pop(context),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: bloc.isLoading
          ? LoadingCircle()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //CARD
                    FlipCard(
                        flipOnTouch: false,
                        key: cardKey,
                        direction: FlipDirection.HORIZONTAL,
                        // default
                        front: FrondCard(index: -1, card: card),
                        back: BackCard(card: card)),
                    Container(
                        height: 70,
                        margin: EdgeInsets.only(top: 10),
                        child: PageView(
                            controller: pageController,
                            pageSnapping: true,
                            onPageChanged: (page) {
                              //setState(() {
                              if (page > 2)
                                cardKey.currentState.toggleCard();
                              else if (page == 2 && pageIndex == 3) cardKey.currentState.toggleCard();

                              this.pageIndex = page;
                              onFocus();
                              //});
                            },
                            //physics: ,
                            children: <Widget>[
                              //CARD NUMBER
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: TextField(
                                  autofocus: true,
                                  controller: _numberController,
                                  focusNode: _numberFocus,
                                  onChanged: (value) => setState(() {
                                    card.cardNumber = value;
                                  }),
                                  onSubmitted: (value) => onNext(),
                                  buildCounter: (BuildContext context,
                                          {int currentLength, int maxLength, bool isFocused}) =>
                                      null,
                                  style: TextStyle(fontSize: AppSizes.fontMedium),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      hintText: 'Numero do cartão',
                                      fillColor: AppColors.colorGrey.withOpacity(0.2),
                                      filled: true,
                                      suffixIcon: Icon(Icons.lock_outline),
                                      hintStyle: TextStyle(fontSize: AppSizes.fontMedium),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey))),
                                ),
                              ),
                              //CARD HOLDER NAME
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: TextField(
                                  autocorrect: false,
                                  autofocus: false,
                                  enableSuggestions: false,
                                  enableInteractiveSelection: false,
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                  onChanged: (value) => setState(() {
                                    card.holderName = value;
                                  }),
                                  onSubmitted: (value) => onNext(),
                                  maxLength: 50,
                                  buildCounter: (BuildContext context,
                                          {int currentLength, int maxLength, bool isFocused}) =>
                                      null,
                                  style: TextStyle(fontSize: AppSizes.fontMedium),
                                  //keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      hintText: 'Nome do titular',
                                      fillColor: AppColors.colorGrey.withOpacity(0.2),
                                      filled: true,
                                      //suffixIcon: Icon(Icons.lock_outline),
                                      hintStyle: TextStyle(fontSize: AppSizes.fontMedium),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey))),
                                ),
                              ),
                              //VALIDATE
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  child: TextField(
                                    focusNode: _validateFocus,
                                    controller: _validateController,
                                    onChanged: (value) => setState(() {
                                      if (value.length <= 7) card.cardValidate = value;
                                    }),
                                    onSubmitted: (value) => onNext(),
                                    maxLength: 14,
                                    buildCounter: (BuildContext context,
                                            {int currentLength, int maxLength, bool isFocused}) =>
                                        null,
                                    style: TextStyle(fontSize: AppSizes.fontMedium),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        hintText: 'Validade',
                                        fillColor: AppColors.colorGrey.withOpacity(0.2),
                                        filled: true,
                                        suffixIcon: Icon(Icons.date_range),
                                        //suffixIcon: Icon(Icons.lock_outline),
                                        hintStyle: TextStyle(fontSize: AppSizes.fontMedium),
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey))),
                                  )),
                              //CVV
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  child: TextField(
                                    focusNode: _cvvFocus,
                                    controller: _cvvController,
                                    maxLength: 4,
                                    onChanged: (value) => setState(() {
                                      card.cardCvv = value;
                                    }),
                                    onSubmitted: (value) => onNext(),
                                    textInputAction: TextInputAction.next,
                                    buildCounter: (BuildContext context,
                                            {int currentLength, int maxLength, bool isFocused}) =>
                                        null,
                                    style: TextStyle(fontSize: AppSizes.fontMedium),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: 'Código de segurança',
                                        fillColor: AppColors.colorGrey.withOpacity(0.2),
                                        filled: true,
                                        //suffixIcon: Icon(Icons.lock_outline),
                                        hintStyle: TextStyle(fontSize: AppSizes.fontMedium),
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey))),
                                  ))
                            ])),
                    //BOTTOM
                    Row(
                      mainAxisAlignment:
                          pageIndex == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (pageIndex > 0)
                          FlatButton(
                            onPressed: () => onPrev(),
                            padding: EdgeInsets.zero,
                            child: Container(
                              margin: EdgeInsets.only(left: 30.0),
                              width: 130,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  color: AppColors.colorPrimaryLight,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Center(child: Text('voltar', style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        FlatButton(
                          onPressed: () => onNext(),
                          padding: EdgeInsets.zero,
                          child: Container(
                            margin: EdgeInsets.only(right: 30.0),
                            width: 130,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: AppColors.colorGreen, borderRadius: BorderRadius.circular(30.0)),
                            child: Center(
                                child: Text(pageIndex == 2 ? 'Confirmar' : 'Próximo',
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ],
                    ),
                    //ADDRESS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          TextFieldCustom(
                              isDecorationDefault: false,
                              label: 'CPF do titular do cartão',
                              controller: _cpf,
                              keyBoardType: TextInputType.numberWithOptions(),
                              focus: _cpfFocus,
                              nextFocus: _zipCodeFocus),
                          Divider(height: 50),
                          Text('Endereço de Cobrança', style: AppTextStyle.textBlueBold),
                          Text('Informe o endereço do cartão', style: AppTextStyle.textGreySmall),
                          SizedBox(height: 20.0),
                          Row(children: <Widget>[
                            Flexible(
                                child: TextFieldCustom(
                                    isDecorationDefault: false,
                                    label: 'CEP',
                                    controller: _zipCode,
                                    keyBoardType: TextInputType.numberWithOptions(),
                                    focus: _zipCodeFocus,
                                    nextFocus: _streetFocus)),
                            SizedBox(width: 5.0),
                            FlatButton(
                              onPressed: () => getAddressByZipCode(),
                              padding: EdgeInsets.zero,
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: AppColors.colorGreen, borderRadius: BorderRadius.circular(30.0)),
                                child: Center(child: Icon(Icons.search, color: Colors.white)),
                              ),
                            ),
                          ]),
                          SizedBox(height: 10.0),
                          TextFieldCustom(
                              isDecorationDefault: false,
                              label: 'Endereço',
                              controller: _street,
                              focus: _streetFocus,
                              enabled: _enableStreet,
                              nextFocus: _streetNumberFocus),
                          SizedBox(height: 10.0),
                          Row(children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFieldCustom(
                                  isDecorationDefault: false,
                                  label: 'Nº',
                                  controller: _streetNumber,
                                  keyBoardType: TextInputType.number,
                                  focus: _streetNumberFocus,
                                  nextFocus: _complementFocus),
                            ),
                            SizedBox(width: 10.0),
                            Flexible(
                                child: TextFieldCustom(
                                    isDecorationDefault: false,
                                    label: 'Complemento',
                                    controller: _complement,
                                    keyBoardType: TextInputType.text,
                                    focus: _complementFocus,
                                    //enabled: _enableNeighbohood,
                                    nextFocus: _neighbohoodFocus)),
                          ]),
                          SizedBox(height: 10.0),
                          TextFieldCustom(
                              isDecorationDefault: false,
                              label: 'Bairro',
                              controller: _neighbohood,
                              keyBoardType: TextInputType.text,
                              focus: _neighbohoodFocus,
                              enabled: _enableNeighbohood,
                              nextFocus: _cityFocus),
                          SizedBox(height: 10.0),
                          Row(children: <Widget>[
                            Flexible(
                                child: TextFieldCustom(
                                    isDecorationDefault: false,
                                    label: 'Cidade',
                                    controller: _city,
                                    keyBoardType: TextInputType.text,
                                    focus: _cityFocus,
                                    enabled: _enableCity,
                                    nextFocus: _stateFocus)),
                            SizedBox(width: 10.0),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFieldCustom(
                                  isDecorationDefault: false,
                                  label: 'UF',
                                  controller: _state,
                                  enabled: _enableState,
                                  keyBoardType: TextInputType.text,
                                  focus: _stateFocus),
                            ),
                          ]),
                          SizedBox(height: 30),
                          FlatButton(
                            onPressed: () => saveCard(),
                            padding: EdgeInsets.zero,
                            child: Container(
                              height: 60.0,
                              decoration: BoxDecoration(
                                  color: AppColors.colorGreen, borderRadius: BorderRadius.circular(30.0)),
                              child: Center(child: Text('Confirmar', style: TextStyle(color: Colors.white))),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
