import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/routes/app_router.dart';
import '../../injectable.dart';
import '../models/modules.dart';
import '../widgets/modules_controller.dart';

typedef NavigationRailModuleItem = ({
  int moduleId,
  String name,
  Widget icon,
  PageRouteInfo? route,
});

typedef NavigationRailRouteItem = ({
  String name,
  Widget icon,
  PageRouteInfo route,
});

@RoutePage()
class HomeLayoutPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeLayoutPage({
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      child: this,
      create: (context) {
        final User user = Supabase.instance.client.auth.currentSession!.user;
        return CompanyController(user.id, getIt<CompanyRepository>())..fetchCompanyDetails(true);
      },
    );
  }

  static final nonModulesRoutes = <NavigationRailRouteItem>[
    (name: "Início", icon: const Icon(Icons.home), route: const HomeRoute()),
    (name: "Perfil", icon: const Icon(Icons.person), route: const HomeRoute()),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: AutoRouter(builder: (context, routeWidget) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          body: Row(
            children: [
              Builder(builder: (context) {
                final controller = context.watch<CompanyController>();
                final availableModules = controller.modules ?? [];

                final allModulesRoutes = List.of(Modules.values.map(
                  (module) => (
                    moduleId: module.id,
                    name: module.name,
                    icon: Text(module.id.toString()),
                    route: switch (module) {
                      Modules.moduleOne => controller.company != null
                          ? ModuleOneRoute(company: controller.company!)
                          : null,
                      Modules.moduleTwo => const ModuleTwoRoute(),
                      Modules.moduleThree => const ModuleThreeRoute(),
                      Modules.moduleFour => null,
                    } as PageRouteInfo?,
                  ),
                ));

                final availableModulesRoutes = allModulesRoutes
                    .where((e) => availableModules.any((m) => m.id == e.moduleId))
                    .toList();

                final topRoute = context.router.topRoute;

                int selectedIndex = nonModulesRoutes
                    .indexWhere((element) => element.route.routeName == topRoute.name);

                if (selectedIndex < 0) {
                  selectedIndex = nonModulesRoutes.length +
                      availableModulesRoutes.indexWhere((e) => e.route?.routeName == topRoute.name);
                }

                inspect(topRoute);

                return NavigationRail(
                  elevation: 2,
                  selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                  backgroundColor: theme.colorScheme.surface,
                  useIndicator: true,
                  extended: true,
                  labelType: NavigationRailLabelType.none,
                  onDestinationSelected: (value) {
                    matchAndNavigateDestination(value, allModulesRoutes, context);
                  },
                  destinations: List.of(
                    nonModulesRoutes.cast<dynamic>().followedBy(availableModulesRoutes).map(
                          (e) => NavigationRailDestination(
                            icon: e.icon,
                            label: Text(e.name),
                            disabled: e.route == null,
                          ),
                        ),
                  ),
                );
              }),
              const VerticalDivider(width: 0),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                  ),
                  child: routeWidget,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void matchAndNavigateDestination(
      int value, List<NavigationRailModuleItem> allModulesRoutes, BuildContext context) {
    late final Record item;

    if (value < nonModulesRoutes.length) {
      item = nonModulesRoutes[value];
    } else if (value < nonModulesRoutes.length + allModulesRoutes.length) {
      value -= nonModulesRoutes.length;
      item = allModulesRoutes[value];
    } else {
      throw RangeError.range(value, 0, allModulesRoutes.length + nonModulesRoutes.length);
    }

    late final PageRouteInfo? route;

    switch (item) {
      case NavigationRailModuleItem():
        route = item.route;
      case NavigationRailRouteItem():
        route = const HomeRoute();
    }

    if (route != null) {
      context.router.navigate(
        route,
        onFailure: (failure) => log(
          "Navigation failure",
          error: failure,
        ),
      );
    }
  }
}
