import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medication_schedule_model.dart';
import '../models/medication_log_model.dart';
import 'api_service.dart';

class MedicationService {
  // ========================================================================
  // MEDICATION SCHEDULES
  // ========================================================================

  /// Tạo lịch nhắc nhở mới
  Future<MedicationSchedule> createSchedule(MedicationSchedule schedule) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final response = await http.post(
        Uri.parse(ApiService.createMedicationScheduleUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(schedule.toJson()),
      );

      print('📤 Create Schedule Response: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend trả về trong key 'schedule', không phải 'data'
        return MedicationSchedule.fromJson(data['schedule'] ?? data['data'] ?? data);
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể tạo lịch nhắc nhở: ${response.body}');
      }
    } catch (e) {
      print('❌ Error creating schedule: $e');
      throw Exception('Lỗi tạo lịch nhắc nhở: $e');
    }
  }

  /// Lấy danh sách lịch nhắc nhở
  Future<List<MedicationSchedule>> getSchedules({
    int? userId,
    bool? isActive,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final url = ApiService.getMedicationSchedulesUrl(
        userId: userId,
        isActive: isActive,
      );

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Get Schedules Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final schedules = data['data'] ?? data['schedules'] ?? [];
        
        return (schedules as List)
            .map((json) => MedicationSchedule.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể tải danh sách lịch nhắc nhở');
      }
    } catch (e) {
      print('❌ Error getting schedules: $e');
      throw Exception('Lỗi tải danh sách lịch nhắc nhở: $e');
    }
  }

  /// Lấy chi tiết 1 lịch
  Future<MedicationSchedule> getScheduleDetail(int scheduleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final response = await http.get(
        Uri.parse(ApiService.getMedicationScheduleDetailUrl(scheduleId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicationSchedule.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể tải chi tiết lịch nhắc nhở');
      }
    } catch (e) {
      print('❌ Error getting schedule detail: $e');
      throw Exception('Lỗi tải chi tiết lịch nhắc nhở: $e');
    }
  }

  /// Cập nhật lịch nhắc nhở
  Future<MedicationSchedule> updateSchedule(
    int scheduleId,
    MedicationSchedule schedule,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final response = await http.put(
        Uri.parse(ApiService.updateMedicationScheduleUrl(scheduleId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(schedule.toJson()),
      );

      print('📤 Update Schedule Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicationSchedule.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể cập nhật lịch nhắc nhở: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating schedule: $e');
      throw Exception('Lỗi cập nhật lịch nhắc nhở: $e');
    }
  }

  /// Xóa lịch nhắc nhở (soft delete)
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final response = await http.delete(
        Uri.parse(ApiService.deleteMedicationScheduleUrl(scheduleId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📤 Delete Schedule Response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Successfully deleted schedule $scheduleId');
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể xóa lịch nhắc nhở');
      }
    } catch (e) {
      print('❌ Error deleting schedule: $e');
      throw Exception('Lỗi xóa lịch nhắc nhở: $e');
    }
  }

  // ========================================================================
  // MEDICATION LOGS
  // ========================================================================

  /// Ghi nhận đã uống/bỏ qua thuốc
  Future<MedicationLog> logMedication({
    required int scheduleId,
    required int userId,
    required DateTime scheduledTime,
    required String status, // 'taken' or 'skipped'
    DateTime? actualTime,
    String? notes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final response = await http.post(
        Uri.parse(ApiService.createMedicationLogUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'schedule_id': scheduleId,
          'user_id': userId,
          'scheduled_time': scheduledTime.toIso8601String(),
          'actual_time': actualTime?.toIso8601String(),
          'status': status,
          'notes': notes,
        }),
      );

      print('📤 Log Medication Response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicationLog.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể ghi nhận: ${response.body}');
      }
    } catch (e) {
      print('❌ Error logging medication: $e');
      throw Exception('Lỗi ghi nhận uống thuốc: $e');
    }
  }

  /// Lấy lịch sử uống thuốc
  Future<List<MedicationLog>> getLogs({
    int? userId,
    int? scheduleId,
    String? status,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final url = ApiService.getMedicationLogsUrl(
        userId: userId,
        scheduleId: scheduleId,
        status: status,
        fromDate: fromDate,
        toDate: toDate,
      );

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Get Logs Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final logs = data['data'] ?? data['logs'] ?? [];
        
        return (logs as List)
            .map((json) => MedicationLog.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể tải lịch sử');
      }
    } catch (e) {
      print('❌ Error getting logs: $e');
      throw Exception('Lỗi tải lịch sử: $e');
    }
  }

  /// Lấy thống kê tuân thủ
  Future<MedicationStats> getStats({
    int? userId,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      final url = ApiService.getMedicationStatsUrl(
        userId: userId,
        fromDate: fromDate,
        toDate: toDate,
      );

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Get Stats Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MedicationStats.fromJson(data['data'] ?? data);
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Không thể tải thống kê');
      }
    } catch (e) {
      print('❌ Error getting stats: $e');
      throw Exception('Lỗi tải thống kê: $e');
    }
  }
}
