# TrackIt History Package — Правила разработки

## О пакете

`trackit_history` — модуль-расширение для хранения логов в памяти. Подписывается на поток событий из базового `trackit` и сохраняет их в FIFO очереди с ограничением по размеру.

## Архитектурные паттерны

### Singleton Pattern

Глобальное хранилище истории как singleton:

```dart
class TrackitHistory {
  factory TrackitHistory() => _instance;

  TrackitHistory._internal();

  static final TrackitHistory _instance = TrackitHistory._internal();

  final TrackitHistoryList _history = [];
  int _maxSize = 1000;
}
```

**Правила:**
- Factory конструктор для доступа к единственному экземпляру
- Приватный конструктор `_internal()`
- Статическое поле `_instance` с eager initialization
- Приватные поля для хранения состояния

### FIFO Queue Pattern

Очередь с автоматическим удалением старых элементов:

```dart
void add(LogEvent event) {
  _history.add(event);
  
  while (_history.length > _maxSize) {
    _history.removeAt(0); // Удаление самого старого
  }
}
```

**Правила:**
- Добавление в конец списка (`add`)
- Удаление из начала списка (`removeAt(0)`)
- Проверка размера после каждого добавления
- Использовать `while`, не `if` для корректной обработки изменения `maxSize`

### Immutable Access Pattern

Защита от внешних изменений:

```dart
TrackitHistoryList get history => List.unmodifiable(_history);
```

**Правила:**
- Возвращать `List.unmodifiable()` для предотвращения изменений
- Внутреннее хранилище остается приватным
- Все изменения только через публичные методы класса

## Структура класса

### TrackitHistory (Singleton)

```dart
class TrackitHistory {
  factory TrackitHistory() => _instance;

  TrackitHistory._internal();

  static final TrackitHistory _instance = TrackitHistory._internal();

  final TrackitHistoryList _history = [];
  int _maxSize = 1000;

  /// Добавляет событие в историю
  void add(LogEvent event) {
    _history.add(event);
    while (_history.length > _maxSize) {
      _history.removeAt(0);
    }
  }

  /// Возвращает неизменяемую копию истории
  TrackitHistoryList get history => List.unmodifiable(_history);

  /// Устанавливает максимальный размер истории
  void setMaxSize(int size) {
    _maxSize = size;
    while (_history.length > _maxSize) {
      _history.removeAt(0);
    }
  }

  /// Очищает всю историю
  void clear() {
    _history.clear();
  }
}
```

**Ответственность:**
- Хранение событий в памяти
- Управление размером истории
- Предоставление доступа к истории

### TrackitHistoryList (Type Alias)

```dart
typedef TrackitHistoryList = List<LogEvent>;
```

**Правила:**
- Простой type alias для ясности API
- Используется для возвращаемых значений
- Подчеркивает назначение списка

## API дизайн

### Добавление событий

```dart
void add(LogEvent event)
```

**Правила:**
- Единственный параметр — `LogEvent`
- Void return type (side effect)
- Автоматически управляет размером
- Синхронный метод

### Доступ к истории

```dart
TrackitHistoryList get history
```

**Правила:**
- Геттер, не метод
- Возвращает неизменяемый список
- O(n) операция (создается новый список)
- Не кешировать результат на стороне клиента

### Установка максимального размера

```dart
void setMaxSize(int size)
```

**Правила:**
- Положительное целое число
- Применяется немедленно (удаляет лишние элементы)
- Может уменьшить текущую историю
- Default значение: 1000

### Очистка истории

```dart
void clear()
```

**Правила:**
- Удаляет все события
- Не изменяет `maxSize`
- Используется для reset состояния
- Полезно для тестов и hot reload

## Управление памятью

### Ограничение размера

**Default значение:**
```dart
int _maxSize = 1000;
```

**Правила:**
- По умолчанию 1000 событий
- Можно изменить через `setMaxSize()`
- Рассчитывать потребление памяти: ~1000 событий ≈ 100-500 KB
- Для long-running приложений рекомендуется ограничивать размер

