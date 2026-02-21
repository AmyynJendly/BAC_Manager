import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:bac_manager/models/student.dart';
import 'package:bac_manager/models/assigned_subject.dart';
import 'package:bac_manager/models/bac_type.dart';
import 'package:bac_manager/models/subject.dart';

final studentProvider = NotifierProvider<StudentNotifier, List<Student>>(() {
  return StudentNotifier();
});

class StudentNotifier extends Notifier<List<Student>> {
  static const String boxName = 'students';
  late Box<Student> _box;
  final _uuid = const Uuid();

  @override
  List<Student> build() {
    _box = Hive.box<Student>(boxName);
    return _box.values.toList();
  }

  Future<void> addStudent({
    required String name,
    required BacType bacType,
    required List<AssignedSubject> subjects,
  }) async {
    final s = Student(
      id: _uuid.v4(),
      name: name,
      bacType: bacType,
      assignedSubjects: subjects,
    );
    await _box.put(s.id, s);
    state = _box.values.toList();
  }

  Future<void> updateStudent(Student student) async {
    await _box.put(student.id, student);
    state = _box.values.toList();
  }

  Future<void> deleteStudent(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  // Price Calculation Logic
  double getStudentTotalPrice(Student student, List<Subject> globalSubjects) {
    double total = 0;
    for (var assigned in student.assignedSubjects) {
      if (assigned.customPrice != null) {
        total += assigned.customPrice!;
      } else {
        final global = globalSubjects.firstWhere(
          (s) => s.id == assigned.subjectId,
          orElse: () => _emptySubject(),
        );
        total += global.pricePerBacType[student.bacType] ?? 0;
      }
    }
    return total;
  }

  double calculateGrandTotal(List<Subject> globalSubjects) {
    double total = 0;
    for (var student in state) {
      total += getStudentTotalPrice(student, globalSubjects);
    }
    return total;
  }

  Subject _emptySubject() =>
      Subject(id: '', name: '', iconCodePoint: 0, pricePerBacType: {});
}
