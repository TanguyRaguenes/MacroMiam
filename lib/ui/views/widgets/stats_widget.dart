import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final double maxWidth;
  const StatsWidget({super.key, required this.maxWidth });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      width: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('STATS')],
      ),
    );
  }
}