### Автоматическая очистка

```dart
while (_history.length > _maxSize) {
  _history.removeAt(0);
}
```

**Правила:**
- Очистка происходит при добавлении нового события
- Удаляются самые старые события (FIFO)
- Использовать `while`, не `if` (корректно обрабатывает уменьшение maxSize)
- O(n) сложность при удалении (допустимо для небольших n)

### Оптимизация производительности

**Для больших историй:**
```dart
// Рассмотреть использование Queue вместо List
import 'dart:collection';

final Queue<LogEvent> _history = Queue();

void add(LogEvent event) {
  _history.add(event);
  while (_history.length > _maxSize) {
    _history.removeFirst(); // O(1) вместо O(n)
  }
}
```

**Правила:**
- Для `maxSize > 10000` рассмотреть `Queue`
- `removeFirst()` в Queue — O(1) vs `removeAt(0)` в List — O(n)
- Компромисс: Queue требует больше памяти

## Использование

### Базовое использование

```dart
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

void main() {
  // Подключение хранилища истории
  Trackit().listen((event) {
    TrackitHistory().add(event);
  });
  
  // Создание логгера
  final log = Trackit.create('MyApp');
  
  // Логирование
  log.info('Event 1');
  log.info('Event 2');
  
  // Доступ к истории
  final history = TrackitHistory().history;
  print('Total events: ${history.length}');
}
```

### Упрощенная подписка

```dart
// Короткая форма
Trackit().listen(TrackitHistory().add);
```

### С ограничением размера

```dart
void main() {
  // Установка максимального размера
  TrackitHistory().setMaxSize(500);
  
  // Подключение
  Trackit().listen(TrackitHistory().add);
}
```

### Фильтрация событий

```dart
// Сохранять только ошибки
Trackit().listen((event) {
  if (event.level is LogLevelError || event.level is LogLevelFatal) {
    TrackitHistory().add(event);
  }
});
```

### Периодическая очистка

```dart
// Очищать историю каждый час
Timer.periodic(Duration(hours: 1), (_) {
  TrackitHistory().clear();
});
```

## Доступ к истории

### Получение всех событий

```dart
final allEvents = TrackitHistory().history;
```

### Фильтрация по уровню

```dart
final errors = TrackitHistory()
    .history
    .where((e) => e.level is LogLevelError)
    .toList();
```

### Фильтрация по времени

```dart
final lastHour = DateTime.now().subtract(Duration(hours: 1));
final recentEvents = TrackitHistory()
    .history
    .where((e) => e.time != null && e.time!.isAfter(lastHour))
    .toList();
```

### Фильтрация по title

```dart
final serviceEvents = TrackitHistory()
    .history
    .where((e) => e.title == 'MyService')
    .toList();
```

### Сортировка

```dart
// По времени (по возрастанию)
final sorted = TrackitHistory()
    .history
    .sorted((a, b) => a.compareTo(b));

// По времени (по убыванию)
final reversed = TrackitHistory()
    .history
    .sorted((a, b) => b.compareTo(a));
```

### Последние N событий

```dart
final last10 = TrackitHistory()
    .history
    .reversed
    .take(10)
    .toList();
```

## Интеграция с UI

### Flutter: Отображение истории логов

```dart
class LogHistoryScreen extends StatelessWidget {
  const LogHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = TrackitHistory().history.reversed.toList();
    
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final event = history[index];
        return ListTile(
          leading: Icon(_getIconForLevel(event.level)),
          title: Text(event.message),
          subtitle: Text('${event.title} • ${event.time}'),
        );
      },
    );
  }
}
```

### Реактивное обновление

```dart
class LogHistoryProvider extends ChangeNotifier {
  List<LogEvent> get history => TrackitHistory().history;
  
  void _updateHistory(LogEvent event) {
    TrackitHistory().add(event);
    notifyListeners();
  }
  
  void init() {
    Trackit().listen(_updateHistory);
  }
}
```

### Stream для UI

