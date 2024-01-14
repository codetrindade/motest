import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/util/util.dart';
import 'package:moveme/view/informations/term.dart';
import 'register_page.dart';
import 'login_page.dart';

class LoginMainPage extends StatefulWidget {
  @override
  _LoginMainPageState createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  PageController _pageController;
  int _page = 0;
  static const _duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(gradient: appGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/svg/icon_home.svg', width: 250),
            SizedBox(height: MediaQuery.of(context).size.height * .2),
            FlatButton(
                onPressed: openLoginPage,
                child: Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(color: AppColors.colorBlueDark, borderRadius: AppSizes.buttonCorner),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Já tenho uma conta', style: AppTextStyle.textWhiteSmallBold)],
                      ),
                    ))),
            SizedBox(height: 10.0),
            FlatButton(
                onPressed: openRegisterPage,
                child: Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(color: AppColors.colorButtonPrimary, borderRadius: AppSizes.buttonCorner),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Criar uma conta', style: AppTextStyle.textWhiteSmallBold)],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  void onNextPage() {
    setState(() {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void onBackPage() {
    setState(() {
      _page != 4 ? _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null;
    });
  }

  void onChangeWalkItem(int page) {
    if (_pageController.hasClients && _pageController.hasListeners) {
      _page = page;
      _pageController.animateToPage(page, duration: _duration, curve: Curves.ease);
    }
  }

  void openLoginPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future openRegisterPage() async {
    var a = await Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage(edit: true)));

    if (a == null || !a) {
      Util.showConfirm(
          context, 'Atenção', 'É necessário aceitar os termos de uso para acessar o aplicativo', 'Voltar', 'Cancelar',
          () {
        openRegisterPage();
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
