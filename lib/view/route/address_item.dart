import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:moveme/component/moveme_icons.dart';
import 'package:moveme/model/address.dart';
import 'package:moveme/theme.dart';

import 'map_address/map_address.dart';

class AddressItem extends StatelessWidget {
  final Address model;
  final AddressPageListener listener;
  final SelectedPlaceListener clickListener;
  final bool isFromSelectAddressList;
  final bool isEmpty;

  AddressItem(
      {@required this.model,
      this.isFromSelectAddressList = false,
      this.listener,
      this.clickListener,
      this.isEmpty = false});

  Future<void> onEditAddressFinished(BuildContext context) async {
    if (isEmpty)
      listener.onEmptyClick(model);
    else {
      var a = await Navigator.of(context).push(PageTransition(
          type: PageTransitionType.transferUp,
          duration: Duration(seconds: 1),
          child: MapAddress(
              selectedAddress: Address(
                  address: model.address,
                  long: model.long,
                  lat: model.lat,
                  id: model.id))));

      if (a != null) {
        listener.onChangeAddress(a);
      }
    }
  }

  IconData getIcon() {
    if (model.type == 'house') return MoveMeIcons.home;
    if (model.type == 'job') return MoveMeIcons.work;
    if (model.isFavorite != null && model.isFavorite) return MoveMeIcons.star;
    return Icons.pin_drop;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(40.0),
          border: Border.all(
              color: AppColors.colorPrimary,
              style: BorderStyle.solid,
              width: 1)),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (isFromSelectAddressList)
            clickListener.onSelectAddress(Address.fromJson(model.toJson()));
          else
            onEditAddressFinished(context);
        },
        child: new Row(
          children: <Widget>[
            isFromSelectAddressList
                ? new Icon(getIcon(), color: AppColors.colorPrimary, size: 20.0)
                : new Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.colorPrimary),
                    child: Center(
                      child: new Text(model.order.toString(),
                          style: AppTextStyle.textWhiteSmallBold),
                    )),
            new SizedBox(width: 10.0),
            new Expanded(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  model.address,
                  style: AppTextStyle.textGreySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )),
            new SizedBox(width: 10.0),
            isFromSelectAddressList
                ? new Icon(Icons.arrow_forward_ios,
                    size: 16.0, color: AppColors.colorPrimary)
                : new GestureDetector(
                    onTap: () => listener.onRemoveAddress(model),
                    child: new Icon(Icons.clear,
                        size: 16.0, color: AppColors.colorPrimary),
                  )
          ],
        ),
      ),
    );
  }
}

abstract class AddressPageListener {
  void onChangeAddress(Address address);

  void onRemoveAddress(Address address);

  void onEmptyClick(Address address);
}

abstract class SelectedPlaceListener {
  void onSelectAddress(Address address);
}
