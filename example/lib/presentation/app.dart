import 'package:example/di.dart';
import 'package:example/presentation/app/app_theme.dart';
import 'package:example/presentation/app/app_with_di.dart';
import 'package:example/presentation/app/app_wrapper/app_wrapper.dart';
import 'package:example/presentation/screens/loading/loading_error_screen.dart';
import 'package:example/presentation/screens/loading/loading_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _progress = 0;
  String _message = '';
  Future<DI>? _future;

  @override
  void initState() {
    super.initState();
    _future = DILoader.initialize(onProgress: _handleProgress);
  }

  void _handleProgress(int num, String val) {
    setState(() {
      _progress = num;
      _message = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Trackit Demo',
      textStyle: const TextStyle(),
      color: AppTheme.accent,
      home: AppWrapper(
        child: FutureBuilder<DI>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return LoadingErrorScreen(
                message: snapshot.error?.toString() ??
                    'Unknown DI initialization error',
              );
            }
            return switch (snapshot.connectionState) {
              ConnectionState.done => Center(
                  child: snapshot.data?.inject(
                        child: AppWithDi(),
                      ) ??
                      LoadingErrorScreen(
                        message:
                            snapshot.error?.toString() ?? 'IMPOSSIBLE DI ERROR',
                      ),
                ),
              _ => LoadingScreen(progress: _progress, message: _message),
            };
          },
        ),
      ),
      pageRouteBuilder: _pageRouteBuilder,
    );
  }

  PageRoute<T> _pageRouteBuilder<T>(
          RouteSettings settings, WidgetBuilder builder) =>
      PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (_, Animation<double> animation,
            Animation<double> second, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(second),
              child: child,
            ),
          );
        },
      );
}
