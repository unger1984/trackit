import 'package:meta/meta.dart';

@immutable
abstract interface class Console {
  const Console();
  void log(String message);
}
