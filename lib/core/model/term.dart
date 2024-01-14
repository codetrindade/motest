import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@JsonSerializable()
class Term {
  Rendered title;
  Rendered content;

  Term({this.title, this.content});

  factory Term.fromJson(Map<String, dynamic> map) => _$TermFromJson(map);

  Map<String, dynamic> toJson() => _$TermToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class Rendered {
  Rendered({this.rendered});

  String rendered;

  factory Rendered.fromJson(Map<String, dynamic> map) => _$RenderedFromJson(map);

  Map<String, dynamic> toJson() => _$RenderedToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
