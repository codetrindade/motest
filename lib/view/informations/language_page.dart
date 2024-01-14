import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/theme.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends BaseState<LanguagePage> {

  var language = 0;

  void changeLanguage(int lang) {
    setState(() {
      language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Idiomas',
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        callback: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(0);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(
                          color: AppColors.colorPrimary,
                          style: BorderStyle.solid,
                          width: 1.0
                        ),
                        borderRadius: AppSizes.buttonCorner),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text('Português',
                              style: AppTextStyle.textPurpleSmallBold),
                        ),
                        language == 0 ? Icon(Icons.check, color: AppColors.colorPrimary) : SizedBox()
                      ],
                    ))),
            SizedBox(height: 20.0),
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(1);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(
                            color: AppColors.colorPrimary,
                            style: BorderStyle.solid,
                            width: 1.0
                        ),
                        borderRadius: AppSizes.buttonCorner),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text('Inglês',
                              style: AppTextStyle.textPurpleSmallBold),
                        ),
                        language == 1 ? Icon(Icons.check, color: AppColors.colorPrimary) : SizedBox()
                      ],
                    ))),
            SizedBox(height: 20.0),
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(2);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(
                            color: AppColors.colorPrimary,
                            style: BorderStyle.solid,
                            width: 1.0
                        ),
                        borderRadius: AppSizes.buttonCorner),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text('Espanhol',
                              style: AppTextStyle.textPurpleSmallBold),
                        ),
                        language == 2 ? Icon(Icons.check, color: AppColors.colorPrimary) : SizedBox()
                      ],
                    ))),
            SizedBox(height: 20.0),
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(3);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(
                            color: AppColors.colorPrimary,
                            style: BorderStyle.solid,
                            width: 1.0
                        ),
                        borderRadius: AppSizes.buttonCorner),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text('Francês',
                              style: AppTextStyle.textPurpleSmallBold),
                        ),
                        language == 3 ? Icon(Icons.check, color: AppColors.colorPrimary) : SizedBox()
                      ],
                    ))),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: null,
                child: Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: AppSizes.buttonCorner),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Salvar alteração',
                              style: AppTextStyle.textWhiteExtraSmallBold)
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
