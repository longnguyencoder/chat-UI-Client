import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/conversation_model.dart';
import '../../providers/user_provider.dart';
import '../../services/home/chat_service.dart';
import 'main_viewmodel.dart';

class DrawerViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final int userId;

  List<Conversation> _conversations = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  DrawerViewModel(this.userId) {
    loadConversations();
  }

  // Getters
  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Setter cho search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Tải danh sách cuộc trò chuyện
  Future<void> loadConversations() async {
    _setLoading(true);
    _clearError();

    try {
      _conversations = await _chatService.getUserConversations(userId);
      // Sắp xếp theo thời gian mới nhất
      _conversations.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Refresh danh sách
  Future<void> refresh() async {
    await loadConversations();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  Future<void> onConversationTap(
      BuildContext context,
      Conversation conversation,
      MainViewModel mainViewModel,
      ) async {
    // Đóng drawer trước
    Navigator.of(context).pop();

    print("====================onConversationTap====================");
    print("Conversation ID: ${conversation.conversationId}");
    print("Conversation User ID: ${conversation.userId}");
    print("DrawerViewModel User ID: $userId");
    print("MainViewModel User ID: ${mainViewModel.currentUserId}");

    // ✅ Kiểm tra MainViewModel có user hợp lệ không
    if (!mainViewModel.hasValidUser) {
      print("❌ MainViewModel doesn't have valid user");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi: Không xác định được người dùng hiện tại'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ Kiểm tra userId có khớp không
    if (mainViewModel.currentUserId != userId) {
      print("❌ User ID mismatch: MainViewModel=${mainViewModel.currentUserId}, DrawerViewModel=$userId");

      // Thử cập nhật lại MainViewModel
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user != null) {
        print("🔄 Trying to update MainViewModel userId");
        mainViewModel.updateUserId(userProvider.user!.id);

        // Đợi một chút để MainViewModel cập nhật
        await Future.delayed(const Duration(milliseconds: 100));

        if (!mainViewModel.hasValidUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lỗi: Không thể cập nhật thông tin người dùng'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    // ✅ Kiểm tra xem conversation có thuộc về user hiện tại không
    if (conversation.userId != mainViewModel.currentUserId) {
      print("❌ Conversation doesn't belong to current user");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuộc trò chuyện không thuộc về người dùng hiện tại (${conversation.userId} != ${mainViewModel.currentUserId})'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiển thị loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Đang tải cuộc trò chuyện...'),
          ],
        ),
        duration: Duration(seconds: 1),
      ),
    );

    // ✅ Kiểm tra xem conversation có thuộc về user hiện tại không
    if (conversation.userId != userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuộc trò chuyện không thuộc về người dùng hiện tại'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tải cuộc trò chuyện
    try {
      // ✅ Debug log
      print("Calling loadConversation with ID: ${conversation.conversationId}");
      print("Current user ID in MainViewModel: ${mainViewModel.currentUserId}");

      await mainViewModel.loadConversation(conversation.conversationId);

      // ✅ Kiểm tra kết quả
      print("Messages loaded: ${mainViewModel.messages.length}");

      // ✅ Thông báo thành công nếu tải được tin nhắn
      if (mainViewModel.messages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tải ${mainViewModel.messages.length} tin nhắn'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Error loading conversation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi tải cuộc trò chuyện: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> handleNewConversationTap(
      BuildContext context,
      MainViewModel mainViewModel,
      ) async {
    // Kiểm tra xem cuộc trò chuyện hiện tại có tin nhắn hay không
    final currentMessages = mainViewModel.messages;
    final hasMessages = currentMessages.isNotEmpty;

    if (!hasMessages) {
      // Nếu chưa có tin nhắn, hiển thị thông báo
      showEmptyConversationWarning(context);
    } else {
      // Nếu đã có tin nhắn, cho phép tạo cuộc trò chuyện mới
      showNewConversationDialog(context, mainViewModel);
    }
  }

  void showEmptyConversationWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.info_outline,
          color: Colors.orange.shade600,
          size: 48,
        ),
        title: const Text(
          'Cuộc trò chuyện trống',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cuộc trò chuyện hiện tại chưa có tin nhắn nào.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy gửi ít nhất một tin nhắn trước khi tạo cuộc trò chuyện mới.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Đóng dialog
              Navigator.pop(context); // Đóng drawer
            },
            child: const Text('Đã hiểu'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void showNewConversationDialog(BuildContext context, MainViewModel mainViewModel) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.chat_bubble_outline,
          color: Colors.blue.shade600,
          size: 48,
        ),
        title: const Text(
          'Cuộc trò chuyện mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bạn có muốn bắt đầu cuộc trò chuyện mới không?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Cuộc trò chuyện hiện tại sẽ được lưu lại.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Đóng dialog
              Navigator.pop(context); // Đóng drawer

              // Show loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Đang tạo cuộc trò chuyện mới...'),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ),
              );

              try {
                await mainViewModel.startNewConversation();

                // Refresh drawer conversations
                await loadConversations();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã tạo cuộc trò chuyện mới thành công!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi tạo cuộc trò chuyện: $e'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tạo mới'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Hôm qua';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  // ✅ Chuyển từ View: Lấy tiêu đề cuộc trò chuyện
  String getConversationTitle(Conversation conversation) {
    final conversationTitle = conversation.title;
    return conversationTitle.toString();
  }

  // ✅ Chuyển từ View: Lấy phụ đề cuộc trò chuyện
  String getConversationSubtitle(Conversation conversation) {
    final formattedTime = formatDateTime(conversation.startedAt);
    final language =
    conversation.sourceLanguage == 'vi' ? 'Tiếng Việt' : 'English';
    return '$language • $formattedTime';
  }

  // ✅ Chuyển từ View: Lọc danh sách cuộc trò chuyện theo từ khóa
  List<Conversation> getFilteredConversations() {
    if (_searchQuery.isEmpty) {
      return _conversations;
    }

    return _conversations.where((conversation) {
      final title = getConversationTitle(conversation).toLowerCase();
      final subtitle = getConversationSubtitle(conversation).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }
}
