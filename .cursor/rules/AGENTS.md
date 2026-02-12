# TrackIt — Общие правила проекта

## О проекте

TrackIt — модульный легковесный логгер для Dart и Flutter с архитектурой monorepo (melos). Проект построен на принципах DRY, KISS, модульности и расширяемости.

## Инструменты разработки

### FVM (Flutter Version Manager)

**ОБЯЗАТЕЛЬНО**: Проект использует FVM для управления версией Flutter SDK.

**Установка FVM:**
```bash
# macOS/Linux
brew tap leoafarias/fvm
brew install fvm

# Windows
choco install fvm

# Dart pub
dart pub global activate fvm
```

**Настройка проекта:**
```bash
# Установка Flutter версии из .fvm/fvm_config.json
fvm install

# Использование Flutter через FVM
fvm flutter --version
fvm dart --version
```

**Правила:**
- ВСЕГДА использовать `fvm flutter` вместо `flutter`
- ВСЕГДА использовать `fvm dart` вместо `dart`
- Не коммитить `.fvm/flutter_sdk` (уже в .gitignore)
- Коммитить `.fvm/fvm_config.json` для фиксации версии Flutter
- IDE должна быть настроена на использование `.fvm/flutter_sdk`

**Настройка IDE:**
```
VSCode: .vscode/settings.json:
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}

IntelliJ/Android Studio:
Settings → Languages & Frameworks → Flutter → Flutter SDK path
Указать: <project_path>/.fvm/flutter_sdk
```

### Melos (Monorepo Management)

**ОБЯЗАТЕЛЬНО**: Проект использует Melos для управления monorepo, версионированием и публикацией пакетов.

**Установка Melos:**
```bash
fvm dart pub global activate melos
```

**Конфигурация:**
Файл `melos.yaml` настроен для работы с FVM:
```yaml
name: Trackit
repository: https://github.com/unger1984/trackit
sdkPath: .fvm/flutter_sdk  # Использование FVM SDK
```

**Правила:**
- Все команды выполнять через Melos
- Версионирование только через `melos version`
- Публикация только через `melos publish`
- Bootstrap перед началом работы
- Не изменять версии пакетов вручную в pubspec.yaml

## Стиль кодирования

### Общие требования

- Dart SDK: `>=3.6.0 <4.0.0` с null safety
- Линтер: `package:lints/recommended.yaml`
- Все классы должны быть immutable где возможно
- Использовать аннотации из `package:meta`

### Именование

- **Классы**: `PascalCase` (например, `Trackit`, `LogEvent`, `TrackitInstance`)
- **Методы и переменные**: `camelCase` (например, `handleEvent`, `notifyListeners`, `maxSize`)
- **Приватные члены**: префикс `_` (например, `_controller`, `_internalSingleton`, `_title`)
- **Константы**: `camelCase` для приватных, `lowerCamelCase` для публичных

### Структура классов

- Использовать `@immutable` для неизменяемых классов
- Все поля должны быть `final` где возможно
- Использовать `const` конструкторы для простых data-классов
- Аннотации порядка: `@immutable`, `@protected`, `@internal`, `@visibleForOverriding`

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
  
  final LogLevel level;
  final String title;
  final String message;
  final DateTime? time;
  final Object? exception;
  final StackTrace? stackTrace;
}
```

### Документация

- Использовать `///` для документирования публичного API
- Документировать все публичные классы, методы и поля
- Краткое описание на первой строке, детали после пустой строки
- Примеры использования в документации при необходимости

```dart
/// Creates a new instance of logger with the specified [title].
///
/// The [title] is used to identify the source of log events.
/// Each instance has its own title but shares the same event stream.
static TrackitInstance create(String title) => TrackitInstance(
  title: title,
  base: _internalSingleton,
);
```

## Архитектурные паттерны

### Singleton

Использовать для глобальных сервисов через factory constructor и приватный экземпляр:

```dart
class Trackit extends TrackitBase {
  factory Trackit() => _internalSingleton;
  
  Trackit._internal() : super();
  
  static final Trackit _internalSingleton = Trackit._internal();
}
```

### Factory методы

