import 'package:example/di.dart';
import 'package:flutter/material.dart';

/// Inherited Dependency Injection Widget
class InheritedDI extends InheritedWidget {
  final DI dependencies;

  const InheritedDI({
    super.key,
    required super.child,
    required this.dependencies,
  });

  static DI? maybeOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<InheritedDI>()?.widget
              as InheritedDI?)
          ?.dependencies;

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a InheritedDependencies of the exact type',
        'out_of_scope',
      );

  /// The state from the closest instance of this class
  /// that encloses the given context.
  static DI of(BuildContext context) =>
      maybeOf(context) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
