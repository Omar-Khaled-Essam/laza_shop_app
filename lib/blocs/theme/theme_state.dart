import 'package:flutter/material.dart';

class ThemeState {
  const ThemeState({required this.mode});

  final ThemeMode mode;

  bool get isDark => mode == ThemeMode.dark;
}
