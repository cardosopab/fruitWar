// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memory _$MemoryFromJson(Map<String, dynamic> json) => Memory(
      assetPath: json['assetPath'] as String?,
      iSelected: json['iSelected'] as bool?,
    );

Map<String, dynamic> _$MemoryToJson(Memory instance) => <String, dynamic>{
      'iSelected': instance.iSelected,
      'assetPath': instance.assetPath,
    };
