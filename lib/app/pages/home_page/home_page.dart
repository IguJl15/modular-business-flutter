import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/formatters.dart';
import '../../widgets/modules_controller.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _onFetchModulesButtonPressed(BuildContext context) {
    return context.read<CompanyController>().fetchModules();
  }

  Future<void> _onFetchCompanyDetailsButtonPressed(BuildContext context) {
    return context.read<CompanyController>().fetchCompanyDetails(true);
  }

  @pragma('vm:platform-const-if', !kDebugMode)
  static get isMobile => !(kIsWeb ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            if (!isMobile)
              IconButton(
                onPressed: () => _onFetchCompanyDetailsButtonPressed(context),
                icon: const Icon(Icons.refresh),
              ),
            IconButton(
              onPressed: () => Supabase.instance.client.auth.signOut(),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        // drawer: AppDrawer(user: user),
        body: RefreshIndicator.adaptive(
          onRefresh: () async => _onFetchCompanyDetailsButtonPressed(context),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const Text("Detalhes da empresa"),
              const CompanyDetails(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Módulos Disponíveis"),
                  TextButton(
                    onPressed: () => _onFetchModulesButtonPressed(context),
                    child: const Text("Buscar Módulos"),
                  ),
                ],
              ),
              const ModulesInformation()
            ],
          ),
        ),
      ),
    );
  }
}

class ModulesInformation extends StatelessWidget {
  const ModulesInformation({super.key});

  static final _currencyFormatter = Formatters.currencyFormatter(decimalDigits: 2, locale: "pt_BR");

  @override
  Widget build(BuildContext context) {
    final modulesController = context.watch<CompanyController>();
    final modules = modulesController.modules ?? [];

    if (modules.isEmpty) {
      return const Text(
        "Não há módulos disponíveis",
        style: TextStyle(color: Colors.grey),
      );
    }

    return ListBody(
      children: List.of(
        modules
            .map<Widget>((e) => ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(e.name),
                  trailing: Text(_currencyFormatter.format(e.chargedPrice)),
                  onTap: () {},
                ))
            .followedBy(
          [
            const Divider(height: 0),
            ListTile(
              title: const Text("Total"),
              leadingAndTrailingTextStyle: const TextStyle(fontSize: 14),
              trailing: Text(
                _currencyFormatter.format(
                  modules.fold(0.0, (acc, e) => acc + (e.chargedPrice)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyDetails extends StatefulWidget {
  const CompanyDetails({super.key});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _updated = false;
  TextEditingController _idController = TextEditingController(text: "");
  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _createdAtController = TextEditingController(text: "");
  late final CompanyController _companyController;

  @override
  void initState() {
    super.initState();

    _companyController = context.read<CompanyController>();
    _companyController.addListener(_updateControllers);
  }

  /// Create new controllers instead of reusing the same ones to reset TextField's [TextFormField.initialValue].
  /// If we only update the controllers, the form would reset to wrong values when cancel button is pressed.
  void _updateControllers() {
    setState(() {
      final company = _companyController.company;
      _idController = TextEditingController(text: (company?.id ?? "").toString());
      _nameController = TextEditingController(text: company?.name ?? "");

      final createdAt = company?.createdAt != null ? DateTime.tryParse(company!.createdAt) : null;
      _createdAtController = TextEditingController(
        text: createdAt != null ? Formatters.formatDate(createdAt) : "Não informado",
      );
    });
    log("Updated form controllers");
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _createdAtController.dispose();

    _companyController.removeListener(_updateControllers);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updated ? () => setState(() => _updated = false) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            readOnly: true,
            controller: _idController,
            decoration: const InputDecoration(labelText: "ID da empresa"),
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Nome da empresa"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "O nome da empresa é obrigatório";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _createdAtController,
            readOnly: true,
            decoration: const InputDecoration(labelText: "Data de criação"),
          ),
          const SizedBox.square(dimension: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _updated
                    ? const Text(
                        "Informações atualizadas com sucesso!",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.green),
                      )
                    : const SizedBox(),
              ),
              FilledButton.tonal(onPressed: _onCancelButtonPressed, child: const Text("Cancelar")),
              FilledButton(
                onPressed: () => _onUpdateButtonPressed(context),
                child: const Text("Atualizar"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onCancelButtonPressed() {
    setState(() {
      _updated = false;
      _formKey.currentState?.reset();
    });
  }

  void _onUpdateButtonPressed(BuildContext context) {
    final companyController = context.read<CompanyController>();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      log("FORM SAVED");

      if (companyController.company != null) {
        companyController
            .updateCompanyDetails(
          companyController.company!.copyWith(name: _nameController.text),
        )
            .then(
          (finishedSuccessfully) {
            if (finishedSuccessfully) {
              setState(() {
                _updated = true;
              });
            }
          },
        );
      }
    }
  }
}
