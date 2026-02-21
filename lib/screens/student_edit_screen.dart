import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../models/assigned_subject.dart';
import '../models/bac_type.dart';
import '../providers/student_provider.dart';
import '../providers/subject_provider.dart';
import '../utils/formatter.dart';
import '../utils/constants.dart';
import '../utils/icon_map.dart';

class StudentEditScreen extends ConsumerStatefulWidget {
  final Student? student;

  const StudentEditScreen({super.key, this.student});

  @override
  ConsumerState<StudentEditScreen> createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends ConsumerState<StudentEditScreen> {
  final _nameController = TextEditingController();
  late BacType _selectedBacType;
  final ValueNotifier<List<AssignedSubject>> _assignedSubjectsNotifier =
      ValueNotifier([]);
  final ValueNotifier<bool> _isHoveringNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedBacType = widget.student?.bacType ?? BacType.math;
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _assignedSubjectsNotifier.value = List.from(
        widget.student!.assignedSubjects,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _assignedSubjectsNotifier.dispose();
    _isHoveringNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalSubjects = ref.watch(subjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.kSpaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Basic Information'),
                  const SizedBox(height: AppConstants.kSpaceM),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Student Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: AppConstants.kSpaceL),
                  _buildSectionTitle('Select BAC Type'),
                  const SizedBox(height: AppConstants.kSpaceM),
                  _buildBacTypeSelector(),
                  const SizedBox(height: AppConstants.kSpaceL),
                  _buildSectionTitle('Subject Management'),
                  const SizedBox(height: AppConstants.kSpaceS),
                  const Text(
                    'Hold & drag to assign/reorder',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: AppConstants.kSpaceM),
                  _buildDragDropArea(globalSubjects),
                ],
              ),
            ),
          ),
          _buildSaveFooter(globalSubjects),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildBacTypeSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: BacType.values.length,
        itemBuilder: (context, index) {
          final type = BacType.values[index];
          final isSelected = _selectedBacType == type;
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.kSpaceM),
            child: InkWell(
              onTap: () => setState(() => _selectedBacType = type),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 120,
                decoration: BoxDecoration(
                  color: isSelected
                      ? type.color
                      : type.color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? type.color
                        : type.color.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: type.color.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type.icon,
                      color: isSelected ? Colors.white : type.color,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : type.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragDropArea(List<Subject> globalSubjects) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPoolArea(globalSubjects),
          const SizedBox(height: AppConstants.kSpaceL),
          _buildAssignedDropZone(globalSubjects),
        ],
      ),
    );
  }

  Widget _buildPoolArea(List<Subject> globalSubjects) {
    return ValueListenableBuilder<List<AssignedSubject>>(
      valueListenable: _assignedSubjectsNotifier,
      builder: (context, assigned, _) {
        final available = globalSubjects
            .where((gs) => !assigned.any((as) => as.subjectId == gs.id))
            .toList();
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: available
              .map((s) => _DraggableSubjectChip(subject: s))
              .toList(),
        );
      },
    );
  }

  Widget _buildAssignedDropZone(List<Subject> globalSubjects) {
    return DragTarget<Subject>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final subject = details.data;
        if (!_assignedSubjectsNotifier.value.any(
          (as) => as.subjectId == subject.id,
        )) {
          _assignedSubjectsNotifier.value = [
            ..._assignedSubjectsNotifier.value,
            AssignedSubject(subjectId: subject.id),
          ];
        }
        _isHoveringNotifier.value = false;
      },
      onMove: (_) => _isHoveringNotifier.value = true,
      onLeave: (_) => _isHoveringNotifier.value = false,
      builder: (context, candidateData, rejectedData) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isHoveringNotifier,
          builder: (context, isHovering, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: const BoxConstraints(minHeight: 120),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isHovering
                    ? Colors.teal.withValues(alpha: 0.1)
                    : Colors.teal.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isHovering
                      ? Colors.teal
                      : Colors.teal.withValues(alpha: 0.2),
                  width: 2,
                  style: isHovering ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: ValueListenableBuilder<List<AssignedSubject>>(
                valueListenable: _assignedSubjectsNotifier,
                builder: (context, assigned, _) {
                  if (assigned.isEmpty) {
                    return const Center(
                      child: Text(
                        'Drop subjects here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assigned.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = assigned.removeAt(oldIndex);
                        assigned.insert(newIndex, item);
                        _assignedSubjectsNotifier.value = List.from(assigned);
                      });
                    },
                    itemBuilder: (context, index) {
                      final as = assigned[index];
                      final global = globalSubjects.firstWhere(
                        (s) => s.id == as.subjectId,
                      );
                      return _AssignedSubjectListItem(
                        key: ValueKey(as.subjectId),
                        assigned: as,
                        global: global,
                        studentBacType: _selectedBacType,
                        onRemove: () {
                          _assignedSubjectsNotifier.value = List.from(assigned)
                            ..removeAt(index);
                        },
                        onUpdatePrice: (price) {
                          final newList = List<AssignedSubject>.from(assigned);
                          newList[index] = as.copyWith(customPrice: price);
                          _assignedSubjectsNotifier.value = newList;
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSaveFooter(List<Subject> globalSubjects) {
    return ValueListenableBuilder<List<AssignedSubject>>(
      valueListenable: _assignedSubjectsNotifier,
      builder: (context, assigned, _) {
        final total = ref
            .read(studentProvider.notifier)
            .getStudentTotalPrice(
              Student(
                id: '',
                name: '',
                bacType: _selectedBacType,
                assignedSubjects: assigned,
              ),
              globalSubjects,
            );
        return Container(
          padding: const EdgeInsets.all(AppConstants.kSpaceL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Running Total',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        Formatter.formatPrice(total),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF3D5AFE),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveStudent,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF3D5AFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Student',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveStudent() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter name')));
      return;
    }
    final assigned = _assignedSubjectsNotifier.value;
    if (widget.student == null) {
      ref
          .read(studentProvider.notifier)
          .addStudent(
            name: name,
            bacType: _selectedBacType,
            subjects: assigned,
          );
    } else {
      ref
          .read(studentProvider.notifier)
          .updateStudent(
            widget.student!.copyWith(
              name: name,
              bacType: _selectedBacType,
              assignedSubjects: assigned,
            ),
          );
    }
    Navigator.pop(context);
  }
}

class _DraggableSubjectChip extends StatelessWidget {
  final Subject subject;

  const _DraggableSubjectChip({required this.subject});

  @override
  Widget build(BuildContext context) {
    final icon = iconFromString(subject.iconName);
    return Draggable<Subject>(
      data: subject,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                subject.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildChip(context, icon),
      ),
      child: _buildChip(context, icon),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(subject.name),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _AssignedSubjectListItem extends StatelessWidget {
  final AssignedSubject assigned;
  final Subject global;
  final BacType studentBacType;
  final VoidCallback onRemove;
  final Function(double?) onUpdatePrice;

  const _AssignedSubjectListItem({
    super.key,
    required this.assigned,
    required this.global,
    required this.studentBacType,
    required this.onRemove,
    required this.onUpdatePrice,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPrice = global.pricePerBacType[studentBacType.name] ?? 0.0;
    final displayPrice = assigned.customPrice ?? defaultPrice;
    final isOverridden = assigned.customPrice != null;
    final icon = iconFromString(global.iconName);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          global.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Text(
              Formatter.formatPrice(displayPrice),
              style: TextStyle(
                color: isOverridden ? Colors.orange : Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (isOverridden) ...[
              const SizedBox(width: 4),
              const Text(
                '(Custom)',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => onUpdatePrice(null),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showPriceEditSheet(context),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onRemove,
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showPriceEditSheet(BuildContext context) {
    final defaultPrice = global.pricePerBacType[studentBacType.name] ?? 0.0;
    final controller = TextEditingController(
      text: (assigned.customPrice ?? defaultPrice).toString(),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Price: ${global.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Price override',
                suffixText: ' DT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => onUpdatePrice(null),
                  child: const Text('Reset to Default'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    final p = double.tryParse(controller.text);
                    if (p != null) onUpdatePrice(p);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
