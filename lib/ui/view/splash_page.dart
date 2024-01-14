import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveme/core/bloc/app/app_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/login/login_page.dart';
import 'package:moveme/view/login/sms_page.dart';
import 'package:moveme/view/main/main_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => bloc.initialize());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        color: AppColors.colorBlueDark,
        child: Center(child: SvgPicture.asset('assets/svg/icon_home.svg')));
  }
}
