/// Available Log Levels
enum LogLevel {
  /// Errors
  error('error'),
  fatal('fatal'),

  /// Messages
  info('info'),
  debug('debug'),
  verbose('verbose'),
  warning('warning');

  final String _level;
  const LogLevel(this._level);

  @override
  String toString() => _level;
}

/// List of Log Levels in priority order
final logLevelPriorityList = [
  LogLevel.fatal,
  LogLevel.error,
  LogLevel.warning,
  LogLevel.info,
  LogLevel.debug,
  LogLevel.verbose,
];
