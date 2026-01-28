import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../viewmodels/home/setting_viewmodel.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingView();
}

class _SettingView extends State<SettingView> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    // Kiểm tra nếu TabController chưa được khởi tạo
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F7F8),
      body: _buildAccountTab(user),
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
