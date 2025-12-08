import 'dart:async';
import 'dart:ui' as ui;

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class HCMCMapHelper {
  /// Tọa độ trung tâm thành phố Hồ Chí Minh
  static LatLng hcmcCenter = LatLng(10.7769, 106.7009);

  /// Tạo ảnh bản đồ Hồ Chí Minh sử dụng Mapbox Static API
  static Future<pw.MemoryImage?> generateHCMCMapImage({
    String? mapboxAccessToken,
    List<LatLng>? itineraryPoints,
    List<String>? locationNames,
    String mapStyle = 'outdoors-v12',
    int width = 600,
    int height = 400,
    double zoom = 11.0,
  }) async {
    try {
      // Sử dụng token được cung cấp hoặc lấy từ biến môi trường
      final token = mapboxAccessToken ?? dotenv.env["MAPBOX_ACCESS_TOKEN"];

      if (token == null || token.isEmpty) {
        print('❌ Mapbox access token is missing');
        return await generateFallbackMapImage(
            itineraryPoints: itineraryPoints,
            locationNames: locationNames
        );
      }

      // Nếu có các điểm trong lịch trình, điều chỉnh center và zoom để hiển thị tất cả các điểm
      LatLng center = hcmcCenter;
      double mapZoom = zoom;

      if (itineraryPoints != null && itineraryPoints.isNotEmpty) {
        // Tính toán center và zoom level để hiển thị tất cả các điểm
        double minLat = itineraryPoints.first.latitude;
        double maxLat = itineraryPoints.first.latitude;
        double minLng = itineraryPoints.first.longitude;
        double maxLng = itineraryPoints.first.longitude;

        for (var point in itineraryPoints) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLng) minLng = point.longitude;
          if (point.longitude > maxLng) maxLng = point.longitude;
        }

        // Thêm padding
        final latPadding = (maxLat - minLat) * 0.2;
        final lngPadding = (maxLng - minLng) * 0.2;

        minLat -= latPadding;
        maxLat += latPadding;
        minLng -= lngPadding;
        maxLng += lngPadding;

        // Tính center mới
        center = LatLng(
          (minLat + maxLat) / 2,
          (minLng + maxLng) / 2,
        );

        // Tính zoom level dựa trên khoảng cách
        final latDiff = (maxLat - minLat).abs();
        final lngDiff = (maxLng - minLng).abs();
        final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

        // Công thức đơn giản để tính zoom level
        mapZoom = 13.0;
        if (maxDiff > 0.02) mapZoom = 12.0;
        if (maxDiff > 0.05) mapZoom = 11.0;
        if (maxDiff > 0.1) mapZoom = 10.0;
        if (maxDiff > 0.2) mapZoom = 9.0;
      }

      // Tạo markers cho các điểm bổ sung
      String markers = '';
      if (itineraryPoints != null && itineraryPoints.isNotEmpty) {
        for (int i = 0; i < itineraryPoints.length; i++) {
          final point = itineraryPoints[i];
          // Sử dụng màu khác nhau cho điểm đầu, điểm cuối và các điểm trung gian
          String color;
          if (i == 0) {
            color = '3F51B5'; // Màu xanh dương cho điểm đầu
          } else if (i == itineraryPoints.length - 1) {
            color = 'E91E63'; // Màu hồng cho điểm cuối
          } else {
            color = 'FF9800'; // Màu cam cho các điểm trung gian
          }

          // Thêm marker với số thứ tự
          markers += 'pin-s-${i+1}+$color(${point.longitude},${point.latitude}),';
        }

        if (markers.isNotEmpty) {
          markers = markers.substring(0, markers.length - 1); // Xóa dấu phẩy cuối cùng
        }
      } else {
        // Nếu không có điểm nào, thêm marker cho trung tâm thành phố
        markers = 'pin-s-star+1E88E5(${center.longitude},${center.latitude})';
      }

      // Tạo đường nối giữa các điểm (path)
      String path = '';
      if (itineraryPoints != null && itineraryPoints.length > 1) {
        path = 'path-5+4CAF50-1(';
        for (var point in itineraryPoints) {
          path += '${point.longitude},${point.latitude};';
        }
        path = path.substring(0, path.length - 1); // Xóa dấu chấm phẩy cuối cùng
        path += ')';

        // Thêm path vào markers
        markers = '$path,$markers';
      }

      // Tạo URL cho Mapbox Static API
      final url = 'https://api.mapbox.com/styles/v1/mapbox/$mapStyle/static/$markers/${center.longitude},${center.latitude},$mapZoom,0/${width}x${height}@2x?access_token=$token';

      print('Generating map image with URL: $url');

      // Tải hình ảnh từ URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Successfully generated map image: ${response.bodyBytes.length} bytes');
        return pw.MemoryImage(response.bodyBytes);
      } else {
        print('Failed to load map image: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Thử phương pháp dự phòng
        return await generateFallbackMapImage(
            itineraryPoints: itineraryPoints,
            locationNames: locationNames
        );
      }
    } catch (e) {
      print('Error generating HCMC map image: $e');
      return await generateHCMCOpenStreetMapImage(); // Fallback to OpenStreetMap
    }
  }

  /// Tạo ảnh bản đồ Hồ Chí Minh sử dụng OpenStreetMap (không cần token)
  static Future<pw.MemoryImage?> generateHCMCOpenStreetMapImage({
    List<LatLng>? itineraryPoints,
    List<String>? locationNames,
    int width = 600,
    int height = 400,
    int zoom = 12,
  }) async {
    try {
      // Nếu có các điểm trong lịch trình, điều chỉnh center và zoom
      LatLng center = hcmcCenter;
      int mapZoom = zoom;

      if (itineraryPoints != null && itineraryPoints.isNotEmpty) {
        // Tính toán center và zoom level để hiển thị tất cả các điểm
        double minLat = itineraryPoints.first.latitude;
        double maxLat = itineraryPoints.first.latitude;
        double minLng = itineraryPoints.first.longitude;
        double maxLng = itineraryPoints.first.longitude;

        for (var point in itineraryPoints) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLng) minLng = point.longitude;
          if (point.longitude > maxLng) maxLng = point.longitude;
        }

        // Tính center mới
        center = LatLng(
          (minLat + maxLat) / 2,
          (minLng + maxLng) / 2,
        );

        // Tính zoom level dựa trên khoảng cách
        final latDiff = (maxLat - minLat).abs();
        final lngDiff = (maxLng - minLng).abs();
        final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

        // Công thức đơn giản để tính zoom level
        mapZoom = 13;
        if (maxDiff > 0.02) mapZoom = 12;
        if (maxDiff > 0.05) mapZoom = 11;
        if (maxDiff > 0.1) mapZoom = 10;
        if (maxDiff > 0.2) mapZoom = 9;
      }

      // Tạo markers cho các điểm trong lịch trình
      String markers = '';
      if (itineraryPoints != null && itineraryPoints.isNotEmpty) {
        for (int i = 0; i < itineraryPoints.length; i++) {
          final point = itineraryPoints[i];
          markers += '${point.latitude},${point.longitude},${i+1}|';
        }

        if (markers.isNotEmpty) {
          markers = markers.substring(0, markers.length - 1); // Xóa dấu | cuối cùng
        }
      } else {
        // Nếu không có điểm nào, thêm marker cho trung tâm thành phố
        markers = '${center.latitude},${center.longitude},star';
      }

      // Tạo URL cho OpenStreetMap Static API
      final url = 'https://staticmap.openstreetmap.de/staticmap.php?center=${center.latitude},${center.longitude}&zoom=$mapZoom&size=${width}x$height&maptype=mapnik&markers=$markers';

      print('Generating OSM map image with URL: $url');

      // Tải hình ảnh từ URL với timeout ngắn hơn
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('OSM request timed out');
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        print('Successfully generated OSM map image: ${response.bodyBytes.length} bytes');
        return pw.MemoryImage(response.bodyBytes);
      } else {
        print('Failed to load OSM map image: ${response.statusCode}');
        return await generateFallbackMapImage(
            itineraryPoints: itineraryPoints,
            locationNames: locationNames
        );
      }
    } catch (e) {
      print('Error generating HCMC OSM map image: $e');
      return null;
    }
  }

  /// Tạo ảnh bản đồ dự phòng khi cả Mapbox và OpenStreetMap đều thất bại
  static Future<pw.MemoryImage> generateFallbackMapImage({
    List<LatLng>? itineraryPoints,
    List<String>? locationNames,
  }) async {
    try {
      print('Generating fallback map image with itinerary points');

      // Tạo một canvas để vẽ bản đồ đơn giản
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(600, 400);

      // Vẽ nền
      final bgPaint = Paint()..color = Colors.grey[200]!;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

      // Vẽ đường viền
      final borderPaint = Paint()
        ..color = Colors.grey[400]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), borderPaint);

      // Vẽ tên thành phố
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Hồ Chí Minh',
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset((size.width - textPainter.width) / 2, 20)
      );

      // Vẽ các điểm trong lịch trình
      if (itineraryPoints != null && itineraryPoints.isNotEmpty) {
        // Tính toán vị trí các điểm trên canvas
        double minLat = itineraryPoints.first.latitude;
        double maxLat = itineraryPoints.first.latitude;
        double minLng = itineraryPoints.first.longitude;
        double maxLng = itineraryPoints.first.longitude;

        for (var point in itineraryPoints) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLng) minLng = point.longitude;
          if (point.longitude > maxLng) maxLng = point.longitude;
        }

        // Thêm padding
        final latPadding = (maxLat - minLat) * 0.2;
        final lngPadding = (maxLng - minLng) * 0.2;

        minLat -= latPadding;
        maxLat += latPadding;
        minLng -= lngPadding;
        maxLng += lngPadding;

        // Hàm chuyển đổi tọa độ thành vị trí trên canvas
        Offset latLngToPoint(LatLng latLng) {
          final x = (latLng.longitude - minLng) / (maxLng - minLng) * (size.width - 60) + 30;
          final y = (maxLat - latLng.latitude) / (maxLat - minLat) * (size.height - 120) + 80;
          return Offset(x, y);
        }

        // Vẽ đường nối các điểm
        if (itineraryPoints.length > 1) {
          final pathPaint = Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;

          final path = ui.Path(); // Sử dụng ui.Path từ dart:ui
          final firstPoint = latLngToPoint(itineraryPoints.first);
          path.moveTo(firstPoint.dx, firstPoint.dy);

          for (int i = 1; i < itineraryPoints.length; i++) {
            final point = latLngToPoint(itineraryPoints[i]);
            path.lineTo(point.dx, point.dy);
          }

          canvas.drawPath(path, pathPaint);
        }

        // Vẽ các điểm
        for (int i = 0; i < itineraryPoints.length; i++) {
          final point = itineraryPoints[i];
          final position = latLngToPoint(point);

          // Màu sắc khác nhau cho điểm đầu, điểm cuối và các điểm trung gian
          Color pointColor;
          if (i == 0) {
            pointColor = Colors.blue; // Điểm đầu
          } else if (i == itineraryPoints.length - 1) {
            pointColor = Colors.red; // Điểm cuối
          } else {
            pointColor = Colors.orange; // Điểm trung gian
          }

          // Vẽ điểm
          final pointPaint = Paint()..color = pointColor;
          canvas.drawCircle(position, 10, pointPaint);

          // Vẽ viền trắng
          final borderPaint = Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;
          canvas.drawCircle(position, 10, borderPaint);

          // Vẽ số thứ tự
          final numberPainter = TextPainter(
            text: TextSpan(
              text: '${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          numberPainter.layout();
          numberPainter.paint(
              canvas,
              Offset(
                  position.dx - numberPainter.width / 2,
                  position.dy - numberPainter.height / 2
              )
          );

          // Vẽ tên địa điểm si có
          if (locationNames != null && i < locationNames.length) {
            final namePainter = TextPainter(
              text: TextSpan(
                text: locationNames[i],
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textDirection: TextDirection.ltr,
            );
            namePainter.layout(maxWidth: 100);

            // Vẽ nền cho tên
            final textBgRect = Rect.fromLTWH(
                position.dx - namePainter.width / 2 - 4,
                position.dy + 12,
                namePainter.width + 8,
                namePainter.height + 4
            );

            final textBgPaint = Paint()
              ..color = Colors.white.withOpacity(0.8)
              ..style = PaintingStyle.fill;

            canvas.drawRRect(
                RRect.fromRectAndRadius(textBgRect, const Radius.circular(4)),
                textBgPaint
            );

            namePainter.paint(
                canvas,
                Offset(
                    position.dx - namePainter.width / 2,
                    position.dy + 14
                )
            );
          }
        }

        // Vẽ chú thích
        final legendBgPaint = Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(10, size.height - 70, 180, 60),
                const Radius.circular(8)
            ),
            legendBgPaint
        );

        // Vẽ tiêu đề chú thích
        final legendTitlePainter = TextPainter(
          text: const TextSpan(
            text: 'Chú thích:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        legendTitlePainter.layout();
        legendTitlePainter.paint(canvas, Offset(20, size.height - 65));

        // Vẽ các mục trong chú thích
        _drawLegendItem(canvas, Colors.blue, 'Điểm bắt đầu', 20, size.height - 50);
        _drawLegendItem(canvas, Colors.orange, 'Điểm trung gian', 20, size.height - 35);
        _drawLegendItem(canvas, Colors.red, 'Điểm kết thúc', 20, size.height - 20);
      } else {
        // Nếu không có điểm nào, vẽ biểu tượng vị trí ở trung tâm
        final iconPaint = Paint()..color = Colors.red;
        canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 10), 10, iconPaint);

        final iconBorderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 10), 10, iconBorderPaint);

        // Vẽ tọa độ
        final coordTextPainter = TextPainter(
          text: TextSpan(
            text: '10.7769° N, 106.7009° E',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        coordTextPainter.layout();
        coordTextPainter.paint(
            canvas,
            Offset((size.width - coordTextPainter.width) / 2, (size.height - coordTextPainter.height) / 2 + 20)
        );
      }

      // Chuyển đổi canvas thành hình ảnh
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to generate fallback image');
      }

      final bytes = byteData.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Error generating fallback map image: $e');
      // Nếu tất cả đều thất bại, tạo một hình ảnh trống
      return await _generateEmptyImage();
    }
  }

  // Hàm vẽ một mục trong chú thích
  static void _drawLegendItem(Canvas canvas, Color color, String text, double x, double y) {
    // Vẽ điểm màu
    final pointPaint = Paint()..color = color;
    canvas.drawCircle(Offset(x + 6, y + 6), 6, pointPaint);

    // Vẽ viền trắng
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(x + 6, y + 6), 6, borderPaint);

    // Vẽ text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x + 18, y));
  }

  /// Tạo một hình ảnh trống khi tất cả các phương pháp đều thất bại
  static Future<pw.MemoryImage> _generateEmptyImage() async {
    try {
      // Tải hình ảnh mặc định từ assets
      final ByteData data = await rootBundle.load('assets/images/hcmc_map_placeholder.png');
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      // Nếu không có hình ảnh mặc định, tạo một hình ảnh đơn giản
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(600, 400);

      // Vẽ nền trắng
      final bgPaint = Paint()..color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

      // Vẽ thông báo
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Bản đồ không khả dụng',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2)
      );

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to generate empty image');
      }

      final bytes = byteData.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}

