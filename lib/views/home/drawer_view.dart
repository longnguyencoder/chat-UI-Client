import 'package:flutter/material.dart';
import 'package:mobilev2/viewmodels/home/drawer_viewmodel.dart';
import 'package:mobilev2/views/home/setting_view.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/home/main_viewmodel.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        // ✅ Debug log
        print("🏠 DrawerView build - User: ${user?.id}");

        if (user == null) {
          return const Center(child: Text('Người dùng chưa đăng nhập'));
        }

        return ChangeNotifierProvider(
          create: (_) {
            print("🎯 Creating DrawerViewModel with userId: ${user.id}");
            return DrawerViewModel(user.id);
          },
          child: const _DrawerContent(),
        );
      },
    );
  }
}

class _DrawerContent extends StatefulWidget {
  const _DrawerContent();

  @override
  State<_DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<_DrawerContent> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DrawerViewModel, MainViewModel, UserProvider>(
      builder: (context, drawerViewModel, mainViewModel, userProvider, child) {
        // ✅ Debug logs
        print("🔍 _DrawerContent build:");
        print("   UserProvider user ID: ${userProvider.user?.id}");
        print("   DrawerViewModel user ID: ${drawerViewModel.userId}");
        print("   MainViewModel user ID: ${mainViewModel.currentUserId}");
        final filteredConversations = drawerViewModel.getFilteredConversations();
        final isLoading = drawerViewModel.isLoading;
        final user = Provider.of<UserProvider>(context).user;
        final hasMessages = mainViewModel.messages.isNotEmpty;

        return Drawer(
          backgroundColor: const Color(0xFFF7F7F8),
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  // Header với nút tạo cuộc trò chuyện mới
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.chat,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Cuộc trò chuyện',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed:
                                      () => drawerViewModel.handleNewConversationTap(context, mainViewModel),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  tooltip:
                                      hasMessages
                                          ? 'Tạo cuộc trò chuyện mới'
                                          : 'Gửi tin nhắn trước khi tạo mới',
                                ),
                                // Hiển thị indicator nếu cuộc trò chuyện trống
                                if (!hasMessages)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade400,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${drawerViewModel.conversations.length} cuộc trò chuyện',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            if (!hasMessages)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Trống',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Thanh tìm kiếm
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm cuộc trò chuyện...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    drawerViewModel.setSearchQuery('');
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        drawerViewModel.setSearchQuery(value);
                      },
                    ),
                  ),

                  // Danh sách cuộc trò chuyện
                  Expanded(
                    child:
                        isLoading
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Đang tải cuộc trò chuyện...'),
                                ],
                              ),
                            )
                            : filteredConversations.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    drawerViewModel.searchQuery.isNotEmpty
                                        ? Icons.search_off
                                        : Icons.chat_bubble_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    drawerViewModel.searchQuery.isNotEmpty
                                        ? 'Không tìm thấy cuộc trò chuyện'
                                        : 'Chưa có cuộc trò chuyện nào',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (drawerViewModel.searchQuery.isEmpty) ...[
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Nhấn nút + để tạo mới',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              itemCount: filteredConversations.length,
                              itemBuilder: (context, index) {
                                final conversation =
                                    filteredConversations[index];
                                final isSelected =
                                    mainViewModel
                                        .currentConversation
                                        ?.conversationId ==
                                    conversation.conversationId;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.blue.shade50
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        isSelected
                                            ? Border.all(
                                              color: Colors.blue.shade300,
                                              width: 2,
                                            )
                                            : Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                    boxShadow:
                                        isSelected
                                            ? [
                                              BoxShadow(
                                                color: Colors.blue.shade100,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : null,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          isSelected
                                              ? Colors.blue.shade600
                                              : Colors.grey.shade300,
                                      child: Icon(
                                        Icons.chat_bubble,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      drawerViewModel.getConversationTitle(conversation),
                                      style: TextStyle(
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                        color:
                                            isSelected
                                                ? Colors.blue.shade800
                                                : Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      drawerViewModel.getConversationSubtitle(conversation),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            isSelected
                                                ? Colors.blue.shade600
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    trailing:
                                        isSelected
                                            ? Icon(
                                              Icons.check_circle,
                                              color: Colors.blue.shade600,
                                              size: 20,
                                            )
                                            : const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                    onTap:
                                        () => drawerViewModel.onConversationTap(
                                          context,
                                          conversation,
                                          mainViewModel
                                        ),
                                  ),
                                );
                              },
                            ),
                  ),

                  // Divider
                  const Divider(height: 1),

                  // User profile section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          (user?.username.substring(0, 2).toUpperCase() ?? 'U'),
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user?.username ?? 'Invalid',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text(
                        'Xem cài đặt',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.settings,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingView(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
