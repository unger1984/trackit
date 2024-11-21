import 'package:example/presentation/app/app_theme.dart';
import 'package:example/presentation/common/log_card/log_card.dart';
import 'package:flutter/material.dart';
import 'package:trackit/trackit.dart';
import 'package:trackit_history/trackit_history.dart';

@immutable
class TrackitScreen extends StatelessWidget {
  const TrackitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trackit Log History',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.txtMain),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ColoredBox(
        color: Color(0xFF212121),
        child: StreamBuilder<LogEvent>(
          stream: Trackit(),
          builder: (context, state) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => LogCard(
                      event:
                          TrackitHistory().history.reversed.elementAt(index)),
                  childCount: TrackitHistory().history.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
