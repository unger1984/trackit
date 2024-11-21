import 'package:example/presentation/app/app_router.dart';
import 'package:example/presentation/app/app_theme.dart';
import 'package:flutter/material.dart';

@immutable
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onTry;
  const ErrorView({super.key, required this.message, required this.onTry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: onTry,
                  child: Text(
                    'Try again',
                    style: TextStyle(color: AppTheme.bgMain),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.trackit),
                  child: Text(
                    'See logs',
                    style: TextStyle(color: AppTheme.bgMain),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
