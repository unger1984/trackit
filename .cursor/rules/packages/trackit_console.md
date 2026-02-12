# TrackIt Console Package — Правила разработки

## О пакете

`trackit_console` — модуль-расширение для форматирования и вывода логов в консоль. Подписывается на поток событий из базового `trackit` и обрабатывает их через настраиваемые форматтеры.

## Архитектурные паттерны

### Event Handler Pattern

Главный класс подписывается на события и обрабатывает их:

```dart
@immutable
class TrackitConsole {
  const TrackitConsole({
    Console? console,
    TrackitFormatter<String>? formatter,
  })  : _console = console ?? const Console(),
        _formatter = formatter ?? const TrackitSimpleFormatter();

  final Console _console;
  final TrackitFormatter<String> _formatter;

  void onData(LogEvent event) {
    final message = _formatter.format(event);
    _console.log(message);
  }
}
```

**Правила:**
- Метод `onData(LogEvent event)` — точка входа для обработки событий
- Форматтер и консоль инжектируются через конструктор с defaults
- Класс immutable с const конструктором

### Strategy Pattern (Форматтеры)

Форматтеры реализуют общий интерфейс:

```dart
abstract interface class TrackitFormatter<T> {
  const TrackitFormatter();
  
  T format(LogEvent event);
}
```

**Правила:**
- Generic интерфейс `TrackitFormatter<T>` где T — тип результата
- Единственный метод `format(LogEvent event)`
- Для String-форматтеров использовать `TrackitFormatter<String>`
- Для JSON-форматтеров использовать `TrackitFormatter<Map<String, dynamic>>`

### Platform-Specific Implementation

Использовать conditional imports для platform-specific кода:

```dart
// console.dart (интерфейс)
abstract interface class Console {
  const Console();
  void log(String message);
}

// console_io.dart (для dart:io)
import 'dart:io';
import 'console.dart';

class ConsoleImpl implements Console {
  const ConsoleImpl();
  
  @override
  void log(String message) {
    stdout.writeln(message);
  }
}

// console_web.dart (для dart:html)
import 'dart:html';
import 'console.dart';

class ConsoleImpl implements Console {
  const ConsoleImpl();
  
  @override
  void log(String message) {
    window.console.log(message);
  }
}

// console_stub.dart (fallback)
import 'console.dart';

class ConsoleImpl implements Console {
  const ConsoleImpl();
  
  @override
  void log(String message) {
    print(message);
  }
}
```

**В файле экспорта:**
```dart
export 'console.dart';
export 'console_stub.dart'
    if (dart.library.io) 'console_io.dart'
    if (dart.library.html) 'console_web.dart';
```

**Правила:**
- Всегда создавать интерфейс в отдельном файле
- Создавать stub-реализацию для неизвестных платформ
- Использовать `if (dart.library.*)` для conditional imports
- Все реализации должны иметь одинаковое имя класса (`ConsoleImpl`)

## Форматтеры

### TrackitSimpleFormatter

Простой текстовый форматтер (по умолчанию):

```dart
class TrackitSimpleFormatter implements TrackitFormatter<String> {
  const TrackitSimpleFormatter();

  @override
  String format(LogEvent event) {
    final buffer = StringBuffer();
    
    buffer.write('[${_levelToString(event.level)}] ');
    buffer.write('${event.time ?? DateTime.now()} ');
    buffer.write('{${event.title}} ');
    buffer.write(event.message);
    
    if (event.exception != null) {
      buffer.write('\n${event.exception}');
    }
    
    if (event.stackTrace != null) {
      buffer.write('\n${event.stackTrace}');
    }
    
    return buffer.toString();
  }
}
```

**Формат вывода:**
```
[info] 2024-11-20T10:47:40.299363 {LogInstanceTitle} Log info message
```

**Правила:**
- Использовать `StringBuffer` для построения строки
- Порядок: уровень → время → title → сообщение → exception → stackTrace
- Exception и stackTrace на новых строках

### TrackitJsonFormatter

JSON форматтер:

```dart
class TrackitJsonFormatter implements TrackitFormatter<Map<String, dynamic>> {
  const TrackitJsonFormatter();

  @override
  Map<String, dynamic> format(LogEvent event) {
    return {
      'level': _levelToString(event.level),
      'time': (event.time ?? DateTime.now()).toIso8601String(),
      'title': event.title,
      'message': event.message,
      if (event.exception != null) 'exception': event.exception.toString(),
      if (event.stackTrace != null) 'stackTrace': event.stackTrace.toString(),
    };
  }
}
```

**Правила:**
- Возвращать `Map<String, dynamic>`
- Использовать ISO 8601 для дат
- Опциональные поля только если не null (collection if)
- Конвертировать exception и stackTrace в строки

### TrackitPatternFormatter

Шаблонный форматтер с плейсхолдерами:

