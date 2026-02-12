# Cursor Rules для TrackIt

Эта директория содержит правила и руководства для AI-ассистента Cursor при работе с проектом TrackIt.

## Структура

```
.cursor/rules/
├── README.md                    # Этот файл
├── AGENTS.md                    # Общие правила проекта
└── packages/
    ├── trackit.md              # Правила для core пакета
    ├── trackit_console.md      # Правила для console модуля
    └── trackit_history.md      # Правила для history модуля
```

## Файлы правил

### AGENTS.md
Общие правила для всего проекта:
- Инструменты разработки (FVM, Melos)
- Стиль кодирования (Dart 3.6+, именование, структура)
- Архитектурные паттерны (Singleton, Factory, Stream/Observer)
- Управление зависимостями
- Тестирование
- Стиль коммитов (Conventional Commits)
- Версионирование и публикация
- Быстрая справка (Cheat Sheet)

### packages/trackit.md
Правила для базового пакета `trackit`:
- Singleton pattern для `Trackit`
- Stream-based архитектура
- Factory методы
- Структура классов (LogEvent, LogLevel, TrackitInstance)
- API дизайн
- Тестирование
- Best practices и антипаттерны

### packages/trackit_console.md
Правила для пакета `trackit_console`:
- Event Handler pattern
- Strategy pattern для форматтеров
- Platform-specific реализация (conditional imports)
- Типы форматтеров (Simple, JSON, Pattern)
- Кастомизация
- Создание кастомных форматтеров

### packages/trackit_history.md
Правила для пакета `trackit_history`:
- Singleton для хранилища
- FIFO queue pattern
- Управление памятью
- Интеграция с UI
- Экспорт истории
- Производительность

## Как это работает

Cursor AI автоматически читает файлы из `.cursor/rules/` при работе с проектом:

1. **AGENTS.md** применяется ко всему проекту
2. **packages/*.md** применяются при работе с соответствующими пакетами

AI использует эти правила для:
- Генерации кода в правильном стиле
- Предложения архитектурных решений
- Помощи с рефакторингом
- Написания тестов
- Создания документации

## Обновление правил

Правила следует обновлять при:
- Изменении архитектуры проекта
- Добавлении новых паттернов
- Обновлении инструментов (FVM, Melos, Dart SDK)
- Изменении процессов разработки

## Ключевые требования

### ✅ ОБЯЗАТЕЛЬНО

- Использовать FVM для Flutter SDK
- Использовать Melos для всех команд
- Версионирование только через `melos version`
- Публикация только через `melos publish`
- Conventional Commits для всех коммитов
- Линтер и тесты должны проходить перед коммитом

### ❌ ЗАПРЕЩЕНО

- Изменять версии вручную в pubspec.yaml
- Использовать `flutter` напрямую (только `fvm flutter`)
- Коммитить код с ошибками линтера
- Публиковать без `--dry-run`
- Игнорировать падающие тесты

## Быстрый старт

```bash
# Клонирование и настройка
git clone https://github.com/unger1984/trackit.git
cd trackit
fvm install
melos bootstrap

# Разработка
melos run lint:all
melos run test

# Релиз (только maintainers)
melos version
git push origin main --tags
melos publish --dry-run
melos publish --no-dry-run
```

## Ссылки

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Melos](https://melos.invertase.dev/)
- [FVM](https://fvm.app/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

*Эти правила помогают поддерживать согласованность кода и процессов разработки в проекте TrackIt.*
