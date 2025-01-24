import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ValueKeyConverter
    implements JsonConverter<ValueKey, Map<String, dynamic>> {
  const ValueKeyConverter();

  @override
  ValueKey fromJson(Map<String, dynamic> json) {
    return ValueKey(json['value']);
  }

  @override
  Map<String, dynamic> toJson(ValueKey key) {
    return {
      'value': key.value,
    };
  }
}
