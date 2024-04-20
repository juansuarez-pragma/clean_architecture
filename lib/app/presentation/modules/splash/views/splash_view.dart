import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final injector = Injector.of(context);
    final ConnectivityRepository connectivityRepository =
        injector.connectivityRepository;
    final hasInternet = await crHasInternet(connectivityRepository);
    if (hasInternet) {
      final AuthenticationRepository authenticationRepository =
          injector.authenticationRepository;
      final isSignIn = await authenticationRepository.isSignedIn;
      if (isSignIn) {
        final user = await authenticationRepository.getUserData();
        if (mounted) {
          if (user != null) {
            _goto(Routes.home);
          } else {
            _goto(Routes.signIn);
          }
        }
      } else if (mounted) {
        _goto(Routes.signIn);
      }
    }
  }

  void _goto(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  Future<bool> crHasInternet(ConnectivityRepository connectivityRepository) {
    return connectivityRepository.hasInternet;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            SizedBox(width: 80, height: 80, child: CircularProgressIndicator()),
      ),
    );
  }
}
