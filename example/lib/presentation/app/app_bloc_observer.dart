import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/trackit.dart';

class AppBlocObserver extends BlocObserver {
  static final _log = Trackit.create('BlocObserver');
  static AppBlocObserver? _instance;

  factory AppBlocObserver.instance() => _instance ??= const AppBlocObserver._();
  const AppBlocObserver._();

  @override
  // Тут нужно.
  // ignore: avoid-dynamic
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log.error('Unhandled bloc exception', error, stackTrace);
  }
}
