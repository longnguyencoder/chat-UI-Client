import 'package:flutter/material.dart';
import 'package:mobilev2/models/medication_schedule_model.dart';
import 'package:mobilev2/providers/user_provider.dart';
import 'package:mobilev2/viewmodels/medication_viewmodel.dart';
import 'package:mobilev2/views/medication/add_medication_view.dart';
import 'package:provider/provider.dart';

class MedicationDetailView extends StatefulWidget {
  final MedicationSchedule schedule;
  final MedicationViewModel viewModel;

  const MedicationDetailView({
    super.key,
    required this.schedule,
    required this.viewModel,
  });

  @override
  State<MedicationDetailView> createState() => _MedicationDetailViewState();
}

class _MedicationDetailViewState extends State<MedicationDetailView> {
  @override
  void initState() {
    super.initState();
    // Load slots when entering detail view
    // Using clean addPostFrameCallback to ensure context or safe execution if needed, 
    // but direct call is usually fine in initState for Provider/ChangeNotifier if listen:false usage (which is default here as we use instance passed in widget).
    // Actually, widget.viewModel is passed in, so we can just call it.
    
    // We defer it slightly to not block init, or just call it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.generateSlotsForSchedule(widget.schedule);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Chi tiết lịch nhắc nhở',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMedicationView(schedule: widget.schedule),
                ),
              );

              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            tooltip: 'Chỉnh sửa',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context, user!.id),
            tooltip: 'Xóa',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF7F7F8),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Thông tin thuốc
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medication,
                          color: Colors.blue.shade600,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.schedule.medicationName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.schedule.dosage != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.schedule.dosage!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.schedule.notes != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Ghi chú:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.schedule.notes!,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lịch uống thuốc
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lịch uống thuốc',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.schedule,
                    'Tần suất',
                    widget.schedule.frequencyDisplay,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.access_time,
                    'Giờ uống',
                    widget.schedule.timeSlots.join(', '),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Bắt đầu',
                    _formatDate(widget.schedule.startDate),
                  ),
                  if (widget.schedule.endDate != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.event,
                      'Kết thúc',
                      _formatDate(widget.schedule.endDate!),
                    ),
                  ],
                  if (widget.schedule.nextReminder != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhắc nhở tiếp theo',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDateTime(widget.schedule.nextReminder!),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Thông báo
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cài đặt thông báo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.notifications,
                    'Thông báo trên thiết bị',
                    widget.schedule.enableLocalNotification ? 'Bật' : 'Tắt',
                    valueColor: widget.schedule.enableLocalNotification ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.email,
                    'Thông báo qua Email',
                    widget.schedule.enableEmailNotification ? 'Bật' : 'Tắt',
                    valueColor: widget.schedule.enableEmailNotification ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lịch trình chi tiết
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                if (widget.viewModel.isLoading) {
                  return _buildCard(
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (widget.viewModel.currentSlots.isEmpty) {
                  return _buildCard(
                    child: Column(
                      children: [
                         const Text(
                          'Lịch trình & Lịch sử',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Không có dữ liệu trong khoảng thời gian này',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group by date to show headers
                // But for now, just a list is fine as per request "HH:mm - dd/MM/yyyy"
                // Let's refine the UI to look like a timeline

                return _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lịch trình & Lịch sử',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.viewModel.generateSlotsForSchedule(widget.schedule);
                            }, 
                            child: const Text('Làm mới')
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.viewModel.currentSlots.length,
                        itemBuilder: (context, index) {
                          final slot = widget.viewModel.currentSlots[index];
                          final isToday = DateTime.now().day == slot.time.day && 
                                        DateTime.now().month == slot.time.month && 
                                        DateTime.now().year == slot.time.year;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isToday ? Colors.blue.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isToday ? Border.all(color: Colors.blue.shade200) : null,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  slot.status == 'taken' ? Icons.check_circle : 
                                  (slot.status == 'skipped' ? Icons.cancel : 
                                  (slot.status == 'missed' ? Icons.error_outline : Icons.schedule)),
                                  color: slot.statusColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        slot.statusDisplay,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: slot.statusColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${slot.time.hour.toString().padLeft(2, '0')}:${slot.time.minute.toString().padLeft(2, '0')} - '
                                        '${slot.time.day}/${slot.time.month}/${slot.time.year}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (slot.status == 'pending' || slot.status == 'missed')
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check),
                                        color: Colors.green,
                                        onPressed: () async {
                                          await widget.viewModel.markSlotAsTaken(slot, widget.schedule);
                                        },
                                        tooltip: 'Đã uống',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        color: Colors.orange,
                                        onPressed: () async {
                                           await widget.viewModel.markSlotAsSkipped(slot, widget.schedule, null);
                                        },
                                        tooltip: 'Bỏ qua',
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Nút hành động (General - maybe remove or keep for "Next Reminder")
            // Keeping it for now but maybe less prominent or focusing on "Next"
            // Actually, with the new timeline, the big bottom buttons might be confusing if they auto-select next.
            // Let's hide them or update them to clearly say "Mark Next: [Time]"
            // For now, I will Comment them out to force user to use the detailed list, 
            // OR I can leave them as "Quick Action" for the immediate next slot.
            // Decision: Comment out to avoid confusion as per user request for "detailed chart".
            /*
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final success = await widget.viewModel.markAsTaken(widget.schedule);

                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Đã ghi nhận uống thuốc'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // Quay lại màn hình danh sách để xem cập nhật
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Lỗi: ${widget.viewModel.error ?? "Không thể ghi nhận"}'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Lỗi: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Đã uống'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final success = await widget.viewModel.markAsSkipped(widget.schedule, null);

                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('⏭️ Đã ghi nhận bỏ qua'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // Quay lại màn hình danh sách để xem cập nhật
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Lỗi: ${widget.viewModel.error ?? "Không thể ghi nhận"}'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Lỗi: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Bỏ qua'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange.shade700,
                      side: BorderSide(color: Colors.orange.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            */

            const SizedBox(height: 32),
          ],
        ),
      );
    }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final scheduleDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (scheduleDate == today) {
      dateStr = 'Hôm nay';
    } else if (scheduleDate == tomorrow) {
      dateStr = 'Ngày mai';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  Future<void> _confirmDelete(BuildContext context, int userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa lịch nhắc nhở?'),
        content: Text(
          'Bạn có chắc chắn muốn xóa lịch nhắc nhở "${widget.schedule.medicationName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await widget.viewModel.deleteSchedule(widget.schedule.scheduleId!);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Đã xóa lịch nhắc nhở'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Không thể xóa. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