```dart
// Создать Stream для реактивного UI
Stream<TrackitHistoryList> get historyStream async* {
  await for (final _ in Trackit()) {
    yield TrackitHistory().history;
  }
}
```

## Экспорт истории

### В JSON

```dart
String exportToJson() {
  final history = TrackitHistory().history;
  final json = history.map((event) => {
    'level': event.level.toString(),
    'title': event.title,
    'message': event.message,
    'time': event.time?.toIso8601String(),
    'exception': event.exception?.toString(),
    'stackTrace': event.stackTrace?.toString(),
  }).toList();
  
  return jsonEncode(json);
}
```

### В текстовый файл

```dart
Future<void> exportToFile(String path) async {
  final history = TrackitHistory().history;
  final buffer = StringBuffer();
  
  for (final event in history) {
    buffer.writeln('[${event.level}] ${event.time} - ${event.title}');
    buffer.writeln('  ${event.message}');
    if (event.exception != null) {
      buffer.writeln('  Exception: ${event.exception}');
    }
    buffer.writeln();
  }
  
  final file = File(path);
  await file.writeAsString(buffer.toString());
}
```

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
- Чистый Dart код без platform-specific логики

## Тестирование

### Что тестировать

- Добавление событий в историю
- Ограничение по размеру (FIFO)
- Изменение maxSize с удалением лишних элементов
- Очистка истории
- Неизменяемость возвращаемого списка
- Singleton поведение

### Пример теста

```dart
import 'package:test/test.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

void main() {
  setUp(() {
    TrackitHistory().clear();
  });

  group('TrackitHistory', () {
    test('should add events to history', () {
      final event = LogEvent(
        level: const LogLevel.info(),
        title: 'Test',
        message: 'Test message',
      );
      
      TrackitHistory().add(event);
      
      expect(TrackitHistory().history.length, equals(1));
      expect(TrackitHistory().history.first, equals(event));
    });

    test('should limit history size', () {
      TrackitHistory().setMaxSize(3);
      
      for (var i = 0; i < 5; i++) {
        TrackitHistory().add(LogEvent(
          level: const LogLevel.info(),
          title: 'Test',
          message: 'Message $i',
        ));
      }
      
      expect(TrackitHistory().history.length, equals(3));
      expect(TrackitHistory().history.last.message, equals('Message 4'));
      expect(TrackitHistory().history.first.message, equals('Message 2'));
    });

    test('should clear history', () {
      TrackitHistory().add(LogEvent(
        level: const LogLevel.info(),
        title: 'Test',
        message: 'Test',
      ));
      
      expect(TrackitHistory().history.length, equals(1));
      
      TrackitHistory().clear();
      
      expect(TrackitHistory().history.length, equals(0));
    });

    test('should return unmodifiable list', () {
      final history = TrackitHistory().history;
      
      expect(
        () => history.add(LogEvent(
          level: const LogLevel.info(),
          title: 'Test',
          message: 'Test',
        )),
        throwsUnsupportedError,
      );
    });

    test('should be singleton', () {
      final instance1 = TrackitHistory();
      final instance2 = TrackitHistory();
      
      expect(identical(instance1, instance2), isTrue);
    });
  });
}
```

## Best Practices

1. **Установить разумный maxSize**: Для production рекомендуется 500-2000 событий в зависимости от частоты логирования
2. **Фильтровать перед добавлением**: Для экономии памяти фильтровать события по уровню или источнику
3. **Периодическая очистка**: Для long-running приложений настроить автоматическую очистку
4. **Не злоупотреблять доступом**: Геттер `history` создает новый список — кешировать результат если нужно
5. **Использовать для отладки**: В production отключать или ограничивать размер для экономии памяти

## Антипаттерны

❌ **Хранение слишком большой истории**
```dart
// Плохо - утечка памяти
TrackitHistory().setMaxSize(1000000); // 1M событий!
```

✅ **Разумное ограничение**
```dart
// Хорошо
TrackitHistory().setMaxSize(1000); // 1K событий
```

