import 'package:flutter/material.dart';

const Map<String, IconData> kIconMap = {
  'functions': Icons.functions,
  'bolt': Icons.bolt,
  'code': Icons.code,
  'settings_suggest': Icons.settings_suggest,
  'language': Icons.language,
  'translate': Icons.translate,
  'auto_stories': Icons.auto_stories,
  'psychology': Icons.psychology,
  'science': Icons.science,
  'computer': Icons.computer,
  'biotech': Icons.biotech,
  'engineering': Icons.engineering,
  'menu_book': Icons.menu_book,
};

IconData iconFromString(String name) => kIconMap[name] ?? Icons.help_outline;

String iconToString(IconData icon) => kIconMap.entries
    .firstWhere(
      (e) => e.value.codePoint == icon.codePoint,
      orElse: () => const MapEntry('help_outline', Icons.help_outline),
    )
    .key;
