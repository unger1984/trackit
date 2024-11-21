import 'package:example/presentation/common/log_card/log_card.dart';
import 'package:flutter/material.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

@immutable
class LogPreview extends StatelessWidget {
  const LogPreview({super.key});

  @override
  Widget build(BuildContext context) {
    const MediaQueryData mediaQuery = MediaQueryData(
      size: Size(800, 896),
      padding: EdgeInsets.only(top: 44, bottom: 34),
      devicePixelRatio: 2,
    );
    return Flexible(
      flex: 5,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Builder(
          builder: (context) {
            final device = MediaQuery(
              data: mediaQuery,
              child: Container(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height,
                alignment: Alignment.center,
                child: Container(
                  color: const Color(0xFF212121),
                  child: StreamBuilder<LogEvent>(
                    stream: Trackit(),
                    builder: (context, state) => CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 40)),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => LogCard(
                                event: TrackitHistory()
                                    .history
                                    .reversed
                                    .elementAt(index)),
                            childCount: TrackitHistory().history.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            return Column(
              children: [
                const Text(
                  'Logs preview',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[700]!, width: 6),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(7),
                    child: device,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
