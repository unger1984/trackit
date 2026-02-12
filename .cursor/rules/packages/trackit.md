# TrackIt Core Package — Правила разработки

## О пакете

`trackit` — базовое ядро системы логирования. Предоставляет минималистичный API для создания логгеров и генерации событий. Пакет не содержит логики вывода или хранения логов — это делается через расширения.

## Архитектурные паттерны

### Singleton Pattern

Класс `Trackit` реализован как singleton через factory constructor:

```dart
class Trackit extends TrackitBase {
  factory Trackit() => _internalSingleton;
  
  Trackit._internal() : super();
  
  static final Trackit _internalSingleton = Trackit._internal();
}
```

**Правила:**
- Использовать `factory` конструктор для доступа к единственному экземпляру
- Приватный именованный конструктор `_internal()`
- Статическое поле `_internalSingleton` для хранения экземпляра
- Инициализация при первом обращении (lazy singleton не требуется)

### Stream-based Architecture

`TrackitBase` расширяет `Stream<LogEvent>` и использует broadcast stream:

```dart
abstract class TrackitBase extends Stream<LogEvent> {
  TrackitBase() : super();

  final StreamController<LogEvent> _controller =
      StreamController<LogEvent>.broadcast();

  @override
  StreamSubscription<LogEvent> listen(
    void Function(LogEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
      
  @protected
  @visibleForOverriding
  void handleEvent(LogEvent event) {
    _controller.add(event);
  }
}
```

**Правила:**
- Всегда использовать `StreamController.broadcast()` для поддержки множественных подписчиков
- Класс расширяет `Stream<LogEvent>` для прямого доступа к потоку
- Метод `handleEvent()` помечен как `@protected` и `@visibleForOverriding`
- Не закрывать stream controller — singleton живет весь lifecycle приложения

### Factory Methods

Использовать статические factory методы для создания экземпляров:

```dart
static TrackitInstance create(String title) => TrackitInstance(
  title: title,
  base: _internalSingleton,
);
```

**Правила:**
- Фабричные методы должны быть статическими
- Инкапсулировать создание зависимостей внутри метода
- Возвращать интерфейс, а не конкретную реализацию (где применимо)

## Структура классов

### Trackit (Singleton Facade)

Главный фасад системы логирования:

```dart
class Trackit extends TrackitBase {
  factory Trackit() => _internalSingleton;
  
  Trackit._internal() : super();
  
  static final Trackit _internalSingleton = Trackit._internal();
  
  static TrackitInstance create(String title) => TrackitInstance(
    title: title,
    base: _internalSingleton,
  );
}
```

**Ответственность:**
- Предоставление доступа к глобальному stream событий
- Создание экземпляров логгеров через `create()`
- Управление broadcast stream

### TrackitBase (Abstract Base)

Базовый класс с логикой stream:

```dart
abstract class TrackitBase extends Stream<LogEvent> {
  final StreamController<LogEvent> _controller =
      StreamController<LogEvent>.broadcast();
      
  @protected
  @visibleForOverriding
  void handleEvent(LogEvent event) {
    _controller.add(event);
  }
  
  @protected
  @nonVirtual
  void notifyListeners(LogEvent event) {
    handleEvent(event);
  }
}
```

**Правила:**
- Класс должен быть абстрактным
- `handleEvent()` — точка расширения для подклассов (может быть переопределен)
- `notifyListeners()` — final метод для добавления событий (не переопределяется)
- Использовать аннотации `@protected`, `@visibleForOverriding`, `@nonVirtual`

### TrackitInstance (Logger Instance)

Экземпляр логгера с методами логирования:

```dart
@immutable
class TrackitInstance implements InstanceInterface {
  const TrackitInstance({
    required this.title,
    required TrackitBase base,
  }) : _base = base;

  final String title;
  final TrackitBase _base;

  void log(String message) => _base.notifyListeners(
    LogEvent.create(
      level: const LogLevel.trace(),
      title: title,
      message: message,
    ),
  );
  
  void debug(String message) => _base.notifyListeners(
    LogEvent.create(
      level: const LogLevel.debug(),
      title: title,
      message: message,
    ),
  );
  
  // ... другие методы
}
```

**Правила:**
- Класс должен быть `@immutable`
- Все поля `final`
- Конструктор `const`
- Зависимость `TrackitBase` передается через конструктор
- Каждый метод логирования создает `LogEvent` и отправляет через `_base.notifyListeners()`
- Реализует `InstanceInterface` для возможности mock в тестах