```dart
class TrackitPatternFormater implements TrackitFormatter<String> {
  const TrackitPatternFormater({
    this.pattern = '[{L}] {D} ({T}): {M}\n{E}\n{S}',
    this.stringify,
    this.post,
  });

  final String pattern;
  final LogEventToStringify? stringify;
  final PostStringify? post;

  @override
  String format(LogEvent event) {
    final strings = LogEventString.from(
      event: event,
      stringify: stringify,
    );
    
    var result = pattern
        .replaceAll('{L}', strings.level)
        .replaceAll('{T}', strings.title)
        .replaceAll('{D}', strings.time)
        .replaceAll('{M}', strings.message)
        .replaceAll('{E}', strings.exception)
        .replaceAll('{S}', strings.stackTrace);
    
    if (post != null) {
      result = post!(result);
    }
    
    return result;
  }
}
```

**Плейсхолдеры:**
- `{L}` — level (уровень логирования)
- `{T}` — title (заголовок логгера)
- `{D}` — date/time (дата и время)
- `{M}` — message (сообщение)
- `{E}` — exception (исключение)
- `{S}` — stackTrace (stack trace)

**Правила:**
- Шаблон по умолчанию: `'[{L}] {D} ({T}): {M}\n{E}\n{S}'`
- Использовать `replaceAll()` для замены плейсхолдеров
- `stringify` — кастомизация преобразования полей в строки
- `post` — пост-обработка результата (например, добавление цветов)

### Кастомизация stringify

```dart
typedef LogEventToStringify = String? Function({
  required String key,
  required LogEvent event,
  String? defaultValue,
});

// Пример: добавление цветов через ANSI escape codes
String? colorStringify({
  required String key,
  required LogEvent event,
  String? defaultValue,
}) {
  if (key == 'level') {
    final level = event.level;
    if (level is LogLevelError) return '\x1B[31merror\x1B[0m'; // Красный
    if (level is LogLevelWarn) return '\x1B[33mwarn\x1B[0m'; // Желтый
    if (level is LogLevelInfo) return '\x1B[32minfo\x1B[0m'; // Зеленый
  }
  return defaultValue;
}

final formatter = TrackitPatternFormater(
  stringify: colorStringify,
);
```

**Правила:**
- Возвращать `null` для использования default значения
- Ключи: `'level'`, `'title'`, `'time'`, `'message'`, `'exception'`, `'stackTrace'`
- Не изменять логику форматирования, только строковое представление

### Кастомизация post

```dart
typedef PostStringify = String Function(String str);

// Пример: обрамление в рамку
String boxPost(String str) {
  final lines = str.split('\n');
  final maxLength = lines.map((l) => l.length).reduce(max);
  final border = '═' * (maxLength + 2);
  
  return '╔$border╗\n'
      '${lines.map((l) => '║ ${l.padRight(maxLength)} ║').join('\n')}\n'
      '╚$border╝';
}

final formatter = TrackitPatternFormater(
  post: boxPost,
);
```

**Правила:**
- Применяется после замены всех плейсхолдеров
- Используется для визуального форматирования (рамки, отступы, цвета)
- Не должна изменять семантику сообщения

## Структура файлов

```
lib/
├── trackit_console.dart          # Публичный API
└── src/
    ├── formatter/
    │   ├── trackit_formatter.dart
    │   ├── trackit_simple_formatter.dart
    │   ├── trackit_json_formatter.dart
    │   └── trackit_pattern_formater.dart
    ├── platform_specific/
    │   ├── console.dart          # Интерфейс
    │   ├── console_io.dart       # dart:io реализация
    │   ├── console_web.dart      # dart:html реализация
    │   └── console_stub.dart     # fallback
    └── stringify/
        └── log_event_string.dart # Вспомогательные типы
```

**Правила:**
- `formatter/` — все форматтеры
- `platform_specific/` — platform-dependent код
- `stringify/` — вспомогательные классы для string преобразований

## Использование

### Базовое использование

```dart
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

void main() {
  // Подключение обработчика консоли
  Trackit().listen(TrackitConsole().onData);
  
  // Создание логгера
  final log = Trackit.create('MyApp');
  
  // Логирование
  log.info('Application started');
}
```

### С кастомным форматтером

```dart
// JSON форматтер
final jsonConsole = TrackitConsole(
  formatter: const TrackitJsonFormatter(),
);
Trackit().listen(jsonConsole.onData);

// Pattern форматтер
final patternConsole = TrackitConsole(
  formatter: const TrackitPatternFormater(
    pattern: '{T} | {L} | {M}',
  ),
);
Trackit().listen(patternConsole.onData);
```

### Множественные обработчики

```dart
// Один в консоль с простым форматом
Trackit().listen(TrackitConsole().onData);

// Второй в файл с JSON форматом
final fileConsole = TrackitConsole(
  console: FileConsole('log.json'),
  formatter: const TrackitJsonFormatter(),
);
Trackit().listen(fileConsole.onData);
```

## Создание кастомного форматтера

```dart
class MyCustomFormatter implements TrackitFormatter<String> {
  const MyCustomFormatter();

  @override
  String format(LogEvent event) {
    // Кастомная логика форматирования
    return 'CUSTOM: ${event.message}';
  }
}

// Использование
final console = TrackitConsole(
  formatter: const MyCustomFormatter(),
);
```

