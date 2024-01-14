import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/bloc/login/login_bloc.dart';
import 'package:moveme/locator.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/widgets/loading_circle.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermPage extends StatefulWidget {
  final bool edit;

  TermPage({this.edit = false});

  @override
  _TermPageState createState() => _TermPageState(edit: this.edit);
}

class _TermPageState extends BaseState<TermPage> {
  LoginBloc bloc;
  bool accept;
  bool edit;

  _TermPageState({this.edit});

  @override
  void initState() {
    super.initState();
    accept = !edit;
    Future.microtask(() async => await bloc.getTerm());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<LoginBloc>(context);
    return Scaffold(
        appBar: AppBarCustom(
            title: "Termos de Uso",
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
            callback: () => Navigator.pop(context)),
        body: bloc.isLoading
            ? LoadingCircle()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: ListView(padding: EdgeInsets.all(0), children: <Widget>[
                  Html(
                      data: bloc.term.content.rendered,
                      onLinkTap: (url) {
                        try {
                          launch(url);
                        } catch (e) {}
                      }),
                  GestureDetector(
                    onTap: () {
                      if (edit)
                        setState(() {
                          accept = !accept;
                        });
                    },
                    child: Row(children: <Widget>[
                      Checkbox(
                        value: accept,
                        activeColor: AppColors.colorPrimary,
                        onChanged: (bool resp) {
                          if (edit)
                            setState(() {
                              accept = resp;
                            });
                        },
                      ),
                      Text('Li e aceito os termos de uso', style: AppTextStyle.textPurpleSmallBold)
                    ]),
                  ),
                  SizedBox(height: 10),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Column(children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              if (edit && !accept) {
                                bloc.dialogService.showDialog('Atenção',
                                    'Para poder acessar o aplicativo é ncessário ler e concordar com os termos de uso');
                                return;
                              }
                              if (edit) eventBus.fire(ChangeStateEvent(AppStateEnum.REGISTER));
                              Navigator.pop(context, accept);
                            },
                            child: Container(
                                height: AppSizes.buttonHeight,
                                decoration:
                                    BoxDecoration(color: AppColors.colorPrimary, borderRadius: AppSizes.buttonCorner),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Text('Continuar', style: AppTextStyle.textWhiteExtraSmallBold)],
                                ))))
                      ]))
                ])));
  }
}
