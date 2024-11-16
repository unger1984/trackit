import 'package:trackit/src/abstract/trackit_formatter.dart';
import 'package:trackit/src/data/log_data.dart';

class DefaultMapFormatter extends TrackitFormatter {
  const DefaultMapFormatter({super.observers});

  @override
  dynamic format(LogData data, formatted) {
    return <String, dynamic>{
      "level": data.level.toString(),
      "title": data.title,
      "time": data.time.toIso8601String(),
      "message": data.message,
      "exception": data.exception?.toString(),
      "stackTrace": data.stackTrace?.toString(),
    };
  }
}
