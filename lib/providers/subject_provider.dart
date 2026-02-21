import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/subject.dart';
import '../models/bac_type.dart';
import '../utils/icon_map.dart';

final subjectProvider = NotifierProvider<SubjectNotifier, List<Subject>>(() {
  return SubjectNotifier();
});

class SubjectNotifier extends Notifier<List<Subject>> {
  static const String boxName = 'subjects';
  late Box<Subject> _box;
  final _uuid = const Uuid();

  @override
  List<Subject> build() {
    _box = Hive.box<Subject>(boxName);
    return _box.values.toList();
  }

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
    await _box.put(s.id, s);
    state = _box.values.toList();
  }

  Future<void> updateSubject(Subject subject) async {
    await _box.put(subject.id, subject);
    state = _box.values.toList();
  }

  Future<void> deleteSubject(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  Subject? getSubjectById(String id) {
    return _box.get(id);
  }

  static Future<void> seedDefaults() async {
    final box = Hive.box<Subject>(boxName);
    if (box.isEmpty) {
      final uuid = const Uuid();
      final defaults = [
        _createDefault(uuid, 'Math', Icons.functions),
        _createDefault(uuid, 'Physique', Icons.bolt),
        _createDefault(uuid, 'Algorithme', Icons.code),
        _createDefault(uuid, 'STI', Icons.settings_suggest),
        _createDefault(uuid, 'Anglais', Icons.language),
        _createDefault(uuid, 'Français', Icons.translate),
        _createDefault(uuid, 'Arabe', Icons.auto_stories),
        _createDefault(uuid, 'Philo', Icons.psychology),
        _createDefault(uuid, 'Sciences', Icons.science),
      ];
      for (var s in defaults) {
        await box.put(s.id, s);
      }
    }
  }

  static Subject _createDefault(Uuid uuid, String name, IconData icon) {
    return Subject(
      id: uuid.v4(),
      name: name,
      iconName: iconToString(icon),
      pricePerBacType: {
        'math': 50.0,
        'science': 45.0,
        'informatique': 40.0,
        'lettres': 30.0,
        'technique': 35.0,
      },
    );
  }
}
