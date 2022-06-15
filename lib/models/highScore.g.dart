// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highScore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HighScore _$HighScoreFromJson(Map<String, dynamic> json) => HighScore(
      taps: json['taps'] as String?,
      time: json['time'] as String?,
      isCurrent: json['isCurrent'] as String?,
    );

Map<String, dynamic> _$HighScoreToJson(HighScore instance) => <String, dynamic>{
      'taps': instance.taps,
      'time': instance.time,
      'isCurrent': instance.isCurrent,
    };
