import 'package:flutter/material.dart';
import 'package:moveme/theme.dart';

class ConfirmSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String text;

  ConfirmSheet({@required this.onConfirm, @required this.onCancel, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(children: <Widget>[
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text(text,
                    textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold))),
        Row(children: <Widget>[
          Expanded(
              child: InkWell(
                  onTap: () => onConfirm(),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Theme.of(context).colorScheme.primaryVariant, width: 0.5))),
                      height: 70,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                        Expanded(child: Icon(Icons.check_circle, color: AppColors.colorBlueLight)),
                        Text('Sim', style: AppTextStyle.textBlueLightSmallBold)
                      ])))),
          Expanded(
            child: InkWell(
              onTap: () => onCancel(),
              child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(vertical: 5),
                color: Theme.of(context).colorScheme.primaryVariant,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Expanded(child: Icon(Icons.cancel, color: Colors.white)),
                  Text('Não', style: AppTextStyle.textWhiteSmallBold)
                ]),
              ),
            ),
          )
        ])
      ]),
    );
  }
}
