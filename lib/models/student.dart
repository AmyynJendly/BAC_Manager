import 'bac_type.dart';
import 'assigned_subject.dart';

class Student {
  final String id;
  final String name;
  final BacType bacType;
  final List<AssignedSubject> assignedSubjects;

  Student({
    required this.id,
    required this.name,
    required this.bacType,
    this.assignedSubjects = const [],
  });

  factory Student.fromMap(
    Map<String, dynamic> map,
    List<AssignedSubject> assigned,
  ) => Student(
    id: map['id'],
    name: map['name'],
    bacType: BacType.values.byName(map['bac_type']),
    assignedSubjects: assigned,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'bac_type': bacType.name,
  };

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
