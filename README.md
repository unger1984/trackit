# TrackIt

<p align="center">
    <img src="./logo.svg">
</p>

❗️❗️❗️ **UNDER CONSTRUCTION** ❗️❗️❗️

This packages not published in pub.dev!

Trackit is a modular lightweight logger for Dart and Flutter applications. To achieve the functionality you need, you<br> 
can use ready-made modules described below, or write similar modules manually.

The Trackit logging system is designed with the DRY and KISS principles in mind. By adding only the packages you need<br> 
to dependencies, you can eliminate unused code and functionality as much as possible.

For example, to output logs to the console, you can only connect the `trackit_console` package.<br>
if you want to colorize your console logs, use the package `trackit_color`.<br>
If you want to store the latest log entries in memory for further processing (displaying on the screen,<br>
transferring from the tester to the developer, etc.), use the `trackit_history` package.<br>

## Packages
Trackit is designed as a lightweight logger with the ability to expand and fully customize.<br>
Below is a list of ready-made modules that can be used together with Trackit to obtain the necessary functionality.<br>
You can use them as is, or expand them if necessary to suit your needs.

| Package                                                                                    | Version                                                                                                                | Description                                                                                                                                                                                                                               | 
|--------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [trackit](https://github.com/unger1984/trackit/tree/main/packages/trackit)                 | [![Pub](https://img.shields.io/pub/v/trackit.svg?style=flat-square)](https://pub.dev/packages/trackit)                 | The basic core of the logger, used as a dependency of all its extensions.<br>It cannot accumulate and output logs. In its pure form it should be used only as a base for extensions.                                                      |
| [trackit_color](https://github.com/unger1984/trackit/tree/main/packages/trackit_color)     | [![Pub](https://img.shields.io/pub/v/trackit_color.svg?style=flat-square)](https://pub.dev/packages/trackit_color)     | Logger extension for colorize logs for console output.<br> Can colorize output logs using the [ansycolor](https://github.com/google/ansicolor-dart) library.<br> ❗️ Not work in Intellij IDEA (Android Studio) on MacOS with iOS devices. |
| [trackit_console](https://github.com/unger1984/trackit/tree/main/packages/trackit_console) | [![Pub](https://img.shields.io/pub/v/trackit_console.svg?style=flat-square)](https://pub.dev/packages/trackit_console) | Logger extension for outputting logs to the console.<br>.                                                                                                                                                                                 |
| [trackit_history](https://github.com/unger1984/trackit/tree/main/packages/trackit_history) | [![Pub](https://img.shields.io/pub/v/trackit_history.svg?style=flat-square)](https://pub.dev/packages/trackit_history) | Trackit logger extension for storing logs in memory.                                                                                                                                                                                      |

## Table of contents

- [Packages](#packages)
