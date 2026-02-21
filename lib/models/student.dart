import 'package:hive/hive.dart';
import 'bac_type.dart';
import 'assigned_subject.dart';

part 'student.g.dart';

@HiveType(typeId: 3)
class Student extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  BacType bacType;

  @HiveField(3)
  List<AssignedSubject> assignedSubjects;

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
