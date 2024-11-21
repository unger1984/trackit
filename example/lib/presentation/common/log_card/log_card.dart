import 'package:example/presentation/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:trackit/trackit.dart';

@immutable
class LogCard extends StatefulWidget {
  final LogEvent event;
  const LogCard({super.key, required this.event});

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black;
    Color color = Colors.white;
    switch (widget.event.level) {
      case LogLevelTrace():
        color = Color.fromARGB(255, 189, 189, 189);
        break;
      case LogLevelDebug():
        color = Color(0xFF56FEA8);
        break;
      case LogLevelInfo():
        color = Color.fromARGB(255, 66, 165, 245);
        break;
      case LogLevelWarn():
        color = Color.fromARGB(255, 239, 108, 0);
        break;
      case LogLevelError():
        color = Color.fromARGB(255, 239, 83, 80);
        break;
      case LogLevelFatal():
        color = Color.fromARGB(255, 198, 40, 40);
        break;
    }

    final message = widget.event.message?.toString();
    final exception = widget.event.exception?.toString();
    final stackTrace = widget.event.stackTrace?.toString();

    final sb = StringBuffer();
    sb.write(
        '[${widget.event.level.toString().toUpperCase().characters.getRange(0, 1)}] ${(widget.event.time.millisecondsSinceEpoch ~/ 1000)} (${widget.event.title}): ');
    message?.split('\n').forEach((line) => sb.writeln(line));
    exception?.split('\n').forEach((line) => sb.writeln(line));
    stackTrace?.split('\n').forEach((line) => sb.writeln(line));
    final logString = sb.toString().trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
          // color: color,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              logString,
                              maxLines: _expanded ? null : 2,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (logString.length > 150)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => setState(() {
                      _expanded = !_expanded;
                    }),
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppTheme.txtSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
