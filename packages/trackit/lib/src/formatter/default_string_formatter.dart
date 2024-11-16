import 'package:trackit/trackit.dart';

class DefaultStringFormatterSettings {
  final bool levelUppercase;
  final bool levelShorten;
  final bool showTitle;
  final String Function(DateTime)? dateFormatter;

  const DefaultStringFormatterSettings({
    this.levelUppercase = true,
    this.levelShorten = false,
    this.showTitle = true,
    this.dateFormatter,
  });
}

class DefaultStringFormatter extends TrackitFormatter {
  final DefaultStringFormatterSettings _settings;
  const DefaultStringFormatter(
      {super.observers,
      DefaultStringFormatterSettings settings =
          const DefaultStringFormatterSettings()})
      : _settings = settings;

  @override
  dynamic format(LogData data, dynamic formatted) {
    final dateFormatter = _settings.dateFormatter;
    final lines = <String>[
      '[${_level(data)}]${_settings.showTitle ? ' (${data.title})' : ''}${dateFormatter == null ? '' : ' ${dateFormatter(data.time)}'} ${data.message?.toString() ?? ''}',
    ];

    lines.addAll(
      (data.exception?.toString().split('\n') ?? [])
          .where((str) => str.trim().isNotEmpty),
    );

    lines.addAll(
      (data.stackTrace?.toString().split('\n') ?? [])
          .where((str) => str.trim().isNotEmpty),
    );

    return lines.join('\n');
  }

  String _level(LogData data) {
    String level = data.level.toString();
    if (_settings.levelShorten) level = level.substring(0, 1);
    if (_settings.levelUppercase) level = level.toUpperCase();
    return level;
  }
}
