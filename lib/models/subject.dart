import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String iconName;

  @HiveField(3)
  Map<String, double> pricePerBacType;

  Subject({
    required this.id,
    required this.name,
    required this.iconName,
    required this.pricePerBacType,
  });

  Subject copyWith({
    String? name,
    String? iconName,
    Map<String, double>? pricePerBacType,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      pricePerBacType: pricePerBacType ?? this.pricePerBacType,
    );
  }
}
