import 'package:flutter/material.dart';

/// Widget hiển thị item trong chú thích màu sắc
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool showNumber;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: showNumber
              ? Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
} 