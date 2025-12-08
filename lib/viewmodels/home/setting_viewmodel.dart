import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/itinerary.dart';
import '../../providers/user_provider.dart';
import '../../services/auth/auth_service.dart';
import '../../services/home/itinerary_service.dart';
import 'main_viewmodel.dart';

class ItineraryGroup {
  final DateTime date;
  final String title;
  final List<Itinerary> itineraries;
  ItineraryGroup({required this.date, required this.title, required this.itineraries});
}

class SettingViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ItineraryService _itineraryService = ItineraryService();

  bool _isLoggingOut = false;
  bool _isLoadingItineraries = false;
  List<Itinerary> _savedItineraries = [];
  String? _errorMessage;

  bool get isLoggingOut => _isLoggingOut;

  bool get isLoadingItineraries => _isLoadingItineraries;

  List<Itinerary> get savedItineraries => _savedItineraries;

  String? get errorMessage => _errorMessage;

  // Lấy danh sách lịch trình đã lưu
  Future<void> loadSavedItineraries(int userId) async {
    if (_isLoadingItineraries) return;

    _isLoadingItineraries = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedItineraries = await _itineraryService.getUserItineraries(userId);
      print('✅ Đã tải \\${_savedItineraries.length} lịch trình từ database');
      for (final it in _savedItineraries) {
        print('---');
        print('ID: \\${it.id} | Title: \\${it.title} | Date: \\${it.selectedDate} | UserID: \\${it.userId}');
        print('Số điểm đến: \\${it.items.length}');
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi tải lịch trình: ${e.toString()}';
      print('❌ Lỗi khi tải lịch trình: $e');
    } finally {
      _isLoadingItineraries = false;
      notifyListeners();
    }
  }

  // Xóa lịch trình
  Future<bool> deleteItinerary(int itineraryId, int userId) async {
    try {
      final success = await _itineraryService.deleteItinerary(
        itineraryId,
        userId,
      );
      if (success) {
        _savedItineraries.removeWhere((item) => item.id == itineraryId);
        notifyListeners();
        print('✅ Đã xóa lịch trình ID: $itineraryId');
      }
      return success;
    } catch (e) {
      print('❌ Lỗi khi xóa lịch trình: $e');
      return false;
    }
  }

  // Nhóm lịch trình theo ngày và title
  List<ItineraryGroup> get itineraryGroups {
    final Map<String, List<Itinerary>> grouped = {};
    for (final itinerary in _savedItineraries) {
      final groupKey = itinerary.id.toString();
      if (grouped.containsKey(groupKey)) {
        grouped[groupKey]!.add(itinerary);
      } else {
        grouped[groupKey] = [itinerary];
      }
    }
    final List<ItineraryGroup> groups = grouped.entries.map((entry) {
      final first = entry.value.first;
      final date = DateTime.tryParse(first.selectedDate) ?? DateTime(2000);
      final title = first.title;
      return ItineraryGroup(date: date, title: title, itineraries: entry.value);
    }).toList();
    // Sắp xếp theo ngày giảm dần (gần nhất lên đầu)
    groups.sort((a, b) => b.date.compareTo(a.date));
    return groups;
  }

  // Tính tổng thời gian của lịch trình
  Duration getTotalDuration(List<Itinerary> itineraries) {
    return itineraries.fold<Duration>(
      Duration.zero,
      (total, itinerary) =>
          total +
          itinerary.items.fold<Duration>(
            Duration.zero,
            (itemTotal, item) => itemTotal + item.estimatedDuration,
          ),
    );
  }

  // Tính tổng chi phí của lịch trình
  double getTotalCost(List<Itinerary> itineraries) {
    return itineraries.fold<double>(
      0.0,
      (total, itinerary) =>
          total +
          itinerary.items.fold<double>(
            0.0,
            (itemTotal, item) => itemTotal + (item.attraction.price ?? 0.0),
          ),
    );
  }

  // Format thời gian
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Format ngày
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Format thời lượng
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '$hours giờ ${minutes > 0 ? '$minutes phút' : ''}';
    } else {
      return '$minutes phút';
    }
  }

  // Format giá
  String formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Future<void> logout(BuildContext context) async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;
    notifyListeners();

    try {
      // 1. Logout từ service
      await _authService.logout();

      if (!context.mounted) return;

      // 2. Clear UserProvider
      Provider.of<UserProvider>(context, listen: false).clearUser();

      // 3. Reset MainViewModel
      Provider.of<MainViewModel>(context, listen: false).logout();

      if (!context.mounted) return;

      // 4. Navigate
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng xuất: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  Future<bool> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Xác nhận đăng xuất'),
                content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Đăng xuất'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> showDeleteItineraryConfirmation(
    BuildContext context,
    int itineraryId,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Xác nhận xóa'),
                content: const Text(
                  'Bạn có chắc chắn muốn xóa lịch trình này không?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Xóa'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> updateUsername(BuildContext context, String newUsername) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user == null) return false;
      final success = await _authService.updateUsername(user.id!, newUsername);
      if (success) {
        // Cập nhật lại user trong Provider
        userProvider.setUsername(newUsername);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('❌ Lỗi updateUsername: $e');
      return false;
    }
  }
}
