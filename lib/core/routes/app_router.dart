import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../app/models/company.dart';
import '../../app/models/modules.dart';
/// Make sure to import `auto_route` and `material` (required)
/// Make sure to import `supabase_flutter` to provide its classes to `auto_route`

import '../../app/pages/1_module_one/module_one_page.dart';
import '../../app/pages/2_module_two/module_two_page.dart';
import '../../app/pages/3_module_three/module_three_page.dart';
import '../../app/pages/auth/sign_in_page.dart';
import '../../app/pages/home_layout_page.dart';
import '../../app/pages/home_page/home_page.dart';
import '../../app/pages/splash_screen_page.dart';
import 'guards/auth_guard.dart';
import 'guards/module_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashScreenRoute.page, initial: true),
        AutoRoute(page: SignInRoute.page, path: '/sign_in'),
        AutoRoute(
          path: '/',
          page: HomeLayoutRoute.page,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: '',
              title: (context, data) => 'Home',
            ),
            AutoRoute(
                page: ModuleOneRoute.page,
                path: 'module_one',
                guards: const [ModulesGuard(module: Modules.moduleOne)],
                title: (context, data) => 'Home'),
            AutoRoute(
                page: ModuleTwoRoute.page,
                path: 'module_two',
                guards: const [ModulesGuard(module: Modules.moduleTwo)],
                title: (context, data) => 'Home'),
            AutoRoute(page: ModuleTwoSubRoute.page, path: 'module_two/sub'),
            AutoRoute(
                page: ModuleThreeRoute.page,
                path: 'module_three',
                guards: const [ModulesGuard(module: Modules.moduleThree)],
                title: (context, data) => 'Home'),
          ],
        ),
      ];
}
