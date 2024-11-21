import 'package:example/presentation/app/app_theme.dart';
import 'package:flutter/material.dart';

@immutable
class LoadingScreen extends StatelessWidget {
  final String message;
  final int progress;
  const LoadingScreen({
    super.key,
    required this.message,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.accent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Trackit\nDemo Application',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/logo.png', semanticLabel: 'Trackit'),
            SizedBox(height: 20),
            Text(
              'Loading: $progress%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
