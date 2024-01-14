import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/profile/profile_bloc.dart';
import 'package:moveme/model/user.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/informations/password_page.dart';
import 'package:moveme/view/login/sms_page.dart';
import 'package:moveme/widgets/text_field_custom.dart';
import 'package:moveme/widgets/transparent_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  ProfileBloc bloc;
  var _name = TextEditingController();
  var _document = MaskedTextController(mask: '000.000.000-00');
  var _email = TextEditingController();

  var _nameFocus = FocusNode();
  var _cpfFocus = FocusNode();

  void openPasswordPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage()));
  }

  Future<void> onSaveChanges() async {
    if (_name.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o nome para prosseguir');
      FocusScope.of(context).requestFocus(_nameFocus);
      return;
    }

    if (_email.text.length == 0 || !_email.text.contains('@')) {
      Util.showMessage(context, 'Atenção', 'Preencha o e-mail para prosseguir');
      return;
    }

    if (_document.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o cpf para prosseguir');
      return;
    }

    await bloc.updateProfile(User(name: _name.text, document: _document.text, email: _email.text));
  }

  void showImageSourceSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('De onde deseja adicionar uma foto?',
                            textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold))),
                Row(children: <Widget>[
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border(top: BorderSide(color: Theme.of(context).colorScheme.primaryVariant, width: 0.5))),
                              height: 70,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.camera_alt, color: AppColors.colorBlueLight)),
                                Text('Câmera', style: AppTextStyle.textBlueLightSmallBold)
                              ])))),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              color: Theme.of(context).colorScheme.primaryVariant,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.photo_library, color: Colors.white)),
                                Text('Galeria', style: AppTextStyle.textWhiteSmallBold)
                              ]))))
                ])
              ]));
        });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      setState(() {
        _name.text = bloc.appData.user.name;
        _email.text = bloc.appData.user.email;
        _document.text = bloc.appData.user.document;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ProfileBloc>(context);
    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            appBar: AppBarCustom(
                title: 'Perfil',
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
                callback: () => Navigator.pop(context)),
            body: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: () => showImageSourceSheet(),
                      child: bloc.appData.user.photo != null && bloc.appData.user.photo.isNotEmpty
                          ? ClipOval(
                              child: FadeInImage.assetNetwork(
                                  width: 80,
                                  height: 80,
                                  placeholder: 'assets/images/user.png',
                                  image: bloc.appData.user.photo,
                                  fit: BoxFit.fill))
                          : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Icon(MoveMeIcons.perfil, color: AppColors.colorGrey, size: 50))),
                  SizedBox(height: 20),
                  TextFieldCustom(
                      controller: _name,
                      label: 'Nome',
                      focus: _nameFocus,
                      nextFocus: _cpfFocus,
                      capitalization: TextCapitalization.words),
                  SizedBox(height: 20),
                  TextFieldCustom(controller: _document, label: 'CPF', keyBoardType: TextInputType.number, focus: _cpfFocus),
                  SizedBox(height: 20),
                  TextFieldCustom(controller: _email, label: 'E-mail', enabled: false),
                  SizedBox(height: 20),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: AppColors.colorPrimaryLight)),
                      child: Text(
                          bloc.appData.user.phone == null || bloc.appData.user.phone.isEmpty
                              ? 'Telefone ainda não informado'
                              : bloc.appData.user.phone,
                          style: AppTextStyle.textPurpleExtraSmall)),
                  Row(children: [
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SmsPage(fromProfile: true)));
                            },
                            child: Text(
                                bloc.appData.user.phone == null || bloc.appData.user.phone.isEmpty
                                    ? 'Confirmar conta'
                                    : 'Alterar telefone',
                                style: AppTextStyle.textGreyExtraSmallBold,
                                textAlign: TextAlign.right)))
                  ]),
                  SizedBox(height: 20.0),
                  TransparentButton(
                      text: 'Disponibilizar meu telefone para os motoristas durante a corrida',
                      arrow: false,
                      height: 100,
                      border: 5,
                      margin: null,
                      callback: () async => await bloc.changeDisplayMyPhone(),
                      ok: bloc.showMyPhone,
                      iconLeft: Icon(Icons.contact_phone_rounded, color: AppColors.colorBlueLight),
                      warning: !bloc.showMyPhone),
                  SizedBox(height: 20),
                  Column(children: <Widget>[
                    FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: openPasswordPage,
                        child: Container(
                            height: AppSizes.buttonHeight,
                            decoration: BoxDecoration(color: AppColors.colorBlueDark, borderRadius: AppSizes.buttonCorner),
                            child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[Text('Alterar Senha', style: AppTextStyle.textWhiteExtraSmallBold)])))),
                    SizedBox(height: 10),
                    FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () async => await onSaveChanges(),
                        child: Container(
                            height: AppSizes.buttonHeight,
                            decoration: BoxDecoration(color: AppColors.colorButtonPrimary, borderRadius: AppSizes.buttonCorner),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Text('Salvar', style: AppTextStyle.textWhiteExtraSmallBold)],
                            ))))
                  ]),
                  SizedBox(height: 20),
                ]))),
          );
  }
}
