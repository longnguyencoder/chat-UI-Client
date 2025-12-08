import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../models/attraction_model.dart';
import '../../models/itinerary_item.dart';
import '../../services/home/attraction_service.dart';

class MapViewModel extends ChangeNotifier {
  // Services
  final AttractionService _attractionService = AttractionService();

  // Mapbox access token
  final String mapboxAccessToken = dotenv.env["MAPBOX_ACCESS_TOKEN"]!;

  // Mapbox style URL
  final String mapboxStyleUrl = dotenv.env["MAPBOX_STYLE_URL_V2"]!;

  // Mapbox directions API URL
  final String directionsApiUrl = dotenv.env["DIRECTIONS_API_URL_V2"]!;

  // Trạng thái
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Vị trí hiện tại
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // Vị trí ban đầu (mặc định: Hồ Chí Minh)
  LatLng _initialPosition = LatLng(10.7769, 106.7009);
  LatLng get initialPosition => _initialPosition;

  // Nội dung tin nhắn
  List<String> _places = [];
  List<String> get places => _places;

  // ID cuộc trò chuyện
  int _conversationId = 0;
  int get conversationId => _conversationId;

  // Ngôn ngữ của bot message
  String _language = '';
  String get language => _language;

  // Danh sách địa điểm du lịch
  List<Attraction> _detectedAttractions = [];
  List<Attraction> get detectedAttractions => _detectedAttractions;

  // Địa điểm được chọn
  Attraction? _selectedAttraction;
  Attraction? get selectedAttraction => _selectedAttraction;

  // Markers trên bản đồ
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  // Polylines trên bản đồ
  List<Polyline> _polylines = [];
  List<Polyline> get polylines => _polylines;

  // Lịch trình theo ngày
  final Map<DateTime, List<ItineraryItem>> _dailyItineraries = {};
  Map<DateTime, List<ItineraryItem>> get dailyItineraries => _dailyItineraries;

  // Ngày được chọn
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // Lịch trình của ngày được chọn
  List<ItineraryItem> get todayItinerary {
    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return _dailyItineraries[dateKey] ?? [];
  }

  // Controller cho MapboxMap
  MapController? _mapController;
  MapController? get mapController => _mapController;

  bool _isMapControllerActive = true;
  // Phương thức để kiểm tra và đặt lại controller
  void setMapControllerActive(bool isActive) {
    _isMapControllerActive = isActive;
    if (!isActive && _mapController != null) {
      // Đặt lại controller khi widget bị hủy
      _mapController = null;
    }
  }

