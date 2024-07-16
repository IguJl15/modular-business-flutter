import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    log("AuthGuard: verifying if user is authenticated");
    final supabaseClient = Supabase.instance.client;

    final authenticated = supabaseClient.auth.currentSession != null;
    if (authenticated) {
      resolver.next(true);
    } else {
      log("AuthGuard: redirecting to SignInRoute");
      resolver.redirect(const SignInRoute(), replace: true);
    }
  }
}
