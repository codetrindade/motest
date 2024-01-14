import 'package:flutter/material.dart';
import 'package:moveme/base/base_state.dart';
import 'package:moveme/component/app_bar_custom.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/core/bloc/history/history_bloc.dart';
import 'package:moveme/theme.dart';
import 'package:moveme/view/ride/available_transports/available_transports_item.dart';
import 'package:provider/provider.dart';
import 'history_list_item.dart';

class HistoryListPage extends StatefulWidget {
  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends BaseState<HistoryListPage> {
  PageController _pageController;
  int _page = 0;

  int _activeHistory = 0;
  HistoryBloc bloc;

  _HistoryListPageState() {
    _pageController = PageController();
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget bodyList() {
    return bloc.isLoading
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorBlueDark))))
        : bloc.historyRide.length == 0
            ? Center(child: Text('Nenhum item encontrado', style: AppTextStyle.textGreySmallBold))
            : ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: bloc.historyRide.length,
                itemBuilder: (BuildContext context, int index) {
                  return AvailableTransportsItem(
                      model: bloc.historyRide[index],
                      last: index == bloc.historyRide.length - 1,
                      payment: '',
                      callback: () async => await bloc.getRideHistory());
                });
  }

  Widget bodyListRoute() {
    return bloc.isLoading
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorBlueDark))))
        : bloc.historyRoute.length == 0
            ? Center(child: Text('Nenhum item encontrado', style: AppTextStyle.textGreySmallBold))
            : Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: 10.0, right: 10.0),
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                    itemCount: bloc.historyRoute.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HistoryListItem(model: bloc.historyRoute[index]);
                    }),
              );
  }

  Widget bodyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        FlatButton(
            onPressed: () => navigationTapped(2, 1),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorPrimary),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: <Widget>[
                  Icon(MoveMeIcons.car_compact, color: AppColors.colorPrimary),
                  SizedBox(width: 30.0),
                  Expanded(child: Text('Corridas', style: AppTextStyle.textGreySmall)),
                  Icon(Icons.arrow_forward_ios, color: AppColors.colorPrimary)
                ],
              ),
            )),
        /*FlatButton(
            onPressed: () => navigationTapped(1, 2),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
              child: Row(
                children: <Widget>[
                  Icon(MoveMeIcons.people, color: AppColors.colorPrimary),
                  SizedBox(width: 30.0),
                  Expanded(child: Text('Caronas', style: AppTextStyle.textGreySmall)),
                  Icon(Icons.arrow_forward_ios, color: AppColors.colorPrimary)
                ],
              ),
            )),*/
        // FlatButton(
        //     onPressed: () => navigationTapped(1, 3),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        //       margin: EdgeInsets.symmetric(vertical: 15.0),
        //       decoration: BoxDecoration(
        //           border: Border.all(color: AppColors.colorPrimary), borderRadius: BorderRadius.circular(30.0)),
        //       child: Row(
        //         children: <Widget>[
        //           Icon(MoveMeIcons.helicopter, color: AppColors.colorPrimary),
        //           SizedBox(width: 30.0),
        //           Expanded(child: Text('Helicóptero', style: AppTextStyle.textGreySmall)),
        //           Icon(Icons.arrow_forward_ios, color: AppColors.colorPrimary)
        //         ],
        //       ),
        //     )),
      ],
    );
  }

  void navigationTapped(int page, int typeHistory) {
    _activeHistory = typeHistory;
    getHistory(typeHistory);
    _page = page;
    setState(() {
      _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void getHistory(int typeHistory) {
    switch (typeHistory) {
      case 1:
        bloc.getRouteHistory();
        break;
      case 2:
        bloc.getRideHistory();
        break;
      default:
        break;
    }
  }

  getTitle() {
    switch (_activeHistory) {
      case 0:
        return 'Histórico';
        break;
      case 1:
        return 'Corridas';
        break;
      case 2:
        return 'Caronas';
        break;
      case 3:
        return 'Helicóptero';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<HistoryBloc>(context);

    return WillPopScope(
      onWillPop: () {
        if (_page > 0)
          navigationTapped(0, 0);
        else
          Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBarCustom(
          title: getTitle(),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          callback: _activeHistory > 0 ? () => navigationTapped(0, 0) : null,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
                child: PageView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[bodyOptions(), bodyList(), bodyListRoute()],
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09)
          ],
        ),
      ),
    );
  }
}
