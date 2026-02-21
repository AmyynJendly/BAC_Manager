import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'bac_type.g.dart';

@HiveType(typeId: 0)
enum BacType {
  @HiveField(0)
  math,
  @HiveField(1)
  science,
  @HiveField(2)
  informatique,
  @HiveField(3)
  lettres,
  @HiveField(4)
  technique,
}

extension BacTypeExtension on BacType {
  String get label {
    switch (this) {
      case BacType.math:
        return 'Mathématiques';
      case BacType.science:
        return 'Sciences';
      case BacType.informatique:
        return 'Informatique';
      case BacType.lettres:
        return 'Lettres';
      case BacType.technique:
        return 'Technique';
    }
  }

  Color get color {
    switch (this) {
      case BacType.math:
        return Colors.indigo;
      case BacType.science:
        return Colors.green;
      case BacType.informatique:
        return Colors.blue;
      case BacType.lettres:
        return Colors.orange;
      case BacType.technique:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case BacType.math:
        return Icons.functions;
      case BacType.science:
        return Icons.biotech;
      case BacType.informatique:
        return Icons.computer;
      case BacType.lettres:
        return Icons.menu_book;
      case BacType.technique:
        return Icons.engineering;
    }
  }
}
