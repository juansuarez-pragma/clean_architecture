import 'package:flutter/material.dart';
import 'package:movietv/app/presentation/modules/splash/views/splash_view.dart';
import 'package:movietv/app/presentation/routes/routes.dart';

Map<String, Widget Function(BuildContext)> getAppRoutes() {
  return {Routes.splash: (context) => SplashView()};
}
