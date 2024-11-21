import 'package:flutter/material.dart';

class AppPreview extends StatelessWidget {
  final MediaQueryData mq;
  final Widget child;

  const AppPreview({
    required this.mq,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Builder(builder: (context) {
          final device = MediaQuery(
            data: mq,
            child: Container(
              width: mq.size.width,
              height: mq.size.height,
              alignment: Alignment.center,
              child: child,
            ),
          );
          return Column(
            children: [
              const Text(
                'Application',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 12)),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(38.5),
                  child: device,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
