import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bac_manager/main.dart';
import 'package:bac_manager/models/subject.dart';
import 'package:bac_manager/models/student.dart';
import 'package:bac_manager/models/bac_type.dart';
import 'package:bac_manager/models/assigned_subject.dart';
import 'package:bac_manager/providers/student_provider.dart';
import 'package:bac_manager/providers/subject_provider.dart';

void main() {
  setUp(() async {
    final path = Directory.systemTemp.createTempSync('hive_test').path;
    Hive.init(path);

    // Register only if they aren't already registered in the test runner
    if (!Hive.isAdapterRegistered(BacTypeAdapter().typeId)) {
      Hive.registerAdapter(BacTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(SubjectAdapter().typeId)) {
      Hive.registerAdapter(SubjectAdapter());
    }
    if (!Hive.isAdapterRegistered(AssignedSubjectAdapter().typeId)) {
      Hive.registerAdapter(AssignedSubjectAdapter());
    }
    if (!Hive.isAdapterRegistered(StudentAdapter().typeId)) {
      Hive.registerAdapter(StudentAdapter());
    }

    await Hive.openBox<Subject>(SubjectNotifier.boxName);
    await Hive.openBox<Student>(StudentNotifier.boxName);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BacTutorManagerApp()));
    await tester.pumpAndSettle();
    expect(find.text('No students yet'), findsOneWidget);
  });
}
