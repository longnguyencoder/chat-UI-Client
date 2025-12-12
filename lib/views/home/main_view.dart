import 'package:flutter/material.dart';
import 'package:mobilev2/providers/user_provider.dart';
import 'package:mobilev2/viewmodels/home/main_viewmodel.dart';
import 'package:mobilev2/views/home/drawer_view.dart';
import 'package:mobilev2/views/widgets/bot_avatar.dart';
import 'package:mobilev2/views/widgets/chat_input.dart';
import 'package:mobilev2/views/widgets/quick_actions.dart';
import 'package:mobilev2/views/widgets/scroll_to_bottom_button.dart';
import 'package:mobilev2/views/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';

class MainView extends StatefulWidget {
  final int? conversationId;
  
  const MainView({super.key, this.conversationId});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late MainViewModel viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Load conversation from URL parameter if provided (deep linking)
    if (widget.conversationId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final viewModel = context.read<MainViewModel>();
        viewModel.loadConversationFromUrl(widget.conversationId!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Consumer2<MainViewModel, UserProvider>(
          builder: (context, viewModel, userProvider, child) {
            return Column(
              children: [
                const Text(
                  "Trợ lý Y tế AI",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (viewModel.currentConversation != null ||
                    userProvider.user != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewModel.currentConversation != null)
                        Text(
                          "ID: ${viewModel.currentConversation!.conversationId}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        ),
                      if (viewModel.currentConversation != null &&
                          userProvider.user != null)
                        const SizedBox(width: 8),
                      // Khoảng cách giữa 2 đoạn text
                      if (userProvider.user != null)
                        Text(
                          "User: ${userProvider.user!.username} (${userProvider.user!.id})",
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.grey),
            onPressed: () => context.read<MainViewModel>().handleNewConversationTap(context),
            tooltip: 'Cuộc trò chuyện mới',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: () {
              context.read<MainViewModel>().refresh();
            },
            tooltip: 'Làm mới',
          ),
        ],
      ),
      drawer: const DrawerView(),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Hiển thị error nếu có
              if (viewModel.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade800, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          viewModel.error!,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => viewModel.clearError(),
                      ),
                    ],
                  ),
                ),

              // Hiển thị thông tin cuộc trò chuyện hiện tại
              if (viewModel.currentConversation != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.chat, color: Colors.blue.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cuộc trò chuyện • ${viewModel.messages.length} tin nhắn',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        viewModel.currentConversation!.sourceLanguage == 'vi'
                            ? 'Tiếng Việt'
                            : 'English',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Quick Actions
              if (viewModel.messages.isEmpty)
                const QuickActions(),

              // Danh sách tin nhắn
              Expanded(
                child: Stack(
                  children: [
                    _buildMessagesList(viewModel),
                    // Scroll to bottom button
                    ScrollToBottomButton(
                      scrollController: _scrollController,
                      onPressed: () {
                        // Có thể thêm logic bổ sung ở đây nếu cần
                        print("Scroll to bottom button pressed");
                      },
                      showThreshold: 150.0, // Hiển thị khi cách bottom 150px
                      backgroundColor: Colors.blue.shade600,
                      iconColor: Colors.white,
                      size: 40.0,
                      newMessageCount: viewModel.messages.isNotEmpty ? 
                        viewModel.messages.length : null, // Hiển thị tổng số tin nhắn
                      showNewMessageBadge: true,
                    ),
                  ],
                ),
              ),

              // Chat input
              ChatInput(
                onSendMessage: (message) {
                  viewModel.sendMessage(message);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    viewModel.scrollToBottom(_scrollController);
                  });
                },
                isEnabled: !viewModel.isSending,
              ),
            ],
          );
        },
      ),
    );
  }

  // Method _buildMessagesList
  Widget _buildMessagesList(MainViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Đang tải cuộc trò chuyện..."),
          ],
        ),
      );
    }

    if (viewModel.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services,
                size: 64,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Chào mừng bạn đến với Trợ lý Y tế AI!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Hãy hỏi tôi về triệu chứng, bệnh lý, thuốc men\nhoặc bất kỳ thông tin sức khỏe nào bạn cần!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.messages.length + (viewModel.isSending ? 1 : 0),
      itemBuilder: (context, index) {
        // Hiển thị typing indicator khi đang gửi
        if (index == viewModel.messages.length && viewModel.isSending) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BotAvatar(isTyping: true, size: 40),
                const SizedBox(width: 12),
                const TypingIndicator(),
              ],
            ),
          );
        }

        final msg = viewModel.messages[index];
        final isUser = msg.sender.toLowerCase() == 'user';
        final messageContent = msg.messageText;
        
        // Xử lý an toàn cho places
        List<String>? places;
        try {
          places = msg.places;
        } catch (e) {
          print('Lỗi khi truy cập places: $e');
          places = null;
        }
        
        final hasLocationInfo = viewModel.containsLocationInfo(messageContent, places: places);

        return Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser) ...[
                  const BotAvatar(isTyping: false, size: 32),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment:
                        isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                        ChatBubble(
                          message: messageContent,
                          isUser: isUser,
                          showActions: !isUser,
                          messageType: msg.messageType ?? 'text',
                          voiceUrl: msg.voiceUrl,
                          onCopyPressed: viewModel.copyMessageToClipboard,
                        ),
                        if (!isUser && msg.suggestions != null && msg.suggestions!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: msg.suggestions!.map((suggestion) {
                                return ActionChip(
                                  label: Text(
                                    suggestion,
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: Colors.blue.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.blue.shade100),
                                  ),
                                  onPressed: () {
                                    viewModel.sendMessage(suggestion);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      viewModel.scrollToBottom(_scrollController);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                    ],
                  ),
                ),
                if (isUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
