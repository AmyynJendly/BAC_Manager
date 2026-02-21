import 'package:hive/hive.dart';
import 'bac_type.dart';
import 'assigned_subject.dart';

part 'student.g.dart';

@HiveType(typeId: 3)
class Student {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final BacType bacType;

  @HiveField(3)
  final List<AssignedSubject> assignedSubjects;

  Student({
    required this.id,
    required this.name,
    required this.bacType,
    required this.assignedSubjects,
  });

  Student copyWith({
    String? name,
    BacType? bacType,
    List<AssignedSubject>? assignedSubjects,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      bacType: bacType ?? this.bacType,
      assignedSubjects: assignedSubjects ?? this.assignedSubjects,
    );
  }
}