❌ **Частые обращения к history в hot path**
```dart
// Плохо - O(n) на каждый вызов
Widget build(BuildContext context) {
  final history = TrackitHistory().history; // Создает новый список!
  return ListView.builder(...);
}
```

✅ **Кеширование или реактивность**
```dart
// Хорошо - кеширование
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late List<LogEvent> _cachedHistory;

  @override
  void initState() {
    super.initState();
    _cachedHistory = TrackitHistory().history;
    Trackit().listen((_) {
      setState(() {
        _cachedHistory = TrackitHistory().history;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _cachedHistory.length,
      itemBuilder: (context, index) => ...,
    );
  }
}
```

❌ **Сохранение всех событий без фильтрации**
```dart
// Плохо - храним все, включая trace/debug
Trackit().listen(TrackitHistory().add);
```

✅ **Фильтрация важных событий**
```dart
// Хорошо - только warnings, errors, fatals
Trackit().listen((event) {
  if (event.level is! LogLevelTrace && event.level is! LogLevelDebug) {
    TrackitHistory().add(event);
  }
});
```

❌ **Забывать очищать в тестах**
```dart
// Плохо - тесты влияют друг на друга
test('test 1', () {
  TrackitHistory().add(...);
  expect(TrackitHistory().history.length, equals(1));
});

test('test 2', () {
  // История из теста 1 все еще здесь!
  expect(TrackitHistory().history.length, equals(0)); // Fails!
});
```

✅ **Очистка в setUp**
```dart
// Хорошо - изоляция тестов
setUp(() {
  TrackitHistory().clear();
});

test('test 1', () { ... });
test('test 2', () { ... });
```

## Расширения и кастомизация

### Кастомное хранилище

Если нужно хранить историю не в памяти, а в другом месте:

```dart
class TrackitDatabaseHistory {
  factory TrackitDatabaseHistory() => _instance;
  
  TrackitDatabaseHistory._internal();
  
  static final TrackitDatabaseHistory _instance = 
      TrackitDatabaseHistory._internal();
  
  final Database _db = Database();
  
  Future<void> add(LogEvent event) async {
    await _db.insert('logs', event.toMap());
  }
  
  Future<List<LogEvent>> getHistory({int limit = 1000}) async {
    final maps = await _db.query('logs', limit: limit);
    return maps.map((m) => LogEvent.fromMap(m)).toList();
  }
}
```

### Фильтрующее хранилище

```dart
class TrackitFilteredHistory {
  TrackitFilteredHistory({required this.filter});
  
  final bool Function(LogEvent) filter;
  final List<LogEvent> _history = [];
  
  void add(LogEvent event) {
    if (filter(event)) {
      _history.add(event);
    }
  }
  
  List<LogEvent> get history => List.unmodifiable(_history);
}

// Использование
final errorHistory = TrackitFilteredHistory(
  filter: (e) => e.level is LogLevelError || e.level is LogLevelFatal,
);

Trackit().listen(errorHistory.add);
```

## Производительность

### Оценка потребления памяти

Примерный размер одного `LogEvent`:
- LogLevel: ~8 bytes
- String (title): ~50 bytes
- String (message): ~100 bytes
- DateTime: ~8 bytes
- Exception: ~100 bytes (опционально)
- StackTrace: ~500 bytes (опционально)

**Без exception/stackTrace**: ~200 bytes/event
**С exception/stackTrace**: ~800 bytes/event

Для 1000 событий: 200 KB - 800 KB

### Рекомендации по размеру

- **Mobile apps**: 500-1000 событий
- **Desktop apps**: 1000-5000 событий
- **Servers**: Рассмотреть внешнее хранилище

### Мониторинг памяти

```dart
void printMemoryUsage() {
  final history = TrackitHistory().history;
  final count = history.length;
  final estimatedBytes = count * 500; // Средний размер
  
  print('History size: $count events');
  print('Estimated memory: ${estimatedBytes ~/ 1024} KB');
}
```