Предпочитать factory методы для создания экземпляров с дополнительной логикой:

```dart
static TrackitInstance create(String title) => TrackitInstance(
  title: title,
  base: _internalSingleton,
);
```

### Stream/Observer паттерн

- Использовать `StreamController.broadcast()` для множественных подписчиков
- Классы могут расширять `Stream<T>` для прямого доступа к потоку
- Закрывать контроллеры в dispose/close методах

```dart
abstract class TrackitBase extends Stream<LogEvent> {
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
}
```

### Dependency Injection

Передавать зависимости через конструкторы, не использовать глобальные состояния кроме singleton-сервисов:

```dart
class TrackitInstance implements InstanceInterface {
  const TrackitInstance({
    required this.title,
    required TrackitBase base,
  }) : _base = base;

  final String title;
  final TrackitBase _base;
}
```

### Sealed классы

Использовать sealed классы для type-safe перечислений с возможностью exhaustive matching:

```dart
sealed class LogLevel {
  const LogLevel();
  
  const factory LogLevel.trace() = LogLevelTrace;
  const factory LogLevel.debug() = LogLevelDebug;
  const factory LogLevel.info() = LogLevelInfo;
  // ...
}

final class LogLevelTrace extends LogLevel {
  const LogLevelTrace();
}
```

### Модульная архитектура

- Каждый пакет решает одну конкретную задачу
- Минимальные зависимости между пакетами
- Базовый пакет (`trackit`) предоставляет только ядро
- Расширения (`trackit_console`, `trackit_history`) подписываются на события

## Управление зависимостями

### Workspace (Melos)

Проект использует melos для управления monorepo:

```yaml
workspace:
  - packages/trackit
  - packages/trackit_console
  - packages/trackit_history
```

### Минимализм

- Добавлять только необходимые зависимости
- Использовать `meta` для аннотаций
- Избегать тяжелых зависимостей в базовых пакетах

### Версионирование

- Все пакеты должны указывать совместимые версии SDK
- Использовать каретку `^` для версий зависимостей
- Версии базовых пакетов (`meta`, `test`, `lints`) должны быть согласованы

```yaml
environment:
  sdk: '>=3.6.0 <4.0.0'

dependencies:
  meta: ^1.15.0
  
dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.8
```

## Тестирование

### Структура тестов

- Тесты в директории `test/` каждого пакета
- Файлы тестов: `*_test.dart`
- Использовать `package:test`

### Стиль тестов

- Группировка через `group()`
- Описательные названия тестов: `'should ...'`
- Тестировать публичный API, а не внутреннюю реализацию
- Использовать `expect()` для утверждений

```dart
import 'package:test/test.dart';
import 'package:trackit/trackit.dart';

void main() {
  group('Trackit', () {
    test('should create Trackit instance', () {
      final log = Trackit.create('Test Instance');
      expect(log, isNotNull);
      expect(log.title, equals('Test Instance'));
    });

    test('should emit log events to listeners', () {
      final log = Trackit.create('Test Instance');
      Trackit().listen(
        expectAsync1((data) {
          expect(data.title, 'Test Instance');
          expect(data.message, 'Test log message');
          expect(data.level, equals(const LogLevel.trace()));
        }),
      );
      log.log('Test log message');
    });
  });
}
```

### Покрытие

- Запускать тесты с флагом `--coverage`
- Стремиться к высокому покрытию публичного API
- Команда: `melos run test`

## Стиль коммитов

### Conventional Commits

Использовать формат Conventional Commits для всех коммитов:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Типы коммитов

- `feat`: Новая функциональность
- `fix`: Исправление бага
- `docs`: Изменения в документации
- `refactor`: Рефакторинг кода без изменения функциональности
- `test`: Добавление или изменение тестов
- `chore`: Обслуживание проекта (зависимости, конфигурация)
- `perf`: Улучшение производительности
- `style`: Форматирование кода (не затрагивает логику)

### Scope

Указывать пакет в scope:

- `feat(trackit): add new log level`
- `fix(console): fix formatter color output`
- `docs(history): update API documentation`
- `refactor(trackit): simplify event handling`

### Примеры

