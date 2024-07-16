import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../../core/routes/app_router.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Entre ou crie sua conta", style: Theme.of(context).textTheme.headlineSmall),
              Text("Bem vindo", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox.square(dimension: 8),
              SupaEmailAuth(
                // redirectTo: kIsWeb ? null : 'br.dev.julliano.modularapp://callback',
                onSignInComplete: (response) {
                  context.router.replaceAll([const HomeRoute()]);
                },
                onSignUpComplete: (response) {
                  context.router.replaceAll([const HomeRoute()]);
                },
                metadataFields: [
                  MetaDataField(
                    prefixIcon: const Icon(Icons.person),
                    label: 'Username',
                    key: 'username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter something';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
