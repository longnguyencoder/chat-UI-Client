import 'package:flutter/material.dart';
import '../../models/attraction_model.dart';

/// Widget hiển thị chip địa điểm trong danh sách ngang
class AttractionChip extends StatelessWidget {
  final Attraction attraction;
  final bool isSelected;
  final bool isInItinerary;
  final VoidCallback onTap;

  const AttractionChip({
    super.key,
    required this.attraction,
    required this.isSelected,
    required this.isInItinerary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          avatar: Icon(
            isInItinerary ? Icons.schedule : Icons.location_on,
            size: 16,
            color: isSelected
                ? Colors.white
                : isInItinerary
                    ? Colors.orange.shade700
                    : Colors.red.shade700,
          ),
          label: Text(
            attraction.name,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
          backgroundColor: isSelected
              ? Colors.green.shade600
              : isInItinerary
                  ? Colors.orange.shade100
                  : Colors.grey.shade100,
        ),
      ),
    );
  }
} 