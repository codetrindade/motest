import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveme/model/card/card.dart';
import 'package:moveme/theme.dart';

class BackCard extends StatelessWidget {
  CardData card;

  BackCard({this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      height: 200,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black54.withOpacity(0.2), blurRadius: 10.0, offset: Offset(0, 8))
          ],
          gradient: LinearGradient(
              colors: [AppColors.colorGradientPrimary, AppColors.colorGradientSecondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 25),
            height: 35,
            color: Colors.black.withOpacity(0.4),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 25),
                height: 40,
                width: 220,
                color: Colors.grey,
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.orange, //                   <--- border color
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    height: 40,
                    width: 70,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        card.cardCvv,
                        style: TextStyle(color: AppColors.colorBlueDark, fontSize: AppSizes.fontMedium),
                      ),
                    ),
                  ),
                ),
              )),
          // Align(
          //     alignment: Alignment.bottomRight,
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 10, right: 30),
          //       child: SvgPicture.asset('assets/images/mastercard.svg', width: 50),
          //     )),
        ],
      ),
    );
  }
}

class FrondCard extends StatelessWidget {
  final int index;
  final CardData card;

  FrondCard({this.index, this.card});

  final BoxDecoration borderActive = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(
      color: Colors.white,
      width: 1.0,
    ),
  );

  final BoxDecoration borderInactive = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(
      color: Colors.transparent,
      width: 1.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      height: 200,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black54.withOpacity(0.2), blurRadius: 10.0, offset: Offset(0, 8))
          ],
          gradient: LinearGradient(
              colors: [AppColors.colorGradientPrimary, AppColors.colorGradientSecondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: <Widget>[
            //YellowBorder(),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(5),
                decoration: index == 0 ? borderActive : borderInactive,
                child: Text(
                  card.cardNumber,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: SvgPicture.asset('assets/svg/card_chip.svg', width: 50))),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'NOME DO TITULAR',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: index == 1 ? borderActive : borderInactive,
                      child: Text(
                        card.holderName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'VALIDADE',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: index == 2 ? borderActive : borderInactive,
                      child: Text(
                        card.cardValidate,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
