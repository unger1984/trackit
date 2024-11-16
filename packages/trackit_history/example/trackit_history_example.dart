import 'package:trackit_history/trackit_history.dart';

void main() {
  final log = Trackit.create('Test');
  Trackit.getInstance().add(TrackitHistory());

  log.info('This is a first message');
  log.debug('This is a debug message');

  final history = Trackit.getInstance().firstWhereType<TrackitHistory>();

  history?.list.map((item) => item.message ?? '').forEach(print);
}
