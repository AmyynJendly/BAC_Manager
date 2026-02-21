import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bac_manager/models/bac_type.dart';
import 'package:bac_manager/models/subject.dart';
import 'package:bac_manager/models/assigned_subject.dart';
import 'package:bac_manager/models/student.dart';
import 'package:bac_manager/providers/subject_provider.dart';
import 'package:bac_manager/providers/student_provider.dart';
import 'package:bac_manager/providers/theme_provider.dart';
import 'package:bac_manager/screens/home_screen.dart';
import 'package:bac_manager/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(BacTypeAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(AssignedSubjectAdapter());
  Hive.registerAdapter(StudentAdapter());

  // Open Boxes
  await Hive.openBox<Subject>(SubjectNotifier.boxName);
  await Hive.openBox<Student>(StudentNotifier.boxName);

  // Seed defaults if necessary
  await SubjectNotifier.seedDefaults();

  runApp(const ProviderScope(child: BacTutorManagerApp()));
}

class BacTutorManagerApp extends ConsumerWidget {
  const BacTutorManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'BAC Tutor Manager',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: const HomeScreen(),
    );
  }
}