  // Khởi tạo
  Future<void> initialize(List<String> places, int conversationId, String language) async {
    // Decode Unicode cho places trước khi gán
    _places = places.map((place) => _decodeUnicode(place)).toList();
    print("🔍 Decoded places: $_places");
    
    _conversationId = conversationId;
    _language = language;
    _isLoading = true;
    notifyListeners();

    // Tạo MapController
    _mapController = MapController();

    // Lấy vị trí hiện tại
    await _getCurrentLocationAndSetInitial();

    // Phát hiện địa điểm từ nội dung tin nhắn
    await _detectAttractionsFromMessage();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _getCurrentLocationAndSetInitial() async{
    try{
      print('🔍 Đang lấy vị trí hiện tại...');

      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Quyền truy cập vị trí bị từ chối');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Quyền truy cập vị trí bị từ chối vĩnh viễn');
        return;
      }

      /*
      // Lấy vị trí hiện tại với độ chính xác cao
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
       */
      // Sử dụng LocationSettings mới
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10)
      );

      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (_currentPosition != null) {
        _initialPosition = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        print('✅ Đã lấy vị trí hiện tại: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
        print('📍 Vị trí ban đầu được cập nhật: $_initialPosition');
      } else {
        print('⚠️ Không thể lấy vị trí hiện tại, sử dụng vị trí mặc định');
      }
    }catch (e) {
      print('❌ Lỗi khi lấy vị trí hiện tại: $e');
      print('📍 Sử dụng vị trí mặc định: $_initialPosition');
    }
  }

  // Phát hiện địa điểm từ nội dung tin nhắn
  Future<void> _detectAttractionsFromMessage() async {
    try {
      if (_places.isNotEmpty) {        
        _detectedAttractions = await _attractionService
            .detectAttractionsFromMessage(_places, language: _language);
        print("ℹ️ _detectAttractionsFromMessage: get location from places with language: $_language");
      } else {
        // Nếu không có places, lấy địa điểm gần đó
        if (_currentPosition != null) {
          LatLng currentLatLng = LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
          _detectedAttractions = await _attractionService.getNearbyAttractions(
            currentLatLng,
          );
          print("ℹ️ _detectAttractionsFromMessage: nothing places get getNearbyAttractions");
        } else {
          // Lấy tất cả địa điểm
          print("ℹ️ _detectAttractionsFromMessage: get all location");
          _detectedAttractions = await _attractionService.getAllAttractions();
        }
      }

      // Tạo markers cho các địa điểm
      _updateMarkers();
    } catch (e) {
      print('Error detecting attractions: $e');
      // Fallback: lấy tất cả địa điểm
      _detectedAttractions = await _attractionService.getAllAttractions();
      _updateMarkers();
    }
  }

  // Cập nhật markers
  void _updateMarkers() {
    _markers = [];

    // Thêm marker cho vị trí hiện tại
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          width: 40,
          height: 40,
          builder:
              (context) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),
        ),
      );
    }

    // Lấy danh sách các địa điểm trong lịch trình của ngày hôm nay
    final itineraryItems = todayItinerary;
    final itineraryAttractionIds = itineraryItems.map((item) => item.attraction.id).toSet();

    // Tạo map để lưu trữ thứ tự của các địa điểm trong lịch trình
    final Map<String, int> attractionOrder = {};
    for (int i = 0; i < itineraryItems.length; i++) {
      attractionOrder[itineraryItems[i].attraction.id] = i + 1;
    }

    // Thêm markers cho các địa điểm
    for (var attraction in _detectedAttractions) {
      final isSelected = _selectedAttraction?.id == attraction.id;
      final isInItinerary = itineraryAttractionIds.contains(attraction.id);
      final orderNumber = isInItinerary ? attractionOrder[attraction.id] : null;

      _markers.add(
        Marker(
          point: attraction.location,
          width: 40,
          height: 40,
          builder: (context) => GestureDetector(
            onTap: () => selectAttraction(attraction),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green
                    : isInItinerary
                    ? Colors.orange
                    : Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: isInItinerary
                  ? Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: isSelected ? 20 : 16,
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$orderNumber',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Icon(
                Icons.location_on,
                color: Colors.white,
                size: isSelected ? 24 : 20,
              ),
            ),
          ),
        ),
      );
    }

    // Thêm markers cho các địa điểm trong lịch trình mà không có trong kết quả tìm kiếm
    final searchAttractionIds = _detectedAttractions.map((a) => a.id).toSet();
    for (var item in itineraryItems) {
      // Nếu địa điểm đã có trong kết quả tìm kiếm thì bỏ qua
      if (searchAttractionIds.contains(item.attraction.id)) continue;

      final isSelected = _selectedAttraction?.id == item.attraction.id;
      final orderNumber = attractionOrder[item.attraction.id];

      _markers.add(
        Marker(
          point: item.attraction.location,
          width: 40,
          height: 40,
          builder: (context) => GestureDetector(
            onTap: () => selectAttraction(item.attraction),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: isSelected ? 20 : 16,
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$orderNumber',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    notifyListeners();
  }

  // Kiểm tra địa điểm có trong lịch trình hôm nay không
  bool _isAttractionInTodayItinerary(Attraction attraction) {
    return todayItinerary.any((item) => item.attraction.id == attraction.id);
  }

  // Chọn địa điểm
  Future<void> selectAttraction(Attraction attraction) async {
    _selectedAttraction = attraction;
    _updateMarkers();

    // Di chuyển bản đồ đến địa điểm được chọn
    if (_mapController != null && _isMapControllerActive) {
      try {
        _mapController!.move(attraction.location, 15.0);
      } catch (e) {
        print('❌ Lỗi khi di chuyển bản đồ: $e');
        _mapController = null;
      }
    }

    // Vẽ đường đi từ vị trí hiện tại đến địa điểm được chọn
    if (_currentPosition != null) {
      await _getDirections(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        attraction.location,
      );
    }

    notifyListeners();
  }

  // Lấy chỉ đường từ Mapbox API
  Future<void> _getDirections(LatLng start, LatLng end) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$directionsApiUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$mapboxAccessToken',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];

          if (geometry != null && geometry['coordinates'] != null) {
            final List<dynamic> coords = geometry['coordinates'];
            final List<LatLng> points =
                coords.map((coord) {
                  return LatLng(coord[1], coord[0]);
                }).toList();

            _polylines = [
              Polyline(points: points, color: Colors.blue, strokeWidth: 4.0),
            ];

            notifyListeners();
          }
        }
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
  }

  // VẼ ĐƯỜNG NỐI CÁC ĐỊA ĐIỂM TRONG LỊCH TRÌNH
  Future<void> _drawItineraryRoute() async {
    try {
      final itinerary = todayItinerary;
      if (itinerary.length < 2) {
        // Nếu ít hơn 2 địa điểm, chỉ vẽ từ vị trí hiện tại đến địa điểm đầu tiên
        if (itinerary.length == 1 && _currentPosition != null) {
          await _getDirections(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            itinerary.first.attraction.location,
          );
        }
        return;
      }

      print('🗺️ Đang vẽ tuyến đường cho ${itinerary.length} địa điểm...');

      List<Polyline> itineraryPolylines = [];

      // Tạo danh sách các điểm theo thứ tự thời gian
      List<LatLng> waypoints = [];

      // Thêm vị trí hiện tại làm điểm bắt đầu (nếu có)
      if (_currentPosition != null) {
        waypoints.add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
      }

      // Thêm các địa điểm trong lịch trình theo thứ tự thời gian
      for (var item in itinerary) {
        waypoints.add(item.attraction.location);
      }

      // Vẽ đường nối từng cặp điểm liên tiếp
      for (int i = 0; i < waypoints.length - 1; i++) {
        final start = waypoints[i];
        final end = waypoints[i + 1];

        try {
          final response = await http.get(
            Uri.parse(
              '$directionsApiUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$mapboxAccessToken',
            ),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data['routes'] != null && data['routes'].isNotEmpty) {
              final route = data['routes'][0];
              final geometry = route['geometry'];

              if (geometry != null && geometry['coordinates'] != null) {
                final List<dynamic> coords = geometry['coordinates'];
                final List<LatLng> points = coords.map((coord) {
                  return LatLng(coord[1], coord[0]);
                }).toList();

                // Màu sắc khác nhau cho từng đoạn đường
                Color segmentColor;
                if (i == 0 && _currentPosition != null) {
                  segmentColor = Colors.blue; // Từ vị trí hiện tại đến điểm đầu tiên
                } else {
                  segmentColor = Colors.green; // Giữa các điểm trong lịch trình
                }

                itineraryPolylines.add(
                  Polyline(
                    points: points,
                    color: segmentColor,
                    strokeWidth: 4.0,
                  ),
                );
              }
            }
          }
        } catch (e) {
          print('❌ Lỗi vẽ đường đoạn ${i + 1}: $e');
        }

        // Delay nhỏ để tránh spam API
        await Future.delayed(Duration(milliseconds: 200));
      }

      _polylines = itineraryPolylines;
      print('✅ Đã vẽ ${itineraryPolylines.length} đoạn đường');
      notifyListeners();

    } catch (e) {
      print('❌ Lỗi vẽ tuyến đường lịch trình: $e');
    }
  }

  // Khởi tạo MapController
  void onMapCreated() {
    _mapController ??= MapController();
    _isMapControllerActive = true;
    notifyListeners();
  }

  // Chọn ngày
  void selectDate(DateTime date) {
    _selectedDate = date;
    // Cập nhật markers để hiển thị địa điểm trong lịch trình ngày được chọn
    _updateMarkers();
    // Vẽ lại đường đi cho ngày được chọn
    _drawItineraryRoute();
    notifyListeners();
  }

  // Thêm vào lịch trình
  void addToItinerary(
    Attraction attraction, {
    required DateTime date,
    required TimeOfDay time,
    String notes = '',
    Duration? estimatedDuration,
  }) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final visitTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Tạo ItineraryItem với thông tin đầy đủ
    final item = ItineraryItem(
      attraction: attraction,
      visitTime: visitTime,
      estimatedDuration: estimatedDuration ?? const Duration(hours: 2),
      notes: notes,
      createdAt: DateTime.now(),
    );

    if (_dailyItineraries.containsKey(dateKey)) {
      _dailyItineraries[dateKey]!.add(item);
      // Sắp xếp theo thời gian
      _dailyItineraries[dateKey]!.sort(
        (a, b) => a.visitTime.compareTo(b.visitTime),
      );
    } else {
      _dailyItineraries[dateKey] = [item];
    }

    // Cập nhật markers
    _updateMarkers();

    // VẼ ĐƯỜNG NỐI CÁC ĐỊA ĐIỂM TRONG LỊCH TRÌNH
    if (dateKey == DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)) {
      _drawItineraryRoute();
    }

    // In ra thông tin chi tiết
    print('✅ ĐÃ THÊM VÀO LỊCH TRÌNH:');
    print('📍 Địa điểm: ${attraction.name}');
    print('📅 Ngày: ${date.day}/${date.month}/${date.year}');
    print('⏰ Thời gian: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
    print('⏱️ Thời lượng: ${estimatedDuration?.inHours ?? 2} giờ');
    if (notes.isNotEmpty) {
      print('📝 Ghi chú: $notes');
    }
    print('💰 Giá vé: ${attraction.price != null ? '${attraction.price!.toInt()} VND' : 'Miễn phí'}');
    print('⭐ Rating: ${attraction.rating}/5');
    print('📍 Địa chỉ: ${attraction.address}');
    print('📊 Tổng số địa điểm trong ngày: ${_dailyItineraries[dateKey]?.length ?? 0}');
    print('-' * 50);

    notifyListeners();
  }

  // Xóa khỏi lịch trình
  void removeFromItinerary(ItineraryItem item) {
    final dateKey = DateTime(
      item.visitTime.year,
      item.visitTime.month,
      item.visitTime.day,
    );

    if (_dailyItineraries.containsKey(dateKey)) {
      _dailyItineraries[dateKey]!.remove(item);

      if (_dailyItineraries[dateKey]!.isEmpty) {
        _dailyItineraries.remove(dateKey);
      }

      // Cập nhật markers
      _updateMarkers();

      // Vẽ lại đường đi
      if (dateKey == DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)) {
        _drawItineraryRoute();
      }

      // In ra thông tin chi tiết
      print('❌ ĐÃ XÓA KHỎI LỊCH TRÌNH:');
      print('📍 Địa điểm: ${item.attraction.name}');
      print('📅 Ngày: ${item.visitTime.day}/${item.visitTime.month}/${item.visitTime.year}');
      print('⏰ Thời gian: ${item.visitTime.hour.toString().padLeft(2, '0')}:${item.visitTime.minute.toString().padLeft(2, '0')}');
      print('⏱️ Thời lượng: ${item.estimatedDuration.inHours} giờ');
      if (item.notes.isNotEmpty) {
        print('📝 Ghi chú: ${item.notes}');
      }
      print('💰 Giá vé: ${item.attraction.price != null ? '${item.attraction.price!.toInt()} VND' : 'Miễn phí'}');
      print('⭐ Rating: ${item.attraction.rating}/5');
      print('📍 Địa chỉ: ${item.attraction.address}');
      print('📊 Số địa điểm còn lại trong ngày: ${_dailyItineraries[dateKey]?.length ?? 0}');
      print('-' * 50);

      notifyListeners();
    }
  }

  // Cập nhật item trong lịch trình
  void updateItineraryItem(ItineraryItem oldItem, ItineraryItem newItem) {
    final oldDateKey = DateTime(
      oldItem.visitTime.year,
      oldItem.visitTime.month,
      oldItem.visitTime.day,
    );
    final newDateKey = DateTime(
      newItem.visitTime.year,
      newItem.visitTime.month,
      newItem.visitTime.day,
    );

    // Xóa item cũ
    if (_dailyItineraries.containsKey(oldDateKey)) {
      _dailyItineraries[oldDateKey]!.remove(oldItem);

      if (_dailyItineraries[oldDateKey]!.isEmpty) {
        _dailyItineraries.remove(oldDateKey);
      }
    }

    // Thêm item mới
    if (_dailyItineraries.containsKey(newDateKey)) {
      _dailyItineraries[newDateKey]!.add(newItem);
      _dailyItineraries[newDateKey]!.sort(
        (a, b) => a.visitTime.compareTo(b.visitTime),
      );
    } else {
      _dailyItineraries[newDateKey] = [newItem];
    }

    // Cập nhật markers và vẽ lại đường
    _updateMarkers();
    if (newDateKey == DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)) {
      _drawItineraryRoute();
    }

    // In ra thông tin chi tiết
    print('🔄 ĐÃ CẬP NHẬT LỊCH TRÌNH:');
    print('📍 Địa điểm: ${newItem.attraction.name}');
    print('📅 Ngày cũ: ${oldItem.visitTime.day}/${oldItem.visitTime.month}/${oldItem.visitTime.year}');
    print('📅 Ngày mới: ${newItem.visitTime.day}/${newItem.visitTime.month}/${newItem.visitTime.year}');
    print('⏰ Thời gian cũ: ${oldItem.visitTime.hour.toString().padLeft(2, '0')}:${oldItem.visitTime.minute.toString().padLeft(2, '0')}');
    print('⏰ Thời gian mới: ${newItem.visitTime.hour.toString().padLeft(2, '0')}:${newItem.visitTime.minute.toString().padLeft(2, '0')}');
    print('⏱️ Thời lượng cũ: ${oldItem.estimatedDuration.inHours} giờ');
    print('⏱️ Thời lượng mới: ${newItem.estimatedDuration.inHours} giờ');
    if (oldItem.notes != newItem.notes) {
      print('📝 Ghi chú cũ: ${oldItem.notes}');
      print('📝 Ghi chú mới: ${newItem.notes}');
    }
    print('💰 Giá vé: ${newItem.attraction.price != null ? '${newItem.attraction.price!.toInt()} VND' : 'Miễn phí'}');
    print('⭐ Rating: ${newItem.attraction.rating}/5');
    print('📍 Địa chỉ: ${newItem.attraction.address}');
    print('📊 Số địa điểm trong ngày mới: ${_dailyItineraries[newDateKey]?.length ?? 0}');
    print('-' * 50);

    notifyListeners();
  }

  // Sắp xếp lại lịch trình
  void reorderItinerary(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final dateKey = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (_dailyItineraries.containsKey(dateKey)) {
      final item = _dailyItineraries[dateKey]!.removeAt(oldIndex);
      _dailyItineraries[dateKey]!.insert(newIndex, item);

      // Vẽ lại đường sau khi sắp xếp
      _drawItineraryRoute();

      notifyListeners();
    }
  }

  // Lưu lịch trình
  /*
  Future<bool> saveItinerary() async {
    try {
      // TODO: Implement saving itinerary to backend
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      print('Error saving itinerary: $e');
      return false;
    }
  }
  */

  // Lấy vị trí hiện tại (public method)
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    await _getCurrentLocationAndSetInitial();
    _updateMarkers();

    // Di chuyển bản đồ đến vị trí hiện tại
    if (_currentPosition != null && _mapController != null && _isMapControllerActive) {
      try {
        _mapController!.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15.0,
        );
      } catch (e) {
        print('❌ Lỗi khi di chuyển bản đồ: $e');
        // Đặt lại controller vì nó không còn hợp lệ
        _mapController = null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tìm kiếm địa điểm
  Future<void> searchAttractions(String query, {String language = 'vietnamese'}) async {
    try {
      _isLoading = true;
      notifyListeners();

      LatLng? currentLocation;
      if (_currentPosition != null) {
        currentLocation = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      // Get the search results with language parameter
      List<Attraction> searchResults = await _attractionService.searchAttractions(
        query,
        currentLocation: currentLocation,
        language: language,
      );

      // Create a map of attraction IDs that are in the itinerary across all dates
      final Set<String> attractionsInItinerary = {};
      _dailyItineraries.forEach((date, items) {
        for (var item in items) {
          attractionsInItinerary.add(item.attraction.id);
        }
      });

      // Update the attractions list with search results
      _detectedAttractions = searchResults;

      // Update markers while preserving itinerary state
      _updateMarkers();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error searching attractions: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy địa điểm theo danh mục
  Future<void> getAttractionsByCategory(String category) async {
    try {
      _isLoading = true;
      notifyListeners();

      LatLng? currentLocation;
      if (_currentPosition != null) {
        currentLocation = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      _detectedAttractions = await _attractionService.getAttractionsByCategory(
        category,
        currentLocation: currentLocation,
      );
      _updateMarkers();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error getting attractions by category: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset selection
  void clearSelection() {
    _selectedAttraction = null;
    _polylines = [];
    _updateMarkers();
  }

  String _decodeUnicode(String text) {
    try {
      print("🔍 Original text: $text");
      
      // Bước 1: Decode Unicode escape sequences như \u00ed, \u00e0, etc.
      String decoded = text.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
      print("🔍 After Unicode decode: $decoded");
      
      // Bước 2: Fix UTF-8 encoding issues với nhiều trường hợp
      try {
        // Kiểm tra các ký tự UTF-8 bị encode sai
        if (decoded.contains('Ã') || decoded.contains('Â') || 
            decoded.contains('Æ') || decoded.contains('áº') || 
            decoded.contains('áº»') || decoded.contains('áº­')) {
          print("🔍 Detected UTF-8 encoding issues, attempting multiple fixes...");
          
          // Thử nhiều cách decode khác nhau
          String result = decoded;
          
          // Cách 1: Latin-1 -> UTF-8
          try {
            final bytes1 = latin1.encode(decoded);
            result = utf8.decode(bytes1, allowMalformed: true);
            print("🔍 After Latin-1 -> UTF-8: $result");
          } catch (e) {
            print('Lỗi Latin-1 -> UTF-8: $e');
          }
          
          // Cách 2: Nếu vẫn còn vấn đề, thử decode lại
          if (result.contains('Ã') || result.contains('Â') || 
              result.contains('Æ') || result.contains('áº')) {
            try {
              final bytes2 = latin1.encode(result);
              result = utf8.decode(bytes2, allowMalformed: true);
              print("🔍 After second Latin-1 -> UTF-8: $result");
            } catch (e) {
              print('Lỗi second Latin-1 -> UTF-8: $e');
            }
          }
          
          // Cách 3: Thử với ISO-8859-1
          if (result.contains('Ã') || result.contains('Â') || 
              result.contains('Æ') || result.contains('áº')) {
            try {
              final bytes3 = latin1.encode(result);
              result = utf8.decode(bytes3, allowMalformed: true);
              print("🔍 After ISO-8859-1 -> UTF-8: $result");
            } catch (e) {
              print('Lỗi ISO-8859-1 -> UTF-8: $e');
            }
          }
          
          decoded = result;
        }
      } catch (e) {
        print('Lỗi khi fix UTF-8 encoding: $e');
      }
      
      print("🔍 Final decoded text: $decoded");
      return decoded;
    } catch (e) {
      print('Lỗi khi decode Unicode: $e');
      return text;
    }
  }
}
