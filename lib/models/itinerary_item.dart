import 'package:latlong2/latlong.dart';
import 'attraction_model.dart';

class ItineraryItem {
  final int? id;
  final int? itineraryId;
  final Attraction attraction;
  final DateTime visitTime;
  final Duration estimatedDuration;
  final String notes;
  final DateTime? createdAt;

  ItineraryItem({
    this.id,
    this.itineraryId,
    required this.attraction,
    required this.visitTime,
    this.estimatedDuration = const Duration(hours: 2),
    this.notes = '',
    this.createdAt,
  });

  ItineraryItem copyWith({
    int? id,
    int? itineraryId,
    Attraction? attraction,
    DateTime? visitTime,
    Duration? estimatedDuration,
    String? notes,
    DateTime? createdAt,
  }) {
    return ItineraryItem(
      id: id ?? this.id,
      itineraryId: itineraryId ?? this.itineraryId,
      attraction: attraction ?? this.attraction,
      visitTime: visitTime ?? this.visitTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'],
      itineraryId: json['itinerary_id'],
      attraction: json['attraction'] != null 
          ? Attraction.fromJson(json['attraction']) 
          : Attraction(
              id: '',
              name: 'Unknown',
              address: '',
              description: '',
              imageUrl: '',
              rating: 0.0,
              location: LatLng(0, 0),
            ),
      visitTime: json['visit_time'] != null 
          ? DateTime.parse(json['visit_time']) 
          : DateTime.now(),
      estimatedDuration: json['estimated_duration'] != null 
          ? Duration(minutes: json['estimated_duration']) 
          : const Duration(hours: 2),
      notes: json['notes'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itinerary_id': itineraryId,
      'attraction': attraction.toJson(),
      'visit_time': visitTime.toIso8601String(),
      'estimated_duration': estimatedDuration.inMinutes,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItineraryItem && 
           other.id == id && 
           other.itineraryId == itineraryId &&
           other.attraction == attraction &&
           other.visitTime == visitTime;
  }

  @override
  int get hashCode {
    return Object.hash(id, itineraryId, attraction, visitTime);
  }

  @override
  String toString() {
    return 'ItineraryItem(id: $id, itineraryId: $itineraryId, attraction: ${attraction.name}, visitTime: $visitTime, duration: ${estimatedDuration.inMinutes}min, notes: $notes)';
  }
}
