import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_manager/main.dart';
import 'package:bac_manager/providers/subject_provider.dart';
import 'package:bac_manager/models/bac_type.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BacTutorManagerApp()));
    expect(find.text('No students yet'), findsOneWidget);
  });
}
