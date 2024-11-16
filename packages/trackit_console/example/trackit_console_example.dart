import 'package:trackit_console/trackit_console.dart';

void main() {
  Trackit.getInstance().add(TrackitConsole());
  final log = Trackit.create('test');

  log.info('Hello world!');
}