### LogEvent (Event Model)

Immutable модель события логирования:

```dart
@immutable
final class LogEvent implements Comparable<LogEvent> {
  const LogEvent({
    required this.level,
    required this.title,
    required this.message,
    this.time,
    this.exception,
    this.stackTrace,
  });

  factory LogEvent.create({
    required LogLevel level,
    required String title,
    required String message,
    Object? exception,
    StackTrace? stackTrace,
  }) =>
      LogEvent(
        level: level,
        title: title,
        message: message,
        time: DateTime.now(),
        exception: exception,
        stackTrace: stackTrace,
      );

  final LogLevel level;
  final String title;
  final String message;
  final DateTime? time;
  final Object? exception;
  final StackTrace? stackTrace;

  @override
  int compareTo(LogEvent other) => (time ?? DateTime.now())
      .compareTo(other.time ?? DateTime.now());
}
```

**Правила:**
- Класс должен быть `final` и `@immutable`
- Все поля `final`
- Конструктор `const`
- Factory конструктор `create()` автоматически устанавливает `time: DateTime.now()`
- Реализует `Comparable<LogEvent>` для сортировки по времени
- Nullable поля: `time`, `exception`, `stackTrace`

### LogLevel (Sealed Class)

Type-safe перечисление уровней логирования:

```dart
sealed class LogLevel {
  const LogLevel();

  const factory LogLevel.trace() = LogLevelTrace;
  const factory LogLevel.debug() = LogLevelDebug;
  const factory LogLevel.info() = LogLevelInfo;
  const factory LogLevel.warn() = LogLevelWarn;
  const factory LogLevel.error() = LogLevelError;
  const factory LogLevel.fatal() = LogLevelFatal;
}

final class LogLevelTrace extends LogLevel {
  const LogLevelTrace();
}

final class LogLevelDebug extends LogLevel {
  const LogLevelDebug();
}

// ... остальные уровни
```

**Правила:**
- Базовый класс `sealed` для exhaustive pattern matching
- Каждый уровень — отдельный `final` класс
- Const конструкторы везде
- Factory конструкторы в базовом классе для удобного создания
- Порядок уровней: trace < debug < info < warn < error < fatal

## API дизайн

### Создание логгера

```dart
// Создание экземпляра с title
final log = Trackit.create('MyService');
```

**Правила:**
- Использовать `Trackit.create(String title)` для создания экземпляров
- `title` обязателен и идентифицирует источник логов
- Каждый экземпляр независим, но отправляет события в общий stream

### Логирование

```dart
// Простое сообщение (уровень trace)
log.log('Operation started');

// Отладочная информация
log.debug('Variable value: $value');

// Информационное сообщение
log.info('User logged in');

// Предупреждение
log.warn('Deprecated API used');

// Ошибка
log.error('Failed to load data', exception, stackTrace);

// Критическая ошибка
log.fatal('Database connection lost', exception, stackTrace);
```

**Правила:**
- `log()` — общий метод, уровень trace
- `debug()`, `info()`, `warn()` — только сообщение
- `error()` — сообщение + опциональные exception и stackTrace
- `fatal()` — сообщение + обязательные exception и stackTrace

### Подписка на события

```dart
// Подписка на все события
Trackit().listen((event) {
  // Обработка события
  print('[${event.level}] ${event.title}: ${event.message}');
});

// Подписка с обработкой ошибок
Trackit().listen(
  (event) => handleEvent(event),
  onError: (error) => handleError(error),
  onDone: () => cleanup(),
);
```

**Правила:**
- Доступ к stream через `Trackit()` singleton
- Stream broadcast — множественные подписчики независимы
- События отправляются всем подписчикам
- Подписка не блокирует генерацию событий

## Структура файлов

```
lib/
├── trackit.dart              # Публичный API
└── src/
    ├── trackit_base.dart     # Базовый класс с Stream
    ├── instance/
    │   ├── trackit_instance.dart
    │   └── instance_interface.dart
    └── models/
        ├── log_event.dart
        └── log_level.dart
```

**Правила:**
- `lib/trackit.dart` — единственный публичный entry point
- `lib/src/` — внутренняя реализация (не экспортируется напрямую)
- `models/` — data классы и enums
- `instance/` — логика экземпляров логгера