```
feat(trackit): add fatal log level

Add fatal() method to TrackitInstance for critical errors.

BREAKING CHANGE: LogLevel enum now includes fatal level.
```

```
fix(console): prevent null exception in pattern formatter

Check for null values before string interpolation.

Fixes #42
```

## Melos команды

**ВАЖНО**: Все команды запускаются через Melos для обеспечения согласованности в monorepo.

### Bootstrap (Инициализация)

```bash
# Установка всех зависимостей для всех пакетов
melos bootstrap
```

**Когда использовать:**
- После клонирования репозитория
- После изменения зависимостей в pubspec.yaml
- После переключения веток
- После `git pull`

**Что делает:**
- Устанавливает зависимости для всех пакетов через FVM Flutter SDK
- Создает symlinks между локальными пакетами
- Генерирует `pubspec_overrides.yaml`

### Линтинг и форматирование

```bash
# Запуск всех проверок
melos run lint:all

# Отдельные команды
melos analyze        # Статический анализ
melos format         # Проверка форматирования
melos format --fix   # Автоисправление форматирования
```

**Правила:**
- Запускать перед каждым коммитом
- Все проверки должны проходить успешно (0 issues)
- Не коммитить код с warnings/errors
- Использовать `package:lints/recommended.yaml`

### Тестирование

```bash
# Запуск всех тестов с покрытием
melos run test

# Тесты для конкретного пакета
melos exec --scope="trackit" -- "fvm flutter test --coverage"
melos exec --scope="trackit_console" -- "fvm flutter test --coverage"
```

**Правила:**
- Все тесты должны проходить перед коммитом
- Покрытие должно быть > 80% для новых фич
- Не игнорировать падающие тесты
- Использовать FVM для запуска тестов

### Версионирование и публикация

**КРИТИЧЕСКИ ВАЖНО**: Версионирование и публикация ТОЛЬКО через Melos!

#### Подготовка к релизу

1. **Убедиться что вы на ветке `main`:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Убедиться что все изменения закоммичены:**
   ```bash
   git status  # Должно быть: "nothing to commit, working tree clean"
   ```

3. **Запустить все проверки:**
   ```bash
   melos run lint:all
   melos run test
   ```
   
   Все проверки должны пройти успешно!

#### Версионирование

```bash
# Автоматическое версионирование с conventional commits
melos version

# С указанием типа изменений
melos version --graduate      # Переход 0.x.x -> 1.0.0
melos version --prerelease    # Создание pre-release версии (1.0.0-dev.1)
```

**Процесс версионирования:**

1. Запустить версионирование:
   ```bash
   melos version
   ```

2. Melos автоматически:
   - Анализирует conventional commits с последней версии
   - Определяет тип изменений (major/minor/patch)
   - Обновляет версии в pubspec.yaml всех пакетов
   - Обновляет CHANGELOG.md для каждого пакета
   - Создает git commit с сообщением "chore(release): publish packages"
   - Создает git tags для каждого пакета (например, `trackit-v1.0.0`)

3. Проверить сгенерированные изменения:
   ```bash
   git log -1 --stat       # Проверить commit
   git tag -l              # Проверить созданные теги
   git show <tag-name>     # Детали конкретного тега
   ```

4. Отправить изменения и теги на GitHub:
   ```bash
   git push origin main
   git push origin --tags
   ```

**Правила версионирования:**
- ❌ НИКОГДА не изменять версии вручную в pubspec.yaml
- ✅ Версионирование ТОЛЬКО на ветке `main`
- ✅ Все пакеты версионируются согласованно
- ✅ Следовать Semantic Versioning (SemVer 2.0)
- ✅ Использовать conventional commits для автоопределения версии

**Типы версий по conventional commits:**
- `feat:` → MINOR версия (0.1.0 -> 0.2.0)
- `fix:` → PATCH версия (0.1.0 -> 0.1.1)
- `BREAKING CHANGE:` или `!` → MAJOR версия (0.1.0 -> 1.0.0)
- `docs:`, `chore:`, `refactor:`, `test:` → Не меняют версию

