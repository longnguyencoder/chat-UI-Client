import 'package:flutter/material.dart';
import '../../models/itinerary_item.dart';

/// Widget hiển thị item trong lịch trình
class ItineraryItemCard extends StatelessWidget {
  final ItineraryItem item;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const ItineraryItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade600,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(item.attraction.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${TimeOfDay.fromDateTime(item.visitTime).format(context)} - ${item.estimatedDuration.inHours}h ${item.estimatedDuration.inMinutes % 60}m',
              style: const TextStyle(fontSize: 12),
            ),
            if (item.notes.isNotEmpty)
              Text(
                item.notes,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 20),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }
} 