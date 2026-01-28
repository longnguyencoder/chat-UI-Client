import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mobilev2/models/hospital_map_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalMapCard extends StatefulWidget {
  final List<HospitalMapData> hospitals;

  const HospitalMapCard({
    super.key,
    required this.hospitals,
  });

  @override
  State<HospitalMapCard> createState() => _HospitalMapCardState();
}

class _HospitalMapCardState extends State<HospitalMapCard>
    with SingleTickerProviderStateMixin {
  MapboxMap? _mapboxMap;
  int? _selectedHospitalIndex;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    await _setupMap();
  }

  Future<void> _setupMap() async {
    if (_mapboxMap == null || widget.hospitals.isEmpty) return;

    try {
      // Calculate bounds to fit all hospitals
      double minLat = widget.hospitals.first.latitude;
      double maxLat = widget.hospitals.first.latitude;
      double minLng = widget.hospitals.first.longitude;
      double maxLng = widget.hospitals.first.longitude;

      for (var hospital in widget.hospitals) {
        if (hospital.latitude < minLat) minLat = hospital.latitude;
        if (hospital.latitude > maxLat) maxLat = hospital.latitude;
        if (hospital.longitude < minLng) minLng = hospital.longitude;
        if (hospital.longitude > maxLng) maxLng = hospital.longitude;
      }

      // Add padding to bounds
      final latPadding = (maxLat - minLat) * 0.2;
      final lngPadding = (maxLng - minLng) * 0.2;

      final bounds = CoordinateBounds(
        southwest: Point(
          coordinates: Position(minLng - lngPadding, minLat - latPadding),
        ),
        northeast: Point(
          coordinates: Position(maxLng + lngPadding, maxLat + latPadding),
        ),
        infiniteBounds: false,
      );

      // Fit camera to bounds
      await _mapboxMap!.setBounds(CameraBoundsOptions(
        bounds: bounds,
      ));

      // Add markers for each hospital
      await _addHospitalMarkers();
    } catch (e) {
      print('Error setting up map: $e');
    }
  }

  Future<void> _addHospitalMarkers() async {
    if (_mapboxMap == null) return;

    try {
      final pointAnnotationManager =
          await _mapboxMap!.annotations.createPointAnnotationManager();

      for (int i = 0; i < widget.hospitals.length; i++) {
        final hospital = widget.hospitals[i];
        
        // Create point annotation
        final pointAnnotation = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(hospital.longitude, hospital.latitude),
          ),
          iconSize: 1.2,
          iconImage: 'hospital-marker', // We'll use a default marker
          iconColor: _getMarkerColor(hospital.priorityScore).value,
        );

        await pointAnnotationManager.create(pointAnnotation);
      }
    } catch (e) {
      print('Error adding markers: $e');
    }
  }

  Color _getMarkerColor(int priorityScore) {
    // Gold for high priority (>= 600), Blue for others
    if (priorityScore >= 600) {
      return const Color(0xFFFFD700); // Gold
    } else {
      return const Color(0xFF2196F3); // Blue
    }
  }

  void _onHospitalTap(int index) {
    setState(() {
      _selectedHospitalIndex = index;
    });

    // Animate camera to selected hospital
    final hospital = widget.hospitals[index];
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(hospital.longitude, hospital.latitude),
        ),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 1000, startDelay: 0),
    );
  }

  Future<void> _launchPhone(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWebsite(String? website) async {
    if (website == null || website.isEmpty) return;
    final uri = Uri.parse(website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchDirections(HospitalMapData hospital) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${hospital.latitude},${hospital.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.teal.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.teal.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bệnh viện đề xuất',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.hospitals.length} bệnh viện tìm thấy',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Map
            Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ClipRRect(
                child: MapWidget(
                  key: ValueKey('hospital_map'),
                  onMapCreated: _onMapCreated,
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(
                        widget.hospitals.first.longitude,
                        widget.hospitals.first.latitude,
                      ),
                    ),
                    zoom: 13.0,
                  ),
                  styleUri: MapboxStyles.LIGHT,
                ),
              ),
            ),

            // Hospital List
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: widget.hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = widget.hospitals[index];
                  final isSelected = _selectedHospitalIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onHospitalTap(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hospital name and priority badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      hospital.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  if (hospital.priorityScore >= 600)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.amber.shade400,
                                            Colors.orange.shade400,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'Ưu tiên',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Address & Specialty
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.redAccent.shade200,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      hospital.address,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Metadata Row (Distance & Phone)
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.directions_walk,
                                    '${hospital.distance.toStringAsFixed(1)} km',
                                    Colors.blue,
                                  ),
                                  if (hospital.phone != null && hospital.phone!.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    _buildInfoChip(
                                      Icons.phone_in_talk,
                                      hospital.phone!,
                                      Colors.green,
                                    ),
                                  ],
                                ],
                              ),

                              // Match reasons
                              if (hospital.matchReasons.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: hospital.matchReasons.map((reason) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        reason,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],

                                  // Action buttons
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _MainActionButton(
                                          icon: Icons.navigation_rounded,
                                          label: 'Chỉ đường',
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                          ),
                                          onTap: () => _launchDirections(hospital),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (hospital.website != null && hospital.website!.isNotEmpty)
                                        Expanded(
                                          flex: 2,
                                          child: _MainActionButton(
                                            icon: hospital.website!.contains('booking') 
                                                ? Icons.calendar_month 
                                                : Icons.language,
                                            label: hospital.website!.contains('booking') 
                                                ? 'Đặt khám' 
                                                : 'Website',
                                            gradient: LinearGradient(
                                              colors: [Colors.teal.shade400, Colors.teal.shade700],
                                            ),
                                            onTap: () => _launchWebsite(hospital.website),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          flex: 1,
                                          child: _SecondaryActionButton(
                                            icon: Icons.phone,
                                            onTap: () => _launchPhone(hospital.phone),
                                          ),
                                        ),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _MainActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Icon(icon, size: 18, color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}
