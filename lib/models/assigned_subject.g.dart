// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignedSubjectAdapter extends TypeAdapter<AssignedSubject> {
  @override
  final int typeId = 2;

  @override
  AssignedSubject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignedSubject(
      subjectId: fields[0] as String,
      customPrice: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, AssignedSubject obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.customPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignedSubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
