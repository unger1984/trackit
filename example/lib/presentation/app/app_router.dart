import 'package:example/presentation/screens/main/main_screen.dart';
import 'package:example/presentation/screens/product/product_screen.dart';
import 'package:example/presentation/screens/trackit/trackit_screen.dart';
import 'package:flutter/material.dart';
import 'package:trackit/trackit.dart';

abstract class Routes {
  static const main = '/';
  static const product = '/product';
  static const trackit = '/trackit';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    Routes.main: (context) => const MainScreen(),
    Routes.product: (context) => const ProductScreen(),
    Routes.trackit: (context) => const TrackitScreen(),
  };
}

class AppRouterObserver extends NavigatorObserver {
  static final _log = Trackit.create('AppRouterObserver');
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    final args = route.settings.arguments?.toString();
    final msg =
        'Open route named ${route.settings.name ?? 'null'}${args != null ? '\nArguments: $args' : ''}';
    _log.info(msg);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    final msg = 'Close route named ${route.settings.name ?? 'null'}';
    _log.info(msg);
  }
}
