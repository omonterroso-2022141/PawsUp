import 'package:flutter/material.dart';

const List<Color> _colorThemes = [
  Colors.indigo,
  Colors.redAccent,
  Colors.greenAccent,
  Colors.pinkAccent,
  Colors.white70,
  Colors.white10,
  Colors.yellowAccent
];

class AppTheme {
  final int selectedColor;
  AppTheme({this.selectedColor = 0}): assert (selectedColor >=0 && selectedColor <= _colorThemes.length - 1,
  'Colors must be between = and ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
    );
  }
}
