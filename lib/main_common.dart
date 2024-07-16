import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'constants.dart';
import 'core/config/non_web_config.dart' if (dart.library.html) './core/config/web_config.dart';
import 'injectable.dart';

/// Used to validate certificates for local development.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

/// Shared `runApp` configuration.
///
/// Used to initialize all required dependencies, packages, and constants.
Future<void> mainCommon() async {
  configWeb();

  WidgetsFlutterBinding.ensureInitialized();

  /// Used to validate certificates for local development
  HttpOverrides.global = MyHttpOverrides();

  // Dependency injection (injectable)
  configureDependencies();

  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnonKey,
  );

  runApp(App());
}