## Экспорты

В `lib/trackit.dart` экспортировать только публичный API:

```dart
library trackit;

export 'src/instance/trackit_instance.dart';
export 'src/models/log_event.dart';
export 'src/models/log_level.dart';
```

**Правила:**
- Не экспортировать `TrackitBase` — внутренняя реализация
- Не экспортировать интерфейсы — только конкретные классы
- Минимальный публичный API

## Зависимости

```yaml
dependencies:
  meta: ^1.15.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.8
```

**Правила:**
- Только `meta` в production зависимостях
- Никаких других runtime зависимостей
- Базовый пакет должен быть максимально легковесным

## Тестирование

### Что тестировать

- Создание экземпляров через `Trackit.create()`
- Генерация событий всех уровней
- Доставка событий подписчикам
- Множественные подписчики получают одни и те же события
- Сравнение `LogEvent` по времени
- Factory конструкторы `LogLevel`

### Пример теста

```dart
import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

void main() {
  group('Trackit', () {
    test('should create instance with title', () {
      final log = Trackit.create('Test');
      expect(log, isNotNull);
      expect(log.title, equals('Test'));
    });

    test('should emit events to listeners', () {
      final log = Trackit.create('Test');
      Trackit().listen(
        expectAsync1((event) {
          expect(event.title, 'Test');
          expect(event.message, 'Test message');
          expect(event.level, isA<LogLevelInfo>());
        }),
      );
      log.info('Test message');
    });

    test('should support multiple listeners', () {
      final log = Trackit.create('Test');
      var count = 0;
      
      Trackit().listen((_) => count++);
      Trackit().listen((_) => count++);
      
      log.info('Message');
      
      expect(count, equals(2));
    });
  });
}
```

## Расширение базового функционала

### Создание обработчика событий

Для создания модуля, обрабатывающего события:

```dart
class MyHandler {
  MyHandler() {
    Trackit().listen(onData);
  }
  
  void onData(LogEvent event) {
    // Обработка события
    // Например: вывод в консоль, отправка на сервер, сохранение в БД
  }
}
```

### Фильтрация событий

```dart
Trackit().listen((event) {
  // Обрабатывать только ошибки
  if (event.level is LogLevelError || event.level is LogLevelFatal) {
    sendToErrorTracking(event);
  }
});
```

### Трансформация потока

```dart
Trackit()
  .where((event) => event.level is LogLevelError)
  .map((event) => ErrorReport.fromLogEvent(event))
  .listen(sendToServer);
```

## Best Practices

1. **Один экземпляр на модуль/класс**: Создавайте отдельный логгер для каждого логического модуля с описательным title
2. **Не блокировать в обработчиках**: Подписчики не должны выполнять долгие операции синхронно
3. **Использовать правильный уровень**: trace для детальной отладки, debug для отладочной информации, info для обычных событий
4. **Передавать exception и stackTrace**: При логировании ошибок всегда передавать объект исключения и stack trace
5. **Не логировать чувствительные данные**: Никогда не логировать пароли, токены, персональные данные

## Антипаттерны

❌ **Создание множества экземпляров с одинаковым title**
```dart
// Плохо
final log1 = Trackit.create('Service');
final log2 = Trackit.create('Service'); // Дубликат
```

✅ **Один экземпляр на класс**
```dart
// Хорошо
class MyService {
  static final _log = Trackit.create('MyService');
  
  void doWork() {
    _log.info('Work started');
  }
}
```

❌ **Игнорирование исключений при логировании ошибок**
```dart
// Плохо
try {
  await operation();
} catch (e) {
  log.error('Operation failed'); // Потеряли exception
}
```

✅ **Передача полной информации об ошибке**
```dart
// Хорошо
try {
  await operation();
} catch (e, stackTrace) {
  log.error('Operation failed', e, stackTrace);
}
```

❌ **Блокирующие операции в подписчиках**
```dart
// Плохо
Trackit().listen((event) {
  // Синхронная тяжелая операция
  final result = expensiveComputation(event);
  database.saveSync(result);
});
```

✅ **Асинхронная обработка**
```dart
// Хорошо
Trackit().listen((event) {
  // Запускаем асинхронно
  Future.microtask(() async {
    final result = await expensiveComputation(event);
    await database.save(result);
  });
});
```
