import 'package:json_annotation/json_annotation.dart';

part 'memory.g.dart';

@JsonSerializable()
class Memory {
  bool? iSelected;
  String? assetPath;
  Memory({
    this.assetPath,
    this.iSelected,
  });

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);
  Map<String, dynamic> toJson() => _$MemoryToJson(this);
}
