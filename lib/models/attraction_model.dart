import 'package:latlong2/latlong.dart';

class Attraction {
  final String id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final LatLng location;
  final String category;
  final List<String> tags;
  final double? price;
  final String? openingHours;
  final String? phoneNumber;
  final String? website;
  final List<String> aliases;

  Attraction({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.location,
    this.category = 'tourist_attraction',
    this.tags = const [],
    this.price,
    this.openingHours,
    this.phoneNumber,
    this.website,
    this.aliases = const[]
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      location: LatLng(
        (json['latitude'] ?? 0.0).toDouble(),
        (json['longitude'] ?? 0.0).toDouble(),
      ),
      category: json['category'] ?? 'tourist_attraction',
      tags: List<String>.from(json['tags'] ?? []),
      price: json['price']?.toDouble(),
      openingHours: json['opening_hours'],
      phoneNumber: json['phone'],
      website: json['website'],
      aliases: List<String>.from(json['aliases'] ?? [])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'category': category,
      'tags': tags,
      'price': price,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'website': website,
      'aliases': aliases
    };
  }

  Attraction copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    String? imageUrl,
    double? rating,
    LatLng? location,
    String? category,
    List<String>? tags,
    double? price,
    String? openingHours,
    String? phoneNumber,
    String? website,
    List<String>? aliases
  }) {
    return Attraction(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      price: price ?? this.price,
      openingHours: openingHours ?? this.openingHours,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      aliases: aliases ?? this.aliases
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Attraction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Attraction(id: $id, name: $name, address: $address)';
  }
}
