import 'package:json_annotation/json_annotation.dart';

part 'nakama_error.g.dart';

@JsonSerializable()
class NakamaError implements Exception {
  NakamaError({
    this.code,
    this.message,
  });

  final int? code;
  final String? message;

  factory NakamaError.fromJson(Map<String, dynamic> json) =>
      _$NakamaErrorFromJson(json);

  Map<String, dynamic> toJson() => _$NakamaErrorToJson(this);

  @override
  String toString() => 'NakamaError: code: $code, message: $message';
}
