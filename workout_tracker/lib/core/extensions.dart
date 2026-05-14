import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toPersianDate() {
    final formatter = DateFormat('yyyy/MM/dd', 'fa');
    return formatter.format(this);
  }

  String toFormattedDate() {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(this);
  }

  String toFormattedTime() {
    final formatter = DateFormat('HH:mm');
    return formatter.format(this);
  }
}

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
}
