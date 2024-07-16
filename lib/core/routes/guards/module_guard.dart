import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/models/company.dart';
import '../../../app/models/modules.dart';
import '../../../app/widgets/modules_controller.dart';
import '../../../injectable.dart';

class ModulesGuard extends AutoRouteGuard {
  const ModulesGuard({required this.module, this.company});
  final Modules module;
  final Company? company;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // assert(resolver.route.meta.containsKey("module"));

    final client = Supabase.instance.client;

    final User? user = client.auth.currentSession?.user;

    if (user == null) {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.next(false);
      return;
    }

    final companyRepository = getIt<CompanyRepository>();
    final modulesTask = company != null
        ? companyRepository.getModules(company!.id)
        : companyRepository.getModulesFromUser(user.id);

    final modules = await modulesTask.getOrElse((f) {
      log("Failed to get modules: $f", error: f.error, stackTrace: f.stackTrace);
      return [];
    }).run();

    if (modules.any((m) => m.id == module.id)) {
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.next(false);
    }
  }
}
