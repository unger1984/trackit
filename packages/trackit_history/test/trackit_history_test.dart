import 'package:test/test.dart';
import 'package:trackit_history/trackit_history.dart';

void main() {
  group('Test TrackitHistory', () {
    tearDown(() {
      Trackit.getInstance().clear();
    });

    test('should TrackitHistory work', () {
      final log = Trackit.create('test1');
      Trackit.getInstance().add(TrackitHistory());
      log.info('First message');
      log.info('Second message');
      final found = Trackit.getInstance().firstWhereType<TrackitHistory>();
      expect(found?.list.first.message, 'First message');
      expect(found?.list.last.message, 'Second message');
    });
  });
}
