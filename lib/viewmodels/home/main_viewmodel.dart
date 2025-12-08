import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilev2/models/conversation_model.dart';
import 'package:mobilev2/services/home/voice_service.dart';
import 'package:record/record.dart';
import '../../models/message_model.dart';
import '../../services/home/chat_service.dart';
import '../../views/home/map_view.dart';

class MainViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final VoiceService _voiceService = VoiceService();
  int? _currentUserId;

  // State variables
  List<Message> _messages = [];
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isSending = false;
  bool _isRecording = false;
  String? _error;
  final String _sourceLanguage = 'vi';
  int? _lastInitializedUserId;

  // Getters
  List<Message> get messages => _messages;
  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isRecording {
    return _isRecording;
  }
  String? get error => _error;
  int? get currentUserId => _currentUserId;

  // ✅ Getter để kiểm tra user hợp lệ
  bool get hasValidUser => _currentUserId != null && _currentUserId! > 0;

  // Lấy amplitude stream để tạo waveform
  Stream<Amplitude>? getAmplitudeStream() {
    return _voiceService.getAmplitudeStream();
  }

  // ✅ Method để update userId từ UserProvider
  void updateUserId(int? newUserId) {
    print("🔄 updateUserId called: old=$_currentUserId, new=$newUserId");

    if (_currentUserId != newUserId) {
      print("✅ User ID changed from $_currentUserId to $newUserId");

      final oldUserId = _currentUserId;
      _currentUserId = newUserId;

      // Reset data khi user thay đổi
      if (oldUserId != null && newUserId != oldUserId) {
        print("🔄 Resetting user data due to user change");
        _resetUserData();
        _lastInitializedUserId = null;
      }

      // ✅ Thông báo listeners về thay đổi
      notifyListeners();

      // Khởi tạo lại nếu có user hợp lệ và chưa được khởi tạo
      if (hasValidUser && _lastInitializedUserId != _currentUserId) {
        print("🚀 Initializing MainViewModel for user $newUserId");
        initialize();
      } else {
        print("⚠️ No valid user or already initialized, skipping initialization");
      }
    } else {
      print("ℹ️ User ID unchanged: $_currentUserId");
    }
  }

  // Khởi tạo ViewModel
  Future<void> initialize() async {
    if (!hasValidUser) {
      print("No valid user, skipping initialization");
      return;
    }

    // ✅ Bảo vệ: Kiểm tra xem đã được khởi tạo chưa
    if (_lastInitializedUserId == _currentUserId) {
      print("⚠️ Already initialized for user $_currentUserId, skipping");
      return;
    }

    print("🚀 Starting initialization for user $_currentUserId");

    // Kiểm tra xem có phải user mới hay không
    bool isNewUser = _lastInitializedUserId != _currentUserId;

    if (isNewUser) {
      // Reset tất cả dữ liệu khi user mới đăng nhập
      _resetUserData();
      _lastInitializedUserId = _currentUserId;
    }

    await loadUserConversations();

    // Tải cuộc trò chuyện mới nhất của user hiện tại
    if (_conversations.isNotEmpty) {
      // Lọc các cuộc trò chuyện thuộc về user hiện tại
      final userConversations = _conversations.where(
              (conv) => conv.userId == _currentUserId
      ).toList();

      if (userConversations.isNotEmpty) {
        // Sắp xếp theo thời gian mới nhất và lấy conversation đầu tiên
        userConversations.sort((a, b) => b.startedAt.compareTo(a.startedAt));
        final latestConversation = userConversations.first;

        print("Loading latest conversation for user $_currentUserId: ${latestConversation.conversationId}");
        await loadConversation(latestConversation.conversationId);
      } else {
        print("No conversations found for user $_currentUserId, creating new one");
        await createNewConversation();
      }
    } else {
      print("No conversations exist, creating new one for user $_currentUserId");
      await createNewConversation();
    }

    print("✅ Initialization completed for user $_currentUserId");
  }

  void _resetUserData() {
    _messages.clear();
    _conversations.clear();
    _currentConversation = null;
    _error = null;
    _isLoading = false;
    _isSending = false;
    _isRecording = false;

    // Dừng mọi hoạt động ghi âm nếu đang thực hiện
    if (_isRecording) {
      _voiceService.cancelRecording();
      _isRecording = false;
    }

    notifyListeners();
  }

  // Tải danh sách cuộc trò chuyện của user
  Future<void> loadUserConversations() async {
    if (!hasValidUser) return;
    _setLoading(true);
    clearError();

    try {
      print("Loading conversations for user: $_currentUserId");

      // Đảm bảo chỉ load conversations của user hiện tại
      _conversations = await _chatService.getUserConversations(_currentUserId!);

      // Double check: Lọc lại để đảm bảo chỉ có conversations của user hiện tại
      _conversations = _conversations.where(
              (conv) => conv.userId == _currentUserId
      ).toList();

      // Sắp xếp theo thời gian mới nhất
      _conversations.sort((a, b) => b.startedAt.compareTo(a.startedAt));

      print("Loaded ${_conversations.length} conversations for user $_currentUserId");
      notifyListeners();
    } catch (e) {
      print("Error loading conversations for user $_currentUserId: $e");
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Tải một cuộc trò chuyện cụ thể
  Future<void> loadConversation(int conversationId) async {
    if (!hasValidUser) return;
    _setLoading(true);
    clearError();

    try {
      print("Loading conversation $conversationId for user $_currentUserId");

      // Tìm cuộc trò chuyện trong danh sách và validate
      final conversation = _conversations.firstWhere(
            (conv) => conv.conversationId == conversationId && conv.userId == _currentUserId,
        orElse: () => throw Exception("Conversation $conversationId not found or doesn't belong to user $_currentUserId"),
      );

      _currentConversation = conversation;

      // Tải tin nhắn của cuộc trò chuyện
      _messages = await _chatService.getConversationMessages(conversationId);

      print("Loaded ${_messages.length} messages for conversation $conversationId");
      
      // Thống kê places trong tất cả tin nhắn
      int messagesWithPlaces = 0;
      int totalPlaces = 0;
      List<String> allPlaces = [];
      
      for (final message in _messages) {
        if (message.places != null && message.places!.isNotEmpty) {
          messagesWithPlaces++;
          totalPlaces += message.places!.length;
          allPlaces.addAll(message.places!);
        }
      }
      
      print("📊 Places Summary for Conversation $conversationId:");
      print("   📨 Messages with places: $messagesWithPlaces/${_messages.length}");
      print("   📍 Total places found: $totalPlaces");
      if (allPlaces.isNotEmpty) {
        print("   🏛️ All unique places: ${allPlaces.toSet().toList()}");
      }
      print("   " + "=" * 60);
      
      notifyListeners();
    } catch (e) {
      print("Error loading conversation $conversationId: $e");
      _setError(e.toString());
      
      // ✅ Thay vào đó, chỉ hiển thị lỗi và để user tự xử lý
      print("⚠️ Failed to load conversation $conversationId, user should handle this manually");
    } finally {
      _setLoading(false);
    }
  }

  // Force reset conversation state (dùng khi có lỗi)
  void forceResetConversation() {
    print("🔄 Force resetting conversation state");
    _currentConversation = null;
    _messages = [];
    notifyListeners();
  }

  // Tạo cuộc trò chuyện mới
  Future<void> createNewConversation() async {
    if (!hasValidUser) return;
    
    // ✅ Bảo vệ: Kiểm tra xem đã có conversation hiện tại chưa
    if (_currentConversation != null) {
      print("⚠️ Current conversation already exists: ${_currentConversation!.conversationId}");
      print("🔄 Force resetting to allow new conversation creation");
      forceResetConversation();
    }
    
    _setLoading(true);
    clearError();

    try {
      print("Creating new conversation for user $_currentUserId");

      final newConversation = await _chatService.createNewConversation(
        _currentUserId!,
        _sourceLanguage,
      );

      // Validate conversation được tạo đúng user
      if (newConversation.userId != _currentUserId) {
        throw Exception("Created conversation doesn't belong to current user");
      }

      _currentConversation = newConversation;
      _conversations.insert(0, newConversation);
      _messages = [];

      print("✅ Created new conversation ${newConversation.conversationId} for user $_currentUserId");
      notifyListeners();
    } catch (e) {
      print("❌ Error creating new conversation for user $_currentUserId: $e");
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Gửi tin nhắn dạng text
  Future<void> sendMessage(String messageText) async {
    if (!hasValidUser || _currentConversation == null || messageText.trim().isEmpty) return;

    _setSending(true);
    clearError();

    try {
      // Lưu tin nhắn của user
      final response = await _chatService.sendMessageAndGetResponse(
        conversationId: _currentConversation!.conversationId,
        sender: 'user',
        messageText: messageText,
      );

      // Parse response data
      final responseData = response['data'] as Map<String, dynamic>;

      // Lấy user message từ response
      final userMessageData = responseData['user_message'] as Map<String, dynamic>;
      final userMessage = Message.fromJson(userMessageData);

      // Lấy bot message từ response
      final botMessageData = responseData['bot_message'] as Map<String, dynamic>;
      final botMessage = Message.fromJson(botMessageData);

      // Thêm cả 2 tin nhắn vào danh sách
      _messages.add(userMessage);
      _messages.add(botMessage);
      notifyListeners();

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setSending(false);
    }
  }

  // Bắt đầu ghi âm
  Future<void> startVoiceRecording() async {
    clearError();

    try {
      final success = await _voiceService.startRecording();
      if (success) {
        _isRecording = true;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Dừng ghi âm và gửi tin nhắn giọng nói
  Future<void> stopVoiceRecording() async {
    if (!_isRecording) return;

    _setSending(true);
    _isRecording = false;
    notifyListeners();

    try {
      final filePath = await _voiceService.stopRecording();
      if (filePath == null || filePath.isEmpty) {
        throw Exception('Không thể lưu file ghi âm');
      }

      // Kiểm tra cuộc trò chuyện hiện tại
      if (_currentConversation == null) {
        throw Exception('Không có cuộc trò chuyện hiện tại');
      }

      // Gửi tin nhắn giọng nói đến API
      final response = await _chatService.sendVoiceMessageAndGetResponse(
        conversationId: _currentConversation!.conversationId,
        sender: 'user',
        audioFilePath: filePath,
      );

      // Parse response data
      final responseData = response['data'] as Map<String, dynamic>;

      // Lấy user message từ response
      final userMessageData = responseData['user_message'] as Map<String, dynamic>;
      final userMessage = Message.fromJson(userMessageData);

      // Lấy bot message từ response
      final botMessageData = responseData['bot_message'] as Map<String, dynamic>;
      final botMessage = Message.fromJson(botMessageData);

      // Thêm cả 2 tin nhắn vào danh sách
      _messages.add(userMessage);
      _messages.add(botMessage);
      notifyListeners();

      // Xóa file tạm
      await _voiceService.deleteTemporaryFile(filePath);
    } catch (e) {
      _setError(e.toString());
      _isRecording = false;
      notifyListeners();
    } finally {
      _setSending(false);
    }
  }

  // Hủy ghi âm
  Future<void> cancelVoiceRecording() async {
    if (!_isRecording) return;

    try {
      await _voiceService.cancelRecording();
      _isRecording = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Kết thúc cuộc trò chuyện hiện tại và tạo mới
  Future<void> startNewConversation() async {
    if (_currentConversation != null) {
      try {
        print("🔄 Attempting to end conversation ${_currentConversation!.conversationId}");
        await _chatService.endConversation(
          _currentConversation!.conversationId,
        );
        print("✅ Successfully ended conversation ${_currentConversation!.conversationId}");
      } catch (e) {
        // Log error nhưng vẫn tiếp tục tạo cuộc trò chuyện mới
        print('❌ Lỗi kết thúc cuộc trò chuyện: $e');
        print('⚠️ Continuing to create new conversation despite end conversation error');
      }
    }

    // Reset current conversation để có thể tạo mới
    forceResetConversation();
    
    // Tạo cuộc trò chuyện mới
    await createNewConversation();
  }

  // Refresh toàn bộ dữ liệu
  Future<void> refresh() async {
    if (!hasValidUser) return;
    await loadUserConversations();
    if (_currentConversation != null) {
      await loadConversation(_currentConversation!.conversationId);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSending(bool sending) {
    _isSending = sending;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }

  // Phương thức logout để reset toàn bộ dữ liệu
  void logout() {
    _resetUserData();
    _lastInitializedUserId = null;
    _currentUserId = 0; // hoặc giá trị mặc định
  }

  // Kiểm tra xem tin nhắn có chứa thông tin địa điểm không
  bool containsLocationInfo(String message, {List<String>? places}) {
    // Kiểm tra từ khóa trong message
    final locationKeywords = [
      'địa điểm',
      'location',
      'đi đến',
      'visit',
      'tham quan',
      'du lịch',
      'lịch trình',
      'itinerary',
      'bản đồ',
      'map',
      'tọa độ',
      'coordinates',
      'bến thành',
      'nhà thờ đức bà',
      'dinh độc lập',
      'landmark',
      'bitexco',
    ];

    final lowerMessage = message.toLowerCase();
    final hasKeywords = locationKeywords.any((keyword) => lowerMessage.contains(keyword));
    
    // Kiểm tra xem có địa điểm trong places không
    final hasPlaces = places != null && places.isNotEmpty;
    
    return hasKeywords || hasPlaces;
  }

  // Hiển thị popup với các tùy chọn cho tin nhắn du lịch
  void showTravelOptionsPopup(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.travel_explore, color: Colors.blue.shade600),
                  const SizedBox(width: 12),
                  const Text(
                    'Tùy chọn du lịch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Options
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.map, color: Colors.blue.shade600),
              ),
              title: const Text('Xem trên bản đồ'),
              subtitle: const Text('Hiển thị địa điểm và lịch trình'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                navigateToMapView(context, message.places!, message.translatedText ?? '');
              },
            ),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.route, color: Colors.green.shade600),
              ),
              title: const Text('Lập lịch trình'),
              subtitle: const Text('Tạo kế hoạch chi tiết'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                createItinerary(context, message);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Chuyển đến MapView
  void navigateToMapView(BuildContext context, List<String> places, String language) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapView(
          conversationId: _currentConversation?.conversationId ?? 0,
          places: places,
          language: language,
        ),
      ),
    );
  }

  // Tạo lịch trình - Cải thiện logic
  void createItinerary(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lập lịch trình'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tính năng lập lịch trình đang được phát triển.'),
            const SizedBox(height: 16),
            Text('Tin nhắn: ${message.messageText.substring(0, 50)}...'),
            
            // Hiển thị danh sách địa điểm nếu có
            if (message.places!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Địa điểm được đề xuất:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ...message.places!.map((place) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        place,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Xử lý khi nhấn nút tạo cuộc trò chuyện mới
  void handleNewConversationTap(BuildContext context) {
    // Kiểm tra xem cuộc trò chuyện hiện tại có tin nhắn hay không
    final hasMessages = _messages.isNotEmpty;

    if (!hasMessages) {
      // Nếu chưa có tin nhắn, hiển thị thông báo
      showEmptyConversationWarning(context);
    } else {
      // Nếu đã có tin nhắn, cho phép tạo cuộc trò chuyện mới
      createNewConversation();
    }
  }

  // Hiển thị cảnh báo khi cuộc trò chuyện trống
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

  // Cuộn xuống cuối danh sách tin nhắn
  void scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Phương thức sao chép tin nhắn vào clipboard
  Future<void> copyMessageToClipboard(String message, BuildContext context) async {
    try {
      // Sao chép văn bản vào clipboard
      await Clipboard.setData(ClipboardData(text: message));

      // Hiển thị thông báo thành công
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                const Text('Đã sao chép tin nhắn'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi sao chép: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      print('Lỗi sao chép tin nhắn: $e');
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
