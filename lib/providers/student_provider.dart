import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../models/student.dart';
import '../models/assigned_subject.dart';
import '../models/bac_type.dart';
import '../models/subject.dart';

class StudentNotifier extends StateNotifier<List<Student>> {
  StudentNotifier() : super([]) {
    _load();
    _subscribeRealtime();
  }

  Future<void> _load() async {
    try {
      final studentsData = await supabase.from('students').select();
      final assignedData = await supabase.from('assigned_subjects').select();

      state = (studentsData as List).map((s) {
        final studentAssigned = (assignedData as List)
            .where((a) => a['student_id'] == s['id'])
            .map((e) => AssignedSubject.fromMap(e))
            .toList();
        return Student.fromMap(s, studentAssigned);
      }).toList();
    } catch (_) {}
  }

  void _subscribeRealtime() {
    supabase.from('students').stream(primaryKey: ['id']).listen((_) => _load());
    supabase
        .from('assigned_subjects')
        .stream(primaryKey: ['id'])
        .listen((_) => _load());
  }

  final _uuid = const Uuid();

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
    await supabase.from('students').insert(s.toMap());
    for (final a in s.assignedSubjects) {
      await supabase.from('assigned_subjects').insert(a.toMap(s.id));
    }
  }

  Future<void> updateStudent(Student student) async {
    await supabase
        .from('students')
        .update(student.toMap())
        .eq('id', student.id);
    await supabase
        .from('assigned_subjects')
        .delete()
        .eq('student_id', student.id);
    for (final a in student.assignedSubjects) {
      await supabase.from('assigned_subjects').insert(a.toMap(student.id));
    }
  }

  Future<void> deleteStudent(String id) async {
    await supabase.from('students').delete().eq('id', id);
  }

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
        total += global.pricePerBacType[student.bacType.name] ?? 0;
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
      Subject(id: '', name: '', iconName: 'help_outline', pricePerBacType: {});
}

final studentProvider = StateNotifierProvider<StudentNotifier, List<Student>>(
  (_) => StudentNotifier(),
);
