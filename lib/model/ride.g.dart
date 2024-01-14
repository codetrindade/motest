// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) {
  return Ride(
    distance: (json['distance'] as num)?.toDouble(),
    duration: (json['duration'] as num)?.toDouble(),
    polyline: json['polyline'] as String,
    back: json['back'] as bool,
  )
    ..id = json['id'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..date = json['date'] as String
    ..time = json['time'] as String
    ..reservations = json['reservations'] as int
    ..autoConfirm = json['auto_confirm'] as bool
    ..points = (json['points'] as List)
        ?.map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..distanceStart = (json['distance_start'] as num)?.toDouble()
    ..distanceEnd = (json['distance_end'] as num)?.toDouble()
    ..startAddress = json['start_address'] as String
    ..endAddress = json['end_address'] as String
    ..destiny = json['destiny'] == null
        ? null
        : Ride.fromJson(json['destiny'] as Map<String, dynamic>)
    ..lat = (json['lat'] as num)?.toDouble()
    ..long = (json['long'] as num)?.toDouble()
    ..driverName = json['driver_name'] as String
    ..photo = json['photo'] as String
    ..startTime = json['start_time'] as String
    ..endTime = json['end_time'] as String
    ..priceId = json['price_id'] as String
    ..payment = json['payment'] as String
    ..status = json['status'] as String
    ..ridePassengerId = json['ride_passenger_id'] as String;
}

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'date': instance.date,
      'time': instance.time,
      'reservations': instance.reservations,
      'auto_confirm': instance.autoConfirm,
      'distance': instance.distance,
      'duration': instance.duration,
      'points': instance.points,
      'back': instance.back,
      'distance_start': instance.distanceStart,
      'distance_end': instance.distanceEnd,
      'start_address': instance.startAddress,
      'end_address': instance.endAddress,
      'polyline': instance.polyline,
      'destiny': instance.destiny,
      'lat': instance.lat,
      'long': instance.long,
      'driver_name': instance.driverName,
      'photo': instance.photo,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'price_id': instance.priceId,
      'payment': instance.payment,
      'status': instance.status,
      'ride_passenger_id': instance.ridePassengerId,
    };
