import 'package:json_annotation/json_annotation.dart';

part 'highScore.g.dart';

@JsonSerializable()
class HighScore {
  String? taps, time, isCurrent;
  HighScore({
    this.taps,
    this.time,
    this.isCurrent,
  });

  factory HighScore.fromJson(Map<String, dynamic> json) =>
      _$HighScoreFromJson(json);
  Map<String, dynamic> toJson() => _$HighScoreToJson(this);
}
