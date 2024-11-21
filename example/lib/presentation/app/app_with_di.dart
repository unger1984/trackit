import 'package:example/presentation/app/app_router.dart';
import 'package:example/presentation/app/app_theme.dart';
import 'package:example/presentation/common/web_scroll_behavior.dart';
import 'package:flutter/material.dart';

@immutable
class AppWithDi extends StatelessWidget {
  const AppWithDi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: WebScrollBehavior(),
      title: 'Trackit Demo',
      theme: AppTheme().materialTheme,
      themeMode: ThemeMode.light,
      initialRoute: Routes.main,
      routes: AppRouter.routes,
      navigatorObservers: [AppRouterObserver()],
    );
  }
}
