import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:moveme/model/vehicle.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
  String id;
  String phone;
  @JsonKey(name: 'facebookid')
  String facebookId;
  String description;
  int talk;
  int smoke;
  int music;
  String flag;
  @JsonKey(name: 'min_price_one', nullable: true)
  double minPriceOne;
  @JsonKey(name: 'min_price_two', nullable: true)
  double minPriceTwo;
  @JsonKey(name: 'price_one', nullable: true)
  double priceOne;
  @JsonKey(name: 'price_two', nullable: true)
  double priceTwo;
  @JsonKey(name: 'payment_money', nullable: true)
  int paymentMoney;
  @JsonKey(name: 'payment_debit', nullable: true)
  int paymentDebit;
  @JsonKey(name: 'payment_credit', nullable: true)
  int paymentCredit;
  @JsonKey(name: 'max_stop_time')
  int maxStopTime;
  Vehicle vehicle;

  Driver(
      {this.description,
      this.maxStopTime,
      this.phone,
      this.flag,
      this.id,
      this.talk,
      this.smoke,
      this.music,
      this.facebookId,
      this.minPriceOne,
      this.minPriceTwo,
      this.paymentCredit,
      this.paymentDebit,
      this.paymentMoney,
      this.priceOne,
      this.priceTwo,
      this.vehicle});

  factory Driver.fromJson(Map<String, dynamic> map) => _$DriverFromJson(map);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
