class HospitalMapData {
  final String name;
  final String address;
  final double distance;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? website;
  final int priorityScore;
  final List<String> matchReasons;

  HospitalMapData({
    required this.name,
    required this.address,
    required this.distance,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.website,
    required this.priorityScore,
    required this.matchReasons,
  });

  factory HospitalMapData.fromJson(Map<String, dynamic> json) {
    return HospitalMapData(
      name: json['name'] as String,
      address: json['address'] as String,
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      priorityScore: json['priority_score'] as int,
      matchReasons: (json['match_reasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'website': website,
      'priority_score': priorityScore,
      'match_reasons': matchReasons,
    };
  }

  HospitalMapData copyWith({
    String? name,
    String? address,
    double? distance,
    double? latitude,
    double? longitude,
    String? phone,
    String? website,
    int? priorityScore,
    List<String>? matchReasons,
  }) {
    return HospitalMapData(
      name: name ?? this.name,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      priorityScore: priorityScore ?? this.priorityScore,
      matchReasons: matchReasons ?? this.matchReasons,
    );
  }
}
