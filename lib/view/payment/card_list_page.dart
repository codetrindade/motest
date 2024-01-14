import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/core/bloc/card/card_bloc.dart';
import 'package:moveme/model/card/card.dart';
import 'package:moveme/model/response_server.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/payment/card_page.dart';
import 'package:provider/provider.dart';

class CardListPage extends StatefulWidget {
  bool isSelection;

  CardListPage({this.isSelection = false});

  @override
  _CardListPageState createState() => _CardListPageState(isSelection);
}

class _CardListPageState extends BaseState<CardListPage> {
  CardBloc bloc;
  bool isSelection = false;

  _CardListPageState(this.isSelection);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => bloc.initialize());
  }

  Future openCard() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CardPage()));
    bloc.initialize();
  }

  void selectedCard(CardData card) {
    if (this.isSelection)
      Navigator.pop(context, card.id);
    else {
      Util.showConfirm(context, 'Atenção', 'Deseja realmente excluir este cartão?', 'Confirmar', 'Cancelar', () {
        bloc.removeCard(card.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<CardBloc>(context);

    return Scaffold(
      appBar: AppBarCustom(
          title: "Cartões",
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          callback: () => Navigator.pop(context)),
      body: bloc.isLoading
          ? LoadingCircle()
          : bloc.listCard.length == 0
              ? new Center(
                  child: new Text('Você não tem nenhum cartão\ncadastrado no momento',
                      style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center),
                )
              : ListView.builder(
                  itemCount: bloc.listCard.length,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  itemBuilder: (BuildContext context, int index) {
                    var card = bloc.listCard[index];
                    return Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => selectedCard(card),
                          child: Container(
                              padding: EdgeInsets.only(right: 20.0, left: 10.0),
                              height: 60.0,
                              decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  border:
                                      Border.all(color: AppColors.colorPrimary, style: BorderStyle.solid, width: 1.0),
                                  borderRadius: BorderRadius.circular(35.0)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorBlueLight),
                                    child: Icon(Icons.credit_card, color: AppColors.colorWhite),
                                  ),
                                  SizedBox(width: 15.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(card.holderName, style: AppTextStyle.textGreyExtraSmall),
                                        ),
                                        Text(card.cardNumber, style: AppTextStyle.textPurpleExtraSmallBold),
                                      ],
                                    ),
                                  ),
                                  Icon(isSelection ? Icons.arrow_forward_ios : Icons.delete_outline,
                                      size: 25.0, color: AppColors.colorPrimary)
                                ],
                              ))),
                    );
                  },
                ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () => openCard(),
                child: Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(color: AppColors.colorPrimary, borderRadius: AppSizes.buttonCorner),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Adicionar cartão', style: AppTextStyle.textWhiteExtraSmallBold)],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