**Примеры:**
```bash
# feat(trackit): add fatal log level
# Результат: 0.1.0 -> 0.2.0

# fix(console): prevent null exception
# Результат: 0.1.0 -> 0.1.1

# feat(trackit)!: change API signature
# BREAKING CHANGE: LogLevel is now sealed class
# Результат: 0.1.0 -> 1.0.0
```

#### Публикация на pub.dev

**ВАЖНО**: Публикация необратима! Нельзя удалить или изменить опубликованную версию.

1. **Убедиться что версионирование выполнено:**
   ```bash
   git log -1        # Должен быть commit от melos version
   git tag -l        # Должны быть новые теги
   ```

2. **Еще раз проверить тесты и линтер:**
   ```bash
   melos run lint:all
   melos run test
   ```

3. **Dry run публикации (симуляция):**
   ```bash
   melos publish --dry-run
   ```
   
   Проверить вывод:
   - ✅ Список пакетов для публикации
   - ✅ Версии пакетов корректны
   - ✅ Включаемые файлы правильные
   - ✅ README.md и CHANGELOG.md актуальны

4. **Публикация:**
   ```bash
   melos publish --no-dry-run
   ```
   
   Melos последовательно опубликует каждый пакет.
   Для каждого пакета нужно подтвердить (y/n).

5. **Проверить на pub.dev:**
   - https://pub.dev/packages/trackit
   - https://pub.dev/packages/trackit_console
   - https://pub.dev/packages/trackit_history

6. **Создать GitHub Release:**
   
   После публикации Melos может сгенерировать ссылку на GitHub Release.
   Добавить release notes с описанием изменений.

**Правила публикации:**
- ✅ ВСЕГДА делать `--dry-run` перед публикацией
- ✅ Публиковать только после успешного версионирования
- ✅ Публиковать только с ветки `main`
- ✅ Все тесты и линтер должны проходить
- ✅ README.md, CHANGELOG.md, LICENSE должны быть актуальны
- ❌ Не публиковать пакеты с `TODO`, `FIXME`, незавершенным кодом
- ❌ Не публиковать если есть breaking changes без обновления MAJOR версии

**Откат публикации:**

Публикация в pub.dev **необратима**!

Если опубликована неправильная версия:
- ❌ Нельзя удалить версию
- ❌ Нельзя перезаписать версию
- ✅ Можно только опубликовать следующую версию с исправлениями

**Поэтому ОБЯЗАТЕЛЬНО:**
- Тестировать локально на реальных проектах
- Использовать `--dry-run` перед публикацией
- Проверять все дважды
- Не торопиться

#### Работа с FVM и Melos

**Все команды через FVM:**

```bash
# Правильно
fvm flutter --version
fvm dart --version
melos bootstrap      # Использует sdkPath: .fvm/flutter_sdk из melos.yaml

# Неправильно
flutter --version    # Может использовать неправильную версию!
dart --version       # Может использовать неправильную версию!
```

**Конфигурация в melos.yaml:**
```yaml
name: Trackit
repository: https://github.com/unger1984/trackit
sdkPath: .fvm/flutter_sdk  # ← Использует FVM SDK
```

Это гарантирует что все команды Melos используют правильную версию Flutter.

## Принципы разработки

### DRY (Don't Repeat Yourself)

- Избегать дублирования кода
- Выносить общую логику в базовые классы
- Использовать composition over inheritance

### KISS (Keep It Simple, Stupid)

- Простота важнее сложности
- Каждый класс/метод решает одну задачу
- Избегать преждевременной оптимизации

### Модульность

- Каждый пакет — отдельная функциональность
- Слабая связанность между пакетами
- Высокая связность внутри пакетов

### Расширяемость

- Использовать Stream для подписки на события
- Открыто-закрытый принцип (open-closed)
- Возможность добавления новых модулей без изменения базового кода

### Типобезопасность

- Строгая типизация
- Sealed классы для исчерпывающего pattern matching
- Null safety по умолчанию

### Производительность

- Broadcast stream для эффективной работы с множественными подписчиками
- Минимальные зависимости
- Ленивая инициализация где возможно

### Platform-agnostic

- Поддержка всех платформ Dart/Flutter
- Использовать conditional imports для platform-specific кода
- Тестировать на разных платформах

