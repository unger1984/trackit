/// Very simple, lightweight and modular logging system.
///
/// Trackit is a logger that is expandable with additional modules.
/// This is base logger module.
/// Used only to create a log stream from logger instances and the ability
/// to attach handlers to it
library;

import 'package:meta/meta.dart';

import 'src/instance/trackit_instance.dart';
import 'src/trackit_base.dart';

export 'src/models/log_event.dart';
export 'src/models/log_level.dart';

/// Trackit logger singleton.
@immutable
final class Trackit extends TrackitBase {
  factory Trackit() => _internalSingleton;

  Trackit._internal();
  static final Trackit _internalSingleton = Trackit._internal();

  /// Creates a new logger instance.
  /// with custom [title]
  static TrackitInstance create(String title) =>
      TrackitInstance(title, _internalSingleton);
}
