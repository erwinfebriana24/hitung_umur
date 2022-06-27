import 'package:hive/hive.dart';

part 'age.g.dart';

@HiveType(typeId: 0)

class Age extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? nama;
  @HiveField(2)
  String? tanggal_lahir;
  @HiveField(3)
  String? jenis_kelamin;
  @HiveField(4)
  String? hari_umur;
  @HiveField(5)
  String? bulan_umur;
  @HiveField(6)
  String? tahun_umur;
  @HiveField(7)
  String? hari_ultah;
  @HiveField(8)
  String? bulan_ultah;
  @HiveField(9)
  String? tahun_ultah;
}
class AgeManager{
  static Box<Age> getAllNote() => Hive.box<Age>('age');
}
