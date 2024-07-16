import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ModuleThreePage extends StatelessWidget {
  const ModuleThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo Três')),
      body: const Center(child: Text('Módulo Três')),
    );
  }
}
