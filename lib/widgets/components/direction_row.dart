import 'package:flutter/material.dart';

class DirectionRow extends StatelessWidget {

  final step;
  final direction;

  DirectionRow({@required this.direction, this.step});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        '$step. $direction',
        style: textTheme.caption,
      ),
    );
  }
}
