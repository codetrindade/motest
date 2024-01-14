import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/favorite_drivers/favorite_drivers.dart';
import 'package:moveme/view/informations/term.dart';
import 'package:moveme/view/informations/language_page.dart';
import 'package:moveme/view/informations/profile_page.dart';
import 'package:moveme/view/informations/sac_page.dart';
import 'package:moveme/view/payment/card_list_page.dart';
import 'package:moveme/widgets/confirm_sheet.dart';
import 'package:provider/provider.dart';

class InformationsPage extends StatefulWidget {
  @override
  _InformationsPageState createState() => _InformationsPageState();
}

class _InformationsPageState extends BaseState<InformationsPage> {
  AppBloc bloc;

  void logout() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                Navigator.pop(context);
                bloc.logout();

              },
              text: 'Atenção\n\nTem certeza que deseja sair ?');
        });
    /*
    var _dialog = AlertDialog(
      title: Text('Logout'),
      content: Text('Tem certeza que deseja sair do App'),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('NÃO')),
        FlatButton(
            onPressed: () {
              this.onLogout();
            },
            child: Text('SIM'))
      ],
    );

    showDialog(context: context, builder: (_) => _dialog);*/
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);

    return Scaffold(
      appBar:
          AppBarCustom(title: 'Informações', preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(MoveMeIcons.perfil, color: AppColors.colorPrimary),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Meus dados', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteDrivers()));
              },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(MoveMeIcons.man_user, color: AppColors.colorPrimary),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Meus motoristas favoritos', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CardListPage()));
              },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(MoveMeIcons.wallet_filled_money_tool, color: AppColors.colorPrimary),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Cartões', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
//            SizedBox(height: 20.0),
//            FlatButton(
//              padding: EdgeInsets.all(0),
//              onPressed: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
//              },
//              child: Container(
//                height: 50.0,
//                padding: EdgeInsets.symmetric(horizontal: 20.0),
//                decoration: BoxDecoration(border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
//                child: Row(
//                  children: <Widget>[
//                    Icon(MoveMeIcons.language, color: AppColors.colorPrimary),
//                    SizedBox(width: 20.0),
//                    Expanded(child: Text('Idiomas', style: AppTextStyle.textGreySmall)),
//                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
//                  ],
//                ),
//              ),
//            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage()));
              },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(MoveMeIcons.routine, color: AppColors.colorPrimary),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Termos de uso', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SacPage()));
              },
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(MoveMeIcons.phone_call, color: AppColors.colorPrimary),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Fale conosco', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: logout,
              child: Container(
                height: 50.0,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app, color: AppColors.colorPrimary, size: 25.0),
                    SizedBox(width: 20.0),
                    Expanded(child: Text('Sair', style: AppTextStyle.textGreySmall)),
                    Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorPrimary)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'versão ${bloc.version}',
                style: AppTextStyle.textGreyExtraSmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

          ],
        ),
      ),
    );
  }
}