---

## Быстрая справка (Cheat Sheet)

### Начало работы

```bash
# Клонирование проекта
git clone https://github.com/unger1984/trackit.git
cd trackit

# Установка FVM Flutter SDK
fvm install

# Установка зависимостей
melos bootstrap

# Проверка что все работает
melos run lint:all
melos run test
```

### Ежедневная разработка

```bash
# Перед началом работы
git checkout main
git pull origin main
melos bootstrap

# Создание feature ветки
git checkout -b feat/my-feature

# Разработка...
# Написание кода
# Написание тестов

# Проверка перед коммитом
melos run lint:all
melos run test

# Коммит с conventional commits
git add .
git commit -m "feat(trackit): add new feature"

# Push в origin
git push origin feat/my-feature

# Создание Pull Request на GitHub
```

### Релиз (только maintainers)

```bash
# Убедиться что на main
git checkout main
git pull origin main

# Все тесты проходят
melos run lint:all
melos run test

# Версионирование
melos version

# Push с тегами
git push origin main
git push origin --tags

# Публикация (с осторожностью!)
melos publish --dry-run     # Сначала проверка
melos publish --no-dry-run  # Затем публикация

# Проверить на pub.dev
# Создать GitHub Release
```

### Типичные команды

```bash
# Обновить зависимости
melos bootstrap

# Запустить линтер
melos run lint:all

# Запустить тесты
melos run test

# Запустить тесты для одного пакета
melos exec --scope="trackit" -- "fvm flutter test"

# Проверить версии
fvm flutter --version
fvm dart --version

# Очистка (при проблемах)
melos clean
fvm flutter clean
melos bootstrap
```

### Conventional Commits шаблоны

```bash
# Новая функция (minor version)
git commit -m "feat(trackit): add support for custom formatters"

# Исправление бага (patch version)
git commit -m "fix(console): handle null exception in pattern formatter"

# Breaking change (major version)
git commit -m "feat(trackit)!: change LogLevel API

BREAKING CHANGE: LogLevel is now a sealed class instead of enum"

# Документация (no version change)
git commit -m "docs(readme): update installation instructions"

# Рефакторинг (no version change)
git commit -m "refactor(history): improve memory management"

# Тесты (no version change)
git commit -m "test(console): add tests for JSON formatter"

# Chore (no version change)
git commit -m "chore(deps): update meta to ^1.16.0"
```

### Структура scope в коммитах

- `trackit` — базовый пакет
- `console` — trackit_console
- `history` — trackit_history
- `deps` — зависимости
- `ci` — CI/CD конфигурация
- `docs` — документация
- `release` — релизы

### Проверочный чеклист перед коммитом

- [ ] `melos run lint:all` проходит без ошибок
- [ ] `melos run test` все тесты зеленые
- [ ] Код следует стилю проекта (immutable, const, final)
- [ ] Добавлена документация `///` для публичного API
- [ ] Написаны тесты для новой функциональности
- [ ] Conventional commit message
- [ ] Правильный scope в commit message

### Проверочный чеклист перед публикацией

- [ ] Находимся на ветке `main`
- [ ] Все изменения закоммичены (`git status` чист)
- [ ] `melos run lint:all` — успешно
- [ ] `melos run test` — все тесты проходят
- [ ] `melos version` выполнен
- [ ] Теги созданы (`git tag -l`)
- [ ] Изменения и теги отправлены на GitHub
- [ ] `melos publish --dry-run` проверен
- [ ] README.md актуален
- [ ] CHANGELOG.md обновлен (автоматически через melos)
- [ ] Нет TODO/FIXME в коде
- [ ] Backward compatibility проверена (или BREAKING CHANGE документирован)

### Полезные ссылки

- Проект на GitHub: https://github.com/unger1984/trackit
- Pub.dev: 
  - https://pub.dev/packages/trackit
  - https://pub.dev/packages/trackit_console
  - https://pub.dev/packages/trackit_history
- Conventional Commits: https://www.conventionalcommits.org/
- Semantic Versioning: https://semver.org/
- Melos документация: https://melos.invertase.dev/
- FVM документация: https://fvm.app/
