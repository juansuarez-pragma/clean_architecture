import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/authentication_repository_Impl.dart';
import 'app/data/repositories_implementation/conectivity_repository_impl.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(Injector(
    connectivityRepository:
        ConnectivityRepositoryImpl(Connectivity(), InternetChecker()),
    authenticationRepository: AuthenticationRepositoryImpl(
        const FlutterSecureStorage(),
        AuthenticationAPI(Http(
            client: http.Client(),
            baseUrl: 'https://api.themoviedb.org/3',
            apikey: 'cd64d88080c3955355139791bda28f8c'))),
    child: const MyApp(),
  ));
}

class Injector extends InheritedWidget {
  const Injector(
      {super.key,
      required super.child,
      required this.connectivityRepository,
      required this.authenticationRepository});

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could no be found');
    return injector!;
  }
}
