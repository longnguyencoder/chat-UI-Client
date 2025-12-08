import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/home/setting_viewmodel.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingView();
}

class _SettingView extends State<SettingView> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Chỉ tải dữ liệu một lần khi dependencies thay đổi
    if (!_hasLoadedData) {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user?.id != null) {
        Provider.of<SettingViewModel>(context, listen: false)
            .loadSavedItineraries(user!.id);
        _hasLoadedData = true;
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    // Kiểm tra nếu TabController chưa được khởi tạo
    if (_tabController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    //hiển thị tab
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController!,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Tài khoản'),
            Tab(text: 'Lịch trình'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F8),
      body: TabBarView(
        controller: _tabController!,
        children: [
          _buildAccountTab(user),
          _buildItineraryTab(user),
        ],
      ),
    );
  }

  Widget _buildAccountTab(user) {
    final List<Map<String, dynamic>> settings = [
      {
        'icon': Icons.email,
        'title': 'Email',
        'subtitle': user?.email ?? 'Chưa đăng nhập',
        'color': Colors.blue,
      },
      {
        'icon': Icons.person_outline,
        'title': 'Tên người dùng',
        'subtitle': user?.username ?? 'Chưa đăng nhập',
        'color': Colors.green,
      },
      {
        'icon': Icons.workspace_premium_outlined,
        'title': 'Nâng cấp lên Plus',
        'subtitle': 'Truy cập tính năng cao cấp',
        'color': Colors.orange,
      },
      {
        'icon': Icons.person_outline,
        'title': 'Cá nhân hóa',
        'subtitle': 'Tùy chỉnh trải nghiệm',
        'color': Colors.purple,
      },
      {
        'icon': Icons.settings_input_component_outlined,
        'title': 'Kiểm soát dữ liệu',
        'subtitle': 'Quản lý thông tin cá nhân',
        'color': Colors.indigo,
      },
      {
        'icon': Icons.call,
        'title': 'Thoại',
        'subtitle': 'Cài đặt giọng nói',
        'color': Colors.teal,
      },
      {
        'icon': Icons.security,
        'title': 'Bảo mật',
        'subtitle': 'Bảo vệ tài khoản',
        'color': Colors.red,
      },
      {
        'icon': Icons.info_outline,
        'title': 'Về ứng dụng',
        'subtitle': 'Thông tin phiên bản',
        'color': Colors.grey,
      },
    ];

    return ListView(
      children: [
        // User profile card
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.blue.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.person_outline, color: Colors.green),
                        title: Text(user?.username ?? 'Chưa đăng nhập', style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: user == null ? null : () {
                            showEditUsernameDialog(context, user.username ?? '');
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Vui lòng đăng nhập để sử dụng đầy đủ tính năng',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Settings list
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: settings.map((item) {
              final isLast = settings.last == item;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item['icon'],
                        color: item['color'],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(item['subtitle']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Xử lý khi nhấn
                    },
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 16,
                      color: Colors.grey.shade200,
                    ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Logout button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Consumer<SettingViewModel>(
            builder: (context, settingViewModel, child) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: settingViewModel.isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 20,
                        ),
                ),
                title: Text(
                  settingViewModel.isLoggingOut ? 'Đang đăng xuất...' : 'Đăng xuất',
                  style: TextStyle(
                    color: settingViewModel.isLoggingOut ? Colors.grey : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text('Thoát khỏi tài khoản hiện tại'),
                enabled: !settingViewModel.isLoggingOut,
                onTap: settingViewModel.isLoggingOut
                    ? null
                    : () async {
                        final shouldLogout = await settingViewModel.showLogoutConfirmation(context);
                        if (shouldLogout) {
                          await settingViewModel.logout(context);
                        }
                      },
              );
            },
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildItineraryTab(user) {
    return Consumer<SettingViewModel>(
      builder: (context, settingViewModel, child) {
        if (user?.id == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vui lòng đăng nhập để xem lịch trình',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        if (settingViewModel.isLoadingItineraries) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang tải lịch trình...'),
              ],
            ),
          );
        }

        if (settingViewModel.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  settingViewModel.errorMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => settingViewModel.loadSavedItineraries(user.id!),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final itineraryGroups = List<ItineraryGroup>.from(settingViewModel.itineraryGroups)
          ..sort((a, b) => b.date.compareTo(a.date));

        if (itineraryGroups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Chưa có lịch trình nào',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tạo lịch trình mới từ bản đồ để xem ở đây',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => settingViewModel.loadSavedItineraries(user.id!),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: itineraryGroups.length,
            itemBuilder: (context, index) {
              final group = itineraryGroups[index];
              final date = group.date;
              final title = group.title;
              final itineraries = group.itineraries;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header với ngày, title và thống kê
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            settingViewModel.formatDate(date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.label, color: Colors.blue.shade900, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade900,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'delete') {
                                // Xóa tất cả itineraries trong group này
                                for (final item in itineraries) {
                                  if (item.id != null) {
                                    final shouldDelete = await settingViewModel.showDeleteItineraryConfirmation(context, item.id);
                                    if (shouldDelete) {
                                      await settingViewModel.deleteItinerary(item.id, user.id!);
                                    }
                                  }
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Xóa tất cả'),
                                  ],
                                ),
                              ),
                            ],
                            child: Icon(Icons.more_vert, color: Colors.blue.shade600),
                          ),
                        ],
                      ),
                    ),
                    // Thống kê
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.blue.shade600),
                          const SizedBox(width: 4),
                          Text(
                            settingViewModel.formatDuration(settingViewModel.getTotalDuration(itineraries)),
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.attach_money, size: 14, color: Colors.blue.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${settingViewModel.formatPrice(settingViewModel.getTotalCost(itineraries))} VND',
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                          ),
                        ],
                      ),
                    ),
                    // Danh sách địa điểm
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itineraries.length,
                      itemBuilder: (context, itineraryIndex) {
                        final itinerary = itineraries[itineraryIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hiển thị các điểm đến trong itinerary
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: itinerary.items.length,
                              itemBuilder: (context, itemIndex) {
                                final item = itinerary.items[itemIndex];
                                final isLast = itemIndex == itinerary.items.length - 1;
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue.shade100,
                                        child: Text(
                                          '${itemIndex + 1}',
                                          style: TextStyle(
                                            color: Colors.blue.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        item.attraction.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${settingViewModel.formatTime(item.visitTime)} - ${settingViewModel.formatDuration(item.estimatedDuration)}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                          if (item.notes.isNotEmpty)
                                            Text(
                                              item.notes,
                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          if (item.attraction.price != null)
                                            Text(
                                              '${settingViewModel.formatPrice(item.attraction.price!)} VND',
                                              style: TextStyle(fontSize: 11, color: Colors.green.shade600),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (!isLast)
                                      Divider(
                                        height: 1,
                                        indent: 56,
                                        endIndent: 16,
                                        color: Colors.grey.shade200,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showEditUsernameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa tên người dùng'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tên mới',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              final settingViewModel = Provider.of<SettingViewModel>(context, listen: false);
              final success = await settingViewModel.updateUsername(context, newName);
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã cập nhật tên thành công!'), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật thất bại!'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