**Правила:**
- Реализовать `TrackitFormatter<T>`
- Определить тип возвращаемого значения (String, Map, etc)
- Const конструктор если возможно
- Обрабатывать все поля `LogEvent` (level, title, time, message, exception, stackTrace)

## Создание кастомной консоли

```dart
class FileConsole implements Console {
  const FileConsole(this.filePath);
  
  final String filePath;

  @override
  void log(String message) {
    final file = File(filePath);
    file.writeAsStringSync(
      '$message\n',
      mode: FileMode.append,
    );
  }
}

// Использование
final console = TrackitConsole(
  console: const FileConsole('app.log'),
);
```

**Правила:**
- Реализовать `Console` интерфейс
- Метод `log(String message)` должен быть синхронным
- Для асинхронных операций использовать `Future.microtask()` внутри

## Зависимости

```yaml
dependencies:
  trackit: ^0.1.0  # Базовый пакет
  meta: ^1.15.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.8
```

**Правила:**
- Зависимость от базового `trackit`
- Никаких других runtime зависимостей
- Для platform-specific кода использовать только стандартную библиотеку Dart

## Тестирование

### Что тестировать

- Форматирование всех уровней логирования
- Обработка null полей (exception, stackTrace)
- Замена плейсхолдеров в pattern форматтере
- Работа stringify и post функций
- Platform-specific код через mocks

### Пример теста

```dart
import 'package:test/test.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_console/trackit_console.dart';

void main() {
  group('TrackitSimpleFormatter', () {
    test('should format log event', () {
      const formatter = TrackitSimpleFormatter();
      final event = LogEvent(
        level: const LogLevel.info(),
        title: 'Test',
        message: 'Test message',
        time: DateTime(2024, 1, 1),
      );
      
      final result = formatter.format(event);
      
      expect(result, contains('[info]'));
      expect(result, contains('Test'));
      expect(result, contains('Test message'));
    });

    test('should include exception if present', () {
      const formatter = TrackitSimpleFormatter();
      final event = LogEvent(
        level: const LogLevel.error(),
        title: 'Test',
        message: 'Error occurred',
        exception: Exception('Test error'),
      );
      
      final result = formatter.format(event);
      
      expect(result, contains('Exception: Test error'));
    });
  });
}
```

## Best Practices

1. **Один console handler в main()**: Инициализировать `TrackitConsole` в точке входа приложения
2. **Разные форматтеры для разных целей**: Simple для разработки, JSON для production, Pattern для кастомизации
3. **Не блокировать в log()**: Console.log должен быть быстрым, для тяжелых операций использовать асинхронность
4. **Использовать StringBuffer**: Для построения сложных строк использовать StringBuffer, не конкатенацию
5. **ANSI коды только для терминалов**: Проверять поддержку цветов перед использованием ANSI escape codes

## Антипаттерны

❌ **Множественные подписки TrackitConsole с одинаковым форматтером**
```dart
// Плохо - дублирование вывода
Trackit().listen(TrackitConsole().onData);
Trackit().listen(TrackitConsole().onData); // Дубликат!
```

✅ **Одна подписка на консоль**
```dart
// Хорошо
final console = TrackitConsole();
Trackit().listen(console.onData);
```

❌ **Сложная логика в stringify**
```dart
// Плохо - бизнес-логика в форматтере
String? badStringify({required String key, required LogEvent event, String? defaultValue}) {
  if (key == 'message') {
    // Сложная обработка, запросы к БД и т.д.
    final processed = await database.process(event.message); // Async!
    return processed;
  }
  return defaultValue;
}
```

✅ **Простое преобразование строк**
```dart
// Хорошо - только string преобразования
String? goodStringify({required String key, required LogEvent event, String? defaultValue}) {
  if (key == 'level') {
    return event.level.toString().toUpperCase();
  }
  return defaultValue;
}
```

❌ **Блокирующий I/O в Console.log**
```dart
// Плохо - синхронный I/O блокирует поток
class BadConsole implements Console {
  void log(String message) {
    final file = File('log.txt');
    file.writeAsStringSync(message); // Блокирует!
  }
}
```

✅ **Асинхронная запись**
```dart
// Хорошо - не блокирует основной поток
class GoodConsole implements Console {
  void log(String message) {
    Future.microtask(() async {
      final file = File('log.txt');
      await file.writeAsString(message, mode: FileMode.append);
    });
  }
}
```

## Platform-Specific Best Practices

### Для Web (dart:html)

- Использовать `window.console.log()` для обычных сообщений
- Использовать `window.console.error()` для ошибок
- Использовать `window.console.warn()` для предупреждений
- Группировка через `window.console.group()`

### Для Native (dart:io)

- `stdout.writeln()` для обычных сообщений
- `stderr.writeln()` для ошибок
- Использовать ANSI коды для цветов в терминалах
- Проверять `stdout.supportsAnsiEscapes` перед добавлением цветов

### Fallback (print)

- Использовать только если платформа неизвестна
- Простой текстовый вывод без форматирования
- Подходит для embedded систем и неизвестных платформ
