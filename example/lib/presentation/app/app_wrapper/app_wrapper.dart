import 'package:example/presentation/app/app_wrapper/app_preview.dart';
import 'package:example/presentation/app/app_wrapper/log_preview.dart';
import 'package:flutter/material.dart';

@immutable
class AppWrapper extends StatelessWidget {
  final Widget child;
  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: add kIsWeb
    if (MediaQuery.of(context).size.width > 600) {
      const MediaQueryData mq = MediaQueryData(
        size: Size(414, 896),
        padding: EdgeInsets.only(top: 44, bottom: 34),
        devicePixelRatio: 2,
      );

      return Material(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xff53B175)),
              child: const Text(
                'Interactive Demo of the capabilities of the Trackit logger',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LogPreview(),
                  const SizedBox(width: 20),
                  AppPreview(mq: mq, child: child),
                  const SizedBox(width: 60),
                  // const _TrackitAboutSection(mq: mq),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return child;
  }
}
