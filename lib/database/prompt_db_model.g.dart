// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromptAdapter extends TypeAdapter<Prompt> {
  @override
  final int typeId = 0;

  @override
  Prompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prompt(
      id: fields[0] as int,
      dateTime: fields[1] as DateTime,
      prompt: fields[2] as String,
      result: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prompt obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.prompt)
      ..writeByte(3)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
