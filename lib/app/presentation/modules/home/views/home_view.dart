import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../routes/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await Injector.of(context).authenticationRepository.signOut();
            Navigator.pushReplacementNamed(context, Routes.signIn);
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
