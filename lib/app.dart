import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routes/app_router.dart';

/// Entry widget of the app.
class App extends StatelessWidget {
  App({super.key}) {
    Supabase.instance.client.auth.onAuthStateChange;
  }

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(
          reevaluateListenable:
              ReevaluateListenable.stream(Supabase.instance.client.auth.onAuthStateChange)),
    );
  }
}
