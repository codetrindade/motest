import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  String payment;
  String translated;
  bool chosen = false;

  Payment({this.payment, this.translated});

  factory Payment.fromJson(Map<String, dynamic> map) => _$PaymentFromJson(map);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}