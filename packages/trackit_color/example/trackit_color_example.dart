import 'package:trackit_color/trackit_color.dart';

/// For print log in console.
/// Last observer in chain.
class PrintLogObserver extends TrackitObserver {
  @override
  void log(LogEvent data, dynamic formatted) {
    (formatted?.toString() ?? '').split('\n').forEach(print);
  }
}

void main() {
  final log = Trackit.create('Test');

  /// Simple coloring example
  Trackit.getInstance().add(
    DefaultStringFormatter(
      settings: DefaultStringFormatterSettings(
        dateFormatter: (date) => date.toString(),
      ),
      observers: [
        ColorFormatter(
          observers: [PrintLogObserver()],
        ),
      ],
    ),
  );
  log.info('Hello World!');
  Trackit.getInstance().clear();

  /// Coloring with cornered borders
  Trackit.getInstance().add(
    DefaultStringFormatter(
      settings: DefaultStringFormatterSettings(
        dateFormatter: (date) => date.toString(),
      ),
      observers: [
        ColorBorderedFormatter(
          observers: [PrintLogObserver()],
        ),
      ],
    ),
  );
  log.debug('Hello World!');
  Trackit.getInstance().clear();

  /// Coloring without cornered borders
  Trackit.getInstance().add(
    DefaultStringFormatter(
      settings: DefaultStringFormatterSettings(
        dateFormatter: (date) => date.toString(),
      ),
      observers: [
        ColorBorderedFormatter(
          withCorners: false,
          observers: [PrintLogObserver()],
        ),
      ],
    ),
  );
  log.warning('Hello World!');
}
