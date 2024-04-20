import 'package:flutter/material.dart';

import 'app/data/repositories_implementation/authentication_repository_Impl.dart';
import 'app/data/repositories_implementation/conectivity_repository_impl.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(Injector(
    connectivityRepository: ConnectivityRepositoryImpl(),
    authenticationRepository: AuthenticationRepositoryImpl(),
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
