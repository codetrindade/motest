import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/core/bloc/sac/sac_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class SacPage extends StatefulWidget {
  @override
  _SacPageState createState() => _SacPageState();
}

class _SacPageState extends BaseState<SacPage> {
  SacBloc bloc;

  var _subject = TextEditingController();
  var _detail = TextEditingController();
  var _phone = TextEditingController();
  var _description = TextEditingController();

  var _subjectFocus = FocusNode();
  var _detailFocus = FocusNode();
  var _phoneFocus = FocusNode();
  var _descriptionFocus = FocusNode();

  Future<void> submit() async {
    if (_subject.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O motivo do contato é obrigatório');
      FocusScope.of(context).requestFocus(_subjectFocus);
      return;
    }
    if (_detail.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O detalhe do contato é obrigatório');
      FocusScope.of(context).requestFocus(_detailFocus);
      return;
    }
    if (_phone.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O telefone do contato é obrigatório');
      FocusScope.of(context).requestFocus(_phoneFocus);
      return;
    }
    if (_description.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'A descrição do contato é obrigatória');
      FocusScope.of(context).requestFocus(_descriptionFocus);
      return;
    }

    await bloc.contact(_subject.text, _detail.text, _phone.text, _description.text);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _phone.text = bloc.appData.user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<SacBloc>(context);
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Fale Conosco',
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        callback: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            TextField(
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              controller: _subject,
              focusNode: _subjectFocus,
              onSubmitted: (String a) => FocusScope.of(context).requestFocus(_detailFocus),
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Motivo do Contato',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              controller: _detail,
              focusNode: _detailFocus,
              onSubmitted: (String a) => FocusScope.of(context).requestFocus(_phoneFocus),
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Detalhe do Motivo',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.text,
              controller: _phone,
              focusNode: _phoneFocus,
              onSubmitted: (String a) => FocusScope.of(context).requestFocus(_descriptionFocus),
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'Telefone',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              style: AppTextStyle.textPurpleExtraSmall,
              keyboardType: TextInputType.multiline,
              controller: _description,
              focusNode: _descriptionFocus,
              onSubmitted: (String a) => submit,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'O que aconteceu?',
                labelStyle: AppTextStyle.textPurpleExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorPrimaryLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(18))),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: bloc.isLoading
          ? LoadingCircle()
          : Container(
              height: MediaQuery.of(context).size.height * 0.1,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => submit(),
                      child: Container(
                          height: AppSizes.buttonHeight,
                          decoration: BoxDecoration(color: AppColors.colorPrimary, borderRadius: AppSizes.buttonCorner),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text('Enviar', style: AppTextStyle.textWhiteExtraSmallBold)],
                            ),
                          ))),
                ],
              ),
            ),
    );
  }
}
