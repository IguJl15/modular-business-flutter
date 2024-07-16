import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_router.dart';

@RoutePage()
class ModuleTwoPage extends StatelessWidget {
  const ModuleTwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo Dois'), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Módulo Dois'),
            TextButton(
              onPressed: () {
                context.router.push(const ModuleTwoSubRoute());
              },
              child: const Text('Navegar'),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class ModuleTwoSubPage extends StatelessWidget {
  const ModuleTwoSubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo Dois - Sub')),
      body: const Center(
        child: Text('Módulo Dois - Sub'),
      ),
    );
  }
}
