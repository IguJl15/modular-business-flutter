import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart' show LazySingleton;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../failures/model_failures.dart';
import '../models/company.dart';
import '../models/company_modules.dart';
import '../models/module.dart';

class CompanyController extends ChangeNotifier {
  final CompanyRepository _companyRepository;
  final String userId;

  CompanyController(this.userId, this._companyRepository);

  Company? company;
  List<Module>? modules;
  String? error;

  Future<bool> fetchModules() async {
    if (company == null) {
      return false;
    }
    return await _companyRepository.getModules(company!.id).match(
      (failure) {
        error = failure.toErrorMessage();
        log("", error: failure.error, stackTrace: failure.stackTrace);
        notifyListeners();

        return false;
      },
      (success) {
        log("Modules fetched");
        inspect(success);

        modules = success;
        notifyListeners();

        return true;
      },
    ).run();
  }

  Future<bool> fetchCompanyDetails([bool fetchModulesAutomatically = false]) async {
    if (company == null) {
      return fetchCompanyDetailsFromUserInformation(fetchModulesAutomatically);
    }

    return await _companyRepository
        .getCompanyDetails(company!.id) //
        .match(
      (failure) {
        error = failure.toErrorMessage();
        log("", error: failure.error, stackTrace: failure.stackTrace);
        notifyListeners();

        return false;
      },
      (success) {
        log("Company details fetched");
        inspect(success);

        company = success;
        notifyListeners();

        if (fetchModulesAutomatically) fetchModules();

        return true;
      },
    ).run();
  }

  Future<bool> updateCompanyDetails(Company company) async {
    return await _companyRepository
        .updateCompanyDetails(company)
        .flatMap((company) => _companyRepository.getCompanyDetails(company.id))
        .match(
      (failure) {
        error = failure.toErrorMessage();
        log("", error: failure.error, stackTrace: failure.stackTrace);

        notifyListeners();

        return false;
      },
      (success) {
        log("Company updated");
        inspect(success);

        this.company = success;
        notifyListeners();

        return true;
      },
    ).run();
  }

  Future<bool> fetchCompanyDetailsFromUserInformation(
      [bool fetchModulesAutomatically = false]) async {
    return await _companyRepository.getCompanyDetailsFromUser(userId).match(
      (failure) {
        error = failure.toErrorMessage();
        log("", error: failure.error, stackTrace: failure.stackTrace);

        notifyListeners();

        return false;
      },
      (success) {
        log("Company details fetched from user");
        inspect(success);

        company = success;
        notifyListeners();

        if (fetchModulesAutomatically) fetchModules();

        return true;
      },
    ).run();
  }
}

typedef CompanyFailure = ModelFailure<Company>;

abstract class CompanyRepository {
  TaskEither<CompanyFailure, Company> updateCompanyDetails(Company company);
  TaskEither<CompanyFailure, Company> getCompanyDetailsFromUser(String userId);
  TaskEither<CompanyFailure, Company> getCompanyDetails(int companyId);
  TaskEither<ModelFailure, List<Module>> getModules(int companyId);

  /// Assumes that the user have a unique company associated with it.
  TaskEither<ModelFailure, List<Module>> getModulesFromUser(String userId);
}

@LazySingleton(as: CompanyRepository)
class CompanyRepositoryImpl implements CompanyRepository {
  final SupabaseClient _supabaseClient;

  CompanyRepositoryImpl(Supabase supabase) : _supabaseClient = supabase.client;

  @override
  TaskEither<CompanyFailure, Company> getCompanyDetailsFromUser(String userId) {
    return TaskEither.tryCatch(
      () async {
        final result = await _supabaseClient
            .from(Company.modelName)
            .select()
            .eq('owner_id', userId)
            .limit(1)
            .single();
        inspect(result);
        return Company.fromJson(result);
      },
      RequestGetModelFailure<Company>.new,
    );
  }

  @override
  TaskEither<CompanyFailure, Company> getCompanyDetails(int companyId) {
    return TaskEither.tryCatch(
      () async {
        final result =
            await _supabaseClient.from(Company.modelName).select('*').eq('id', companyId).single();
        return Company.fromJson(result);
      },
      RequestGetModelFailure<Company>.new,
    );
  }

  @override
  TaskEither<CompanyFailure, Company> updateCompanyDetails(Company company) {
    return TaskEither.tryCatch(
      () async {
        inspect(company);
        final result = await _supabaseClient
            .from(Company.modelName)
            .update(company.toJson())
            .eq('id', company.id)
            .select()
            .single();
        return Company.fromJson(result);
      },
      RequestUpdateModelFailure<Company>.new,
    );
  }

  @override
  TaskEither<ModelFailure, List<Module>> getModules(int companyId) {
    return TaskEither<ModelFailure, List<Map<String, dynamic>>>.tryCatch(
      () async {
        return await _supabaseClient //
            .from(CompanyModules.modelName)
            .select(
          '''
            company_id,
            price_charged,
            module:module_id(*)
          ''',
        ).eq('company_id', companyId);
      },
      RequestGetModelFailure<CompanyModules>.new,
    ).flatMap(mapToModule);
  }

  @override
  TaskEither<ModelFailure, List<Module>> getModulesFromUser(String userId) {
    return TaskEither<ModelFailure, List<Map<String, dynamic>>>.tryCatch(
      () {
        return _supabaseClient.from(CompanyModules.modelName).select(
          '''
            *,
            module:module_id(*),
            company:company_id(*)
          ''',
        ).eq('company.owner_id', userId);
      },
      RequestGetModelFailure<CompanyModules>.new,
    ).flatMap(mapToModule);
  }

  TaskEither<RequestGetModelFailure<Module>, List<Module>> mapToModule(
          List<Map<String, dynamic>> companyModules) =>
      TaskEither.tryCatch(
        () async {
          final modules = List.of(companyModules.map(
            (e) {
              return Module(
                id: e["module"]["id"],
                name: e["module"]["name"],
                description: e["module"]["description"],
                chargedPrice: (e["price_charged"] as num).toDouble(),
              );
            },
          ));

          return modules;
        },
        RequestGetModelFailure<Module>.new,
      );
}
