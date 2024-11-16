# TrackIt

!!! UNDER CONSTRUCTION !!!

## Packages
Trackit is designed as a lightweight logger with the ability to expand and fully customize.<br>
Below is a list of ready-made modules that can be used together with Trackit to obtain the necessary functionality.<br>
You can use them as is, or expand them if necessary to suit your needs.

| Package                                                                                | Version                                                                                                            | Description                                                                                                                                                                          | 
|----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [trackit](https://github.com/unger1984/trackit/tree/main/packages/trackit)             | [![Pub](https://img.shields.io/pub/v/trackit.svg?style=flat-square)](https://pub.dev/packages/trackit)             | The basic core of the logger, used as a dependency of all its extensions.<br>It cannot accumulate and output logs. In its pure form it should be used only as a base for extensions. |
| [trackit_print](https://github.com/unger1984/trackit/tree/main/packages/trackit_print) | [![Pub](https://img.shields.io/pub/v/trackit_print.svg?style=flat-square)](https://pub.dev/packages/trackit_print) | Logger extension for formatting and outputting logs to the console.<br>Can colorize output logs using the [ansycolor](https://github.com/google/ansicolor-dart) library.             |


```shell
fvm dart run melos bs
```