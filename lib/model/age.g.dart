// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgeAdapter extends TypeAdapter<Age> {
  @override
  final int typeId = 0;

  @override
  Age read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Age()
      ..id = fields[0] as int?
      ..nama = fields[1] as String?
      ..tanggal_lahir = fields[2] as String?
      ..jenis_kelamin = fields[3] as String?
      ..hari_umur = fields[4] as String?
      ..bulan_umur = fields[5] as String?
      ..tahun_umur = fields[6] as String?
      ..hari_ultah = fields[7] as String?
      ..bulan_ultah = fields[8] as String?
      ..tahun_ultah = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, Age obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.tanggal_lahir)
      ..writeByte(3)
      ..write(obj.jenis_kelamin)
      ..writeByte(4)
      ..write(obj.hari_umur)
      ..writeByte(5)
      ..write(obj.bulan_umur)
      ..writeByte(6)
      ..write(obj.tahun_umur)
      ..writeByte(7)
      ..write(obj.hari_ultah)
      ..writeByte(8)
      ..write(obj.bulan_ultah)
      ..writeByte(9)
      ..write(obj.tahun_ultah);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
