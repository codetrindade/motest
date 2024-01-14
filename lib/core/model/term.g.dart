// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Term _$TermFromJson(Map<String, dynamic> json) {
  return Term(
    title: json['title'] == null
        ? null
        : Rendered.fromJson(json['title'] as Map<String, dynamic>),
    content: json['content'] == null
        ? null
        : Rendered.fromJson(json['content'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

Rendered _$RenderedFromJson(Map<String, dynamic> json) {
  return Rendered(
    rendered: json['rendered'] as String,
  );
}

Map<String, dynamic> _$RenderedToJson(Rendered instance) => <String, dynamic>{
      'rendered': instance.rendered,
    };
