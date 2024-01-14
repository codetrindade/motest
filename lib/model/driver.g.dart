// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) {
  return Driver(
    description: json['description'] as String,
    maxStopTime: json['max_stop_time'] as int,
    phone: json['phone'] as String,
    flag: json['flag'] as String,
    id: json['id'] as String,
    talk: json['talk'] as int,
    smoke: json['smoke'] as int,
    music: json['music'] as int,
    facebookId: json['facebookid'] as String,
    minPriceOne: (json['min_price_one'] as num)?.toDouble(),
    minPriceTwo: (json['min_price_two'] as num)?.toDouble(),
    paymentCredit: json['payment_credit'] as int,
    paymentDebit: json['payment_debit'] as int,
    paymentMoney: json['payment_money'] as int,
    priceOne: (json['price_one'] as num)?.toDouble(),
    priceTwo: (json['price_two'] as num)?.toDouble(),
    vehicle: json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'facebookid': instance.facebookId,
      'description': instance.description,
      'talk': instance.talk,
      'smoke': instance.smoke,
      'music': instance.music,
      'flag': instance.flag,
      'min_price_one': instance.minPriceOne,
      'min_price_two': instance.minPriceTwo,
      'price_one': instance.priceOne,
      'price_two': instance.priceTwo,
      'payment_money': instance.paymentMoney,
      'payment_debit': instance.paymentDebit,
      'payment_credit': instance.paymentCredit,
      'max_stop_time': instance.maxStopTime,
      'vehicle': instance.vehicle,
    };
