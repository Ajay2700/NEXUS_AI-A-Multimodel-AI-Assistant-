// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Extensions
// Dart extension utilities
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date/time formatting extensions.
extension DateTimeX on DateTime {
  /// "3:42 PM"
  String get timeFormatted => DateFormat.jm().format(this);

  /// "Mar 18"
  String get dateShort => DateFormat.MMMd().format(this);

  /// "March 18, 2024"
  String get dateLong => DateFormat.yMMMMd().format(this);

  /// "Today", "Yesterday", or "Mar 18"
  String get relativeDate {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return dateShort;
  }
}

/// String utilities.
extension StringX on String {
  /// Remove leading/trailing whitespace and collapse internal spaces.
  String get normalized => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Truncate to [maxLength] with ellipsis if needed.
  String truncateTo(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 1)}…';
  }
}

/// BuildContext convenience extensions.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
}
