import 'dart:async';

import 'package:trackit/trackit.dart';

/// For print log in console.
/// Last observer in chain.
class PrintLogObserver extends TrackitObserver {
  @override
  void log(LogData data, dynamic formatted) {
    (formatted?.toString() ?? '').split('\n').forEach(print);
  }
}

/// Example log filter.
class ExampleFilter extends TrackitFilter {
  const ExampleFilter({super.observers});

  @override
  bool deny(LogData data) =>
      data.message?.toString() == 'This message will not be logged';
}

void main() {
  /// Create logger chain.
  Trackit.getInstance().add(
    /// Add filter
    ExampleFilter(
      observers: [
        /// Add formatters
        DefaultStringFormatter(
          settings: DefaultStringFormatterSettings(
            levelUppercase: true,
            dateFormatter: (date) => date.toIso8601String(),
          ),

          /// Add output
          observers: [PrintLogObserver()],
        )
      ],
    ),
  );

  /// Create logger instances
  final logMain = Trackit.create('MAIN');
  final logSecond = Trackit.create('SECOND');

  /// Test log info message
  logMain.info('Hello world!');

  /// Test handle exception
  try {
    throw Exception('Test exception');
  } catch (error, stack) {
    logMain.error('Error with Exception and StackTrace',
        exception: error, stackTrace: stack);
  }

  /// Test log debug with other instance
  logSecond.debug('Debug message');

  /// Test log verbose with Map
  logSecond.verbose({"text": "Log Map test"});

  /// Test filter
  logSecond.info('This message will not be logged');

  /// Test uncaught exception as fatal error
  runZonedGuarded(
    () {
      throw Exception('Fatal exception');
    },
    (error, stackTrace) {
      logMain.fatal('FATAL ERROR', exception: error, stackTrace: stackTrace);
    },
  );
  Trackit.getInstance().clear();

  Trackit.getInstance().add(
    /// Add filter
    ExampleFilter(
      observers: [
        /// Add formatters
        DefaultMapFormatter(
          /// Add output
          observers: [PrintLogObserver()],
        ),
      ],
    ),
  );

  /// Test log json
  try {
    throw Exception('Json Exception Example');
  } catch (exception, stackTrace) {
    logSecond.error(
      'Debug message',
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}
