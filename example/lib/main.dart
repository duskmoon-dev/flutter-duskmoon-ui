import 'package:flutter/material.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';

void main() {
  runApp(const DuskmoonShowcaseApp());
}

class DuskmoonShowcaseApp extends StatelessWidget {
  const DuskmoonShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuskMoon UI Showcase',
      theme: DmThemeData.sunshine(),
      darkTheme: DmThemeData.moonlight(),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('DuskMoon UI Showcase'),
        ),
      ),
    );
  }
}
