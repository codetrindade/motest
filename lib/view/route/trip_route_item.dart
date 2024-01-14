import 'package:flutter/material.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/theme.dart';

class TripRouteItem extends StatelessWidget {
  final List<Address> routes;

  TripRouteItem({@required this.routes});

  List<Widget> getItems() {
    List<Widget> items = List();
    items.add(Text('Origem:', style: AppTextStyle.textWhiteSmallBold));
    items.add(Text(routes.first.address, maxLines: 5, style: AppTextStyle.textWhiteExtraSmall));
    items.add(Container(color: AppColors.colorWhite, margin: EdgeInsets.only(right: 10, top: 10, bottom: 10), height: 1));
    items.add(Text(routes.length > 2 ? 'Destinos:' : 'Destino:', style: AppTextStyle.textWhiteSmallBold));

    routes.forEach((address) {
      if (address.order == 0) return;
      items.add(SizedBox(height: 5.0));
      items.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        routes.length > 2 ? Text((address.order).toString() + '.', style: AppTextStyle.textBlueLightSmallBold) : SizedBox(),
        SizedBox(width: 5.0),
        Expanded(
            child: Text(address.address, overflow: TextOverflow.ellipsis, maxLines: 5, style: AppTextStyle.textWhiteExtraSmall))
      ]));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: getItems()),
    );
  }
}
