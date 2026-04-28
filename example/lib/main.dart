import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'platform_style_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final prefs = await SharedPreferences.getInstance();
  runApp(DuskmoonShowcaseApp(prefs: prefs));
}

class DuskmoonShowcaseApp extends StatelessWidget {
  const DuskmoonShowcaseApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DmPlatformStyle?>(
      valueListenable: platformStyleNotifier,
      builder: (context, platformStyle, _) {
        return DuskmoonApp(
          platformStyle: platformStyle,
          child: BlocProvider(
            create: (_) => DmThemeBloc(prefs: prefs),
            child: const App(),
          ),
        );
      },
    );
  }
}
