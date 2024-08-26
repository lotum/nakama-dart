// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nakama_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NakamaError _$NakamaErrorFromJson(Map<String, dynamic> json) => NakamaError(
      code: json['code'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$NakamaErrorToJson(NakamaError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
