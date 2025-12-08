import 'itinerary_item.dart';

class Itinerary {
  final int id;
  final int userId;
  final String selectedDate;
  final String title;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ItineraryItem> items;

  Itinerary({
    required this.id,
    required this.userId,
    required this.selectedDate,
    required this.title,
    required this.notes,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      userId: json['user_id'],
      selectedDate: json['selected_date'],
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      items: (json['items'] as List<dynamic>?)?.map((e) => ItineraryItem.fromJson(e)).toList() ?? [],
    );
  }
} 