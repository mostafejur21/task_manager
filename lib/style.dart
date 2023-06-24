import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Colors.grey,
);

InputDecoration formInputDecoration(lebel) {
  return InputDecoration(
    labelText: lebel,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
