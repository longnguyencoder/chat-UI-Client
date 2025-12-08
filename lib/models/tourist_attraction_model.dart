import 'package:latlong2/latlong.dart';

class TouristAttraction {
  final String id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final LatLng location;

  TouristAttraction({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.location,
  });
}
