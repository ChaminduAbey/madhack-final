import 'package:flutter/material.dart';

class PickCountView extends StatelessWidget {
  final int count;
  final Function(int) onCountChanged;
  final String label;

  const PickCountView({
    super.key,
    required this.count,
    required this.onCountChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        IconButton(
          onPressed: count == 0
              ? null
              : () {
                  onCountChanged(count - 1);
                },
          icon: Icon(Icons.remove),
        ),
        Text(count.toString()),
        IconButton(
          onPressed: () {
            onCountChanged(count + 1);
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
