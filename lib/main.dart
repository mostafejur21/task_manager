import 'package:flutter/material.dart';
import 'package:task_manager/style.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
