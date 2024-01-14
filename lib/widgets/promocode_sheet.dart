import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveme/core/bloc/route/route_create_bloc.dart';
import 'package:moveme/model/promocode.dart';
import 'package:moveme/theme.dart';
import 'package:provider/provider.dart';

class PromocodeSheet extends StatefulWidget {
  final Function callback;

  PromocodeSheet({this.callback});

  @override
  _PromocodeSheetState createState() => _PromocodeSheetState();
}

class _PromocodeSheetState extends State<PromocodeSheet> {
  RouteCreateBloc bloc;

  Promocode selected = Promocode(code: '');

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RouteCreateBloc>(context);

    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, left: 30, right: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(children: [
          Row(children: [
            SizedBox(width: 40),
            Expanded(child: Center(child: Text('Vouchers Disponíveis', style: AppTextStyle.textPurpleSmallBold))),
            InkWell(
                onTap: () {
                  widget.callback(null);
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, color: AppColors.colorPrimary))
          ]),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var voucher in bloc.promocodes)
                    InkWell(
                      onTap: () {
                        setState(() {
                          this.selected = voucher;
                        });
                      },
                      child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.colorGrey.withOpacity(0.4)))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('#${voucher.code}', style: AppTextStyle.textThirdBoldSmall, maxLines: 1),
                                  SizedBox(height: 10),
                                  Text(voucher.description, style: AppTextStyle.textGreyDarkSmall, maxLines: 2),
                                  SizedBox(height: 10),
                                  Text('R\$ ${voucher.discount}', style: AppTextStyle.textPurpleSmallBold)
                                ]),
                              ),
                              Icon(this.selected.code != voucher.code ? Icons.radio_button_off : Icons.radio_button_on,
                                  color: AppColors.colorPrimary)
                            ],
                          )),
                    )
                ],
              ),
            ),
          ),
          if (this.selected.code.isNotEmpty)
            InkWell(
              onTap: () {
                widget.callback(this.selected);
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                  height: AppSizes.buttonHeight,
                  decoration: BoxDecoration(color: AppColors.colorBlueLight, borderRadius: AppSizes.buttonCorner),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Confirmar', style: AppTextStyle.textWhiteSmallBold)],
                  ))),
            )
        ]));
  }
}
