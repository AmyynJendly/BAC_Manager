import 'package:hive/hive.dart';
import 'bac_type.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final String? iconFontFamily;

  @HiveField(4)
  final Map<BacType, double> pricePerBacType;

  Subject({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.iconFontFamily,
    required this.pricePerBacType,
  });

  Subject copyWith({
    String? name,
    int? iconCodePoint,
    String? iconFontFamily,
    Map<BacType, double>? pricePerBacType,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      pricePerBacType: pricePerBacType ?? this.pricePerBacType,
    );
  }
}
