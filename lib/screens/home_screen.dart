import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';
import '../providers/subject_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/student_card.dart';
import '../widgets/grand_total_footer.dart';
import 'student_edit_screen.dart';
import 'subject_manager_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentProvider);
    final globalSubjects = ref.watch(subjectProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BAC Tutor Manager'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                key: ValueKey(themeMode),
              ),
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubjectManagerScreen()),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3D5AFE), Color(0xFF536DFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: students.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.kSpaceM),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return StudentCard(student: student);
                    },
                  ),
                ),
                GrandTotalFooter(
                  total: ref
                      .read(studentProvider.notifier)
                      .calculateGrandTotal(globalSubjects),
                  studentCount: students.length,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentEditScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: AppConstants.kSpaceM),
          Text(
            'No students yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppConstants.kSpaceS),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentEditScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add your first student'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kSpaceL,
                vertical: AppConstants.kSpaceM,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
