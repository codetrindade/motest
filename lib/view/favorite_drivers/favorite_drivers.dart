import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/loading.dart';
import 'package:moveme/core/bloc/driver/driver_favorite_bloc.dart';
import 'package:moveme/presenter/favorite_drivers_presenter.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/favorite_drivers/favorite_drivers_item.dart';
import 'package:provider/provider.dart';

class FavoriteDrivers extends StatefulWidget {
  @override
  _FavoriteDriversState createState() => _FavoriteDriversState();
}

class _FavoriteDriversState extends BaseState<FavoriteDrivers> {
  DriverFavoriteBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.get());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<DriverFavoriteBloc>(context);
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Meus Motoristas Favoritos',
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        callback: () {
          Navigator.pop(context);
        },
      ),
      body: bloc.isLoading
          ? LoadingCircle()
          : bloc.list.length == 0
              ? Center(
                  child: Text('Nenhum favorito\nno momento',
                      style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center),
                )
              : Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                      itemCount: bloc.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var _model = bloc.list[index];
                        return FavoriteDriversItem(model: _model);
                      }),
                ),
    );
  }
}
