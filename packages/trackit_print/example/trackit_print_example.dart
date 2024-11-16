import 'package:trackit_print/trackit_print.dart';

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
          observers: [TrackitConsole()],
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
          observers: [TrackitConsole()],
        ),
      ],
    ),
  );
  log.info('Hello World!');
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
          observers: [TrackitConsole()],
        ),
      ],
    ),
  );
  log.info('Hello World!');
}
