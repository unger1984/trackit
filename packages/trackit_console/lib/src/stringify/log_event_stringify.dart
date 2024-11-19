import 'package:trackit/trackit.dart';
import 'package:trackit_console/src/stringify/log_event_string.dart';

/// Shorthand for the function to convert an [LogEvent] to [LogEventString]
typedef LogEventToStringify = LogEventString Function(LogEvent event);

/// Short for post processing function
typedef PostStringify = String Function(LogEvent event, String value);
