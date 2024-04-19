import 'package:flutter/material.dart';
import 'package:movietv/app/presentation/modules/splash/views/splash_view.dart';
import 'package:movietv/app/presentation/routes/app_routes.dart';
import 'package:movietv/app/presentation/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.splash,
      routes: getAppRoutes(),
    );
  }
}
