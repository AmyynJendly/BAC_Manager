import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../models/subject.dart';
import '../models/bac_type.dart';
import '../utils/icon_map.dart';

class SubjectNotifier extends StateNotifier<List<Subject>> {
  SubjectNotifier() : super([]) {
    _load();
    _subscribeRealtime();
  }

  Future<void> _load() async {
    try {
      final data = await supabase.from('subjects').select();
      state = (data as List).map((e) => Subject.fromMap(e)).toList();
    } catch (_) {}
  }

  void _subscribeRealtime() {
    supabase.from('subjects').stream(primaryKey: ['id']).listen((data) {
      state = data.map((e) => Subject.fromMap(e)).toList();
    });
  }

  final _uuid = const Uuid();

  Future<void> addSubject({
    required String name,
    required IconData icon,
    required Map<BacType, double> prices,
  }) async {
    final s = Subject(
      id: _uuid.v4(),
      name: name,
      iconName: iconToString(icon),
      pricePerBacType: prices.map((k, v) => MapEntry(k.name, v)),
    );
    await supabase.from('subjects').insert(s.toMap());
  }

  Future<void> updateSubject(Subject subject) async {
    await supabase
        .from('subjects')
        .update(subject.toMap())
        .eq('id', subject.id);
  }

  Future<void> deleteSubject(String id) async {
    await supabase.from('subjects').delete().eq('id', id);
  }

  Subject? getSubjectById(String id) {
    try {
      return state.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (_) => SubjectNotifier(),
);
