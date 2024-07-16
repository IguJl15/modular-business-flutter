import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/company.dart';
import '../../widgets/modules_controller.dart';

@RoutePage()
class ModuleOnePage extends StatelessWidget implements AutoRouteWrapper {
  ModuleOnePage({this.company, super.key});

  Company? company;

  @override
  Widget wrappedRoute(BuildContext context) {
    company = context.read<CompanyController>().company;
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Módulo Um - ${company?.name}'), automaticallyImplyLeading: false),
      body: const Center(child: Text('Módulo Um')),
    );
  }
}
