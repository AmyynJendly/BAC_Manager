import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../models/bac_type.dart';
import '../providers/subject_provider.dart';
import '../utils/constants.dart';
import '../utils/icon_map.dart';

class SubjectManagerScreen extends ConsumerStatefulWidget {
  const SubjectManagerScreen({super.key});

  @override
  ConsumerState<SubjectManagerScreen> createState() =>
      _SubjectManagerScreenState();
}

class _SubjectManagerScreenState extends ConsumerState<SubjectManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Manager'),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.kSpaceM),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return _SubjectExpansionTile(
            subject: subject,
            onEdit: () => _showAddEditSubjectDialog(context, subject),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSubjectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditSubjectDialog(BuildContext context, [Subject? subject]) {
    final nameController = TextEditingController(text: subject?.name);
    IconData selectedIcon = subject != null
        ? iconFromString(subject.iconName)
        : Icons.book;
    final prices = subject != null
        ? subject.pricePerBacType.map(
            (k, v) =>
                MapEntry(BacType.values.firstWhere((e) => e.name == k), v),
          )
        : {for (var t in BacType.values) t: 40.0};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject == null ? 'Add New Subject' : 'Edit Subject',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose Icon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final icon = await _showIconPicker(context);
                    if (icon != null) {
                      setModalState(() => selectedIcon = icon);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selectedIcon,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        const Text('Change Icon'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Default Prices per BAC Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...BacType.values.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(type.icon, size: 16, color: type.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            type.label,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            initialValue: prices[type]?.toString() ?? '40.0',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              suffixText: ' DT',
                            ),
                            onChanged: (v) =>
                                prices[type] = double.tryParse(v) ?? 40.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;

                      if (subject == null) {
                        ref
                            .read(subjectProvider.notifier)
                            .addSubject(
                              name: name,
                              icon: selectedIcon,
                              prices: prices,
                            );
                      } else {
                        ref
                            .read(subjectProvider.notifier)
                            .updateSubject(
                              subject.copyWith(
                                name: name,
                                iconName: iconToString(selectedIcon),
                                pricePerBacType: prices.map(
                                  (k, v) => MapEntry(k.name, v),
                                ),
                              ),
                            );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save Subject'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<IconData?> _showIconPicker(BuildContext context) async {
    final List<IconData> commonIcons = [
      Icons.book,
      Icons.science,
      Icons.functions,
      Icons.bolt,
      Icons.code,
      Icons.language,
      Icons.translate,
      Icons.psychology,
      Icons.engineering,
      Icons.computer,
      Icons.calculate,
      Icons.history_edu,
      Icons.draw,
      Icons.music_note,
      Icons.sports_basketball,
      Icons.biotech,
      Icons.architecture,
      Icons.brush,
      Icons.public,
      Icons.auto_stories,
      Icons.menu_book,
      Icons.settings_suggest,
      Icons.analytics,
      Icons.memory,
      Icons.terminal,
    ];

    return showDialog<IconData>(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = commonIcons
                .where(
                  (i) => i.toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();
            return AlertDialog(
              title: const Text('Select Icon'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search icons...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => setState(() => searchQuery = v),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => IconButton(
                          icon: Icon(filtered[index]),
                          onPressed: () =>
                              Navigator.pop(context, filtered[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SubjectExpansionTile extends ConsumerWidget {
  final Subject subject;
  final VoidCallback onEdit;

  const _SubjectExpansionTile({required this.subject, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = iconFromString(subject.iconName);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.kSpaceM),
      child: ExpansionTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          subject.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${subject.pricePerBacType.length} BAC Types Configured',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        children: [_PriceConfigurationTable(subject: subject)],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject?'),
        content: Text(
          'Delete "${subject.name}"? This will remove it from all students.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(subjectProvider.notifier).deleteSubject(subject.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PriceConfigurationTable extends ConsumerWidget {
  final Subject subject;

  const _PriceConfigurationTable({required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.kSpaceM),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: Text('BAC Type', style: _headerStyle())),
              Expanded(
                flex: 2,
                child: Text('Default Price (DT)', style: _headerStyle()),
              ),
            ],
          ),
          const Divider(),
          ...BacType.values.map((type) {
            final price = subject.pricePerBacType[type.name] ?? 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Icon(type.icon, size: 14, color: type.color),
                        const SizedBox(width: 8),
                        Text(type.label, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: price.toStringAsFixed(2),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        suffixText: ' DT',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        final newPrice = double.tryParse(value) ?? price;
                        final updatedPrices = Map<String, double>.from(
                          subject.pricePerBacType,
                        );
                        updatedPrices[type.name] = newPrice;
                        ref
                            .read(subjectProvider.notifier)
                            .updateSubject(
                              subject.copyWith(pricePerBacType: updatedPrices),
                            );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.grey,
  );
}
