import 'package:trackit/trackit.dart';

void main() {
  /// Subscription to logger events
  Trackit().listen((event) {
    /// Logger event processing
    /// In the real world, it is more logical to use formatters
    /// and output implemented in other Trackit modules
    /// or their own implementations
    print(event.message?.toString());
  });

  /// Creating a unique logger instance
  final log = Trackit.create('MAIN');

  /// Logger event generation
  log.info('Hello World');
  log.debug('Debug message');
  try {
    throw Exception('Test Error exception message');
  } catch (exception, stackTrace) {
    log.error('catch error exception', exception, stackTrace);
  }
  try {
    throw Exception('Test Fatal exception message');
  } catch (exception, stackTrace) {
    log.fatal('catch fatal exception', exception, stackTrace);
  }
}
