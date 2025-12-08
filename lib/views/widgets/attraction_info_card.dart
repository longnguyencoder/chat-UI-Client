import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/attraction_model.dart';

/// Widget hiển thị thông tin địa điểm
class AttractionInfoCard extends StatelessWidget {
  final Attraction attraction;
  final VoidCallback onAddToItinerary;
  final VoidCallback onClose;

  const AttractionInfoCard({
    super.key,
    required this.attraction,
    required this.onAddToItinerary,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            attraction.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        const SizedBox(width: 12),

        // Name, address, rating
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attraction.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                attraction.address,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    ' ${attraction.rating}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (attraction.price != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(attraction.price)}đ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Action buttons
        Column(
          children: [
            ElevatedButton(
              onPressed: onAddToItinerary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 36),
              ),
              child: const Text('Thêm', style: TextStyle(fontSize: 12)),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ],
    );
  }
} 