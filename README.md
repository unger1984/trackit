<p align="center">
    <a href="https://github.com/unger1984/trackit">
        <img src="https://raw.githubusercontent.com/unger1984/trackit/refs/heads/main/assets/logo.svg" width="150">
    </a>
</p>
<p align="center">
Lightweight modular logger for Dart and Flutter
</p>

# TrackIt

Trackit is a modular lightweight logger for Dart and Flutter applications. To achieve the functionality you need, you<
can use ready-made modules described below, or write similar modules manually.

The Trackit logging system is designed with the DRY and KISS principles in mind. By adding only the packages you need
to dependencies, you can eliminate unused code and functionality as much as possible.

For example, to output and format logs to the console or other, you can only connect the `trackit_console` package.
If you want to store the latest log entries in memory for further processing (displaying on the screen,
transferring from the tester to the developer, etc.), use the `trackit_history` package.

## Packages
Trackit is designed as a lightweight logger with the ability to expand and fully customize.
Below is a list of ready-made modules that can be used together with Trackit to obtain the necessary functionality.
You can use them as is, or expand them if necessary to suit your needs.

| Package                                                                                    | Version                                                                                                                | Description                                                                                                                                                                                                                               | 
|--------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [trackit](https://github.com/unger1984/trackit/tree/main/packages/trackit)                 | [![Pub](https://img.shields.io/pub/v/trackit.svg?style=flat-square)](https://pub.dev/packages/trackit)                 | The basic core of the logger, used as a dependency of all its extensions.<br>It cannot accumulate and output logs. In its pure form it should be used only as a base for extensions.                                                      |
| [trackit_console](https://github.com/unger1984/trackit/tree/main/packages/trackit_console) | [![Pub](https://img.shields.io/pub/v/trackit_console.svg?style=flat-square)](https://pub.dev/packages/trackit_console) | Logger extension used to format and output logger events to the console.<br>.                                                                                                                                                             |
| [trackit_history](https://github.com/unger1984/trackit/tree/main/packages/trackit_history) | [![Pub](https://img.shields.io/pub/v/trackit_history.svg?style=flat-square)](https://pub.dev/packages/trackit_history) | Trackit logger extension for storing logs in memory.                                                                                                                                                                                      |

## Table of contents

- [Packages](#packages)
- [Motivation](#motivation)
- [How to use](#how-to-use)
- [Full example](#full-example)
- [RoadMap](#roadmap)

## Motivation

The logging system is an auxiliary module. It should not be a combine and be able to do everything. The basic logger
module should only be able to generate an event and send it further.

To display, process and collect logger events, it is necessary to use separate modules, which are necessary in each specific case.

Each application has its own requirements for log processing. Some output them to the console, some send them to the
error collection system (Firebase Crashlytics, Sentry, etc), some display them in the interface, and perhaps all at the same time!


## How to use

* `trackit` - [README](packages/trackit/README.md)
* `trackit_console` - [README](packages/trackit_console/README.md)
* `trackit_history` - [README](packages/trackit_history/README.md)

## Full example

The example code demonstrating the capabilities of the Trackit logger ecosystem can be viewed in the [example](example)

<img src="https://raw.githubusercontent.com/unger1984/trackit/refs/heads/main/assets/screen3.png" >

## RoadMap

* ✅ Create full example app
* ✅ Test it in real projects!
* Write docs (and this README) (How use it with routing, blocs etc...)
* ❗️ Create contributing rules
* Add package for work with [Dio](https://pub.dev/packages/dio)
* ... any more
* Publish 1.0.0 version)
