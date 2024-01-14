import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class CardData {
  String id;

  String brand = '';

  @JsonKey(name: 'card_id')
  String cardId = '';

  @JsonKey(name: 'card_number')
  String cardNumber = '';

  @JsonKey(name: 'holder_name')
  String holderName = '';
  bool favorite = false;

  @JsonKey(name: 'card_validate')
  String cardValidate = '';

  @JsonKey(name: 'card_cvv', ignore: true)
  String cardCvv = '';

  @JsonKey(name: 'card_token')
  String cardToken = '';

  @JsonKey(name: 'zipcode')
  String zipCode;
  String neighborhood;
  String street;
  String complement;
  @JsonKey(name: 'street_number', nullable: true)
  String streetNumber;
  String city;
  String state;
  String document;

  CardData();

  factory CardData.fromJson(Map<String, dynamic> map) => _$CardDataFromJson(map);

  Map<String, dynamic> toJson() => _$CardDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
