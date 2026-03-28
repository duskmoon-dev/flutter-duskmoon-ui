import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(DuskmoonShowcaseApp(prefs: prefs));
}

class DuskmoonShowcaseApp extends StatelessWidget {
  const DuskmoonShowcaseApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DmThemeBloc(prefs: prefs),
      child: BlocBuilder<DmThemeBloc, DmThemeState>(
        builder: (context, state) {
          final entry = state.entry;
          return MaterialApp(
            title: 'DuskMoon UI Showcase',
            theme: entry.light,
            darkTheme: entry.dark,
            themeMode: state.themeMode,
            home: const Scaffold(
              body: Center(child: Text('DuskMoon UI Showcase')),
            ),
          );
        },
      ),
    );
  }
}
