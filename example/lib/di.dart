import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:example/data/datasources/api_source_dio.dart';
import 'package:example/data/repositories/product.repository.impl.dart';
import 'package:example/domain/datasources/api_source.dart';
import 'package:example/domain/repositories/product.repository.dart';
import 'package:example/presentation/app/app_bloc_observer.dart';
import 'package:example/presentation/common/inherited_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';
import 'package:trackit_history/trackit_history.dart';

typedef _InitializationStep = FutureOr<void> Function(DI dependencies);

/// Dependencies holder.
class DI {
  DI();

  factory DI.of(BuildContext context) => InheritedDI.of(context);

  /// Inject dependencies to the widget tree.
  Widget inject({required Widget child, Key? key}) =>
      InheritedDI(dependencies: this, key: key, child: child);

  late final ApiSource apiSource;
  late final ProductRepository productRepository;
}

/// Dependencies initializer.
abstract class DILoader {
  static final _log = Trackit.create('DILoader');

  /// Initialization all dependencies.
  static Future<DI> initialize({
    void Function(int progress, String message)? onProgress,
  }) async {
    final dependencies = DI();
    final totalSteps = _initializationSteps.length;
    var currentStep = 0;
    for (final step in _initializationSteps.entries) {
      try {
        currentStep++;
        final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
        onProgress?.call(percent, step.key);
        _log.info(
            'Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
        await step.value(dependencies);
      } on Object catch (error, stackTrace) {
        _log.error(
            'Initialization failed at step "${step.key}"', error, stackTrace);
        Error.throwWithStackTrace(
            'Initialization failed at step "${step.key}": $error', stackTrace);
      }
    }
    return dependencies;
  }

  /// Map of application dependencies.
  static final Map<String, _InitializationStep> _initializationSteps =
      <String, _InitializationStep>{
    /// First of all, let's initialize the logger. This message will not be
    /// shown in the logger itself, because at the time of its logging, the
    /// logger output was not yet configured.
    'Log app initialized': _stepLog,

    'BLoC observer initialized': (_) {
      Bloc.observer = AppBlocObserver.instance();
      Bloc.transformer = bloc_concurrency.sequential<Object?>();
    },

    'API source initialized': (dependencies) {
      dependencies.apiSource = ApiSourceDio(baseUrl: 'https://dummyjson.com');
    },

    'Product repository initialized': (dependencies) {
      dependencies.productRepository =
          ProductRepositoryImpl(api: dependencies.apiSource);
    },

    /// Fake dependency.
    'Fake dependency initialized': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 2': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 3': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 4': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 5': (_) async {
      await Future.delayed(Duration(seconds: 1));
      // TODO: uncomment this line to emulate exception on initialization
      // throw Exception("Test initialized exception");
    },

    /// Fake dependency.
    'Fake dependency initialized 6': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 7': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },

    /// Fake dependency.
    'Fake dependency initialized 8': (_) async {
      await Future.delayed(Duration(seconds: 1));
    },
  };

  /// Step for logger initialization.
  static Future<void> _stepLog(di) async {
    Trackit().listen((event) {
      TrackitHistory().add(event);
      TrackitConsole(
        formatter: TrackitPatternFormater(
          pattern: '[{L}] <{D}> ({T}): {M}\n{E}\n{S}',
          stringify: _stringifyEvent,
        ),
      ).onData(event);
    });
  }

  /// String representation of [LogEvent].
  static LogEventString _stringifyEvent(LogEvent event) {
    String color() => switch (event.level) {
          LogLevelTrace() => '37m',
          LogLevelDebug() => '34m',
          LogLevelInfo() => '32m',
          LogLevelWarn() => '33m',
          LogLevelError() => '31m',
          LogLevelFatal() => '31m',
        };

    return LogEventString(
      level:
          '\x1B[${color()}${event.level.name.toUpperCase().substring(0, 1)}\x1B[0m',
      title: event.title,
      time: (event.time.millisecondsSinceEpoch ~/ 1000).toString(),
      message: event.message?.toString() ?? '',
      exception: event.exception == null
          ? null
          : (event.exception?.toString() ?? '')
              .split('\n')
              .map((line) => '\x1B[${color()}$line\x1B[0m')
              .join('\n')
              .trim(),
      stackTrace: event.stackTrace == null
          ? null
          : (event.stackTrace?.toString() ?? '')
              .split('\n')
              .map((line) => '\x1B[${color()}$line\x1B[0m')
              .join('\n')
              .trim(),
    );
  }
}
