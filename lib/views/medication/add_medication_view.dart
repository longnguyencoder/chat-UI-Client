import 'package:flutter/material.dart';
import 'package:mobilev2/models/medication_schedule_model.dart';
import 'package:mobilev2/providers/user_provider.dart';
import 'package:mobilev2/viewmodels/medication_viewmodel.dart';
import 'package:provider/provider.dart';

class AddMedicationView extends StatefulWidget {
  final MedicationSchedule? schedule; // null = add new, not null = edit

  const AddMedicationView({super.key, this.schedule});

  @override
  State<AddMedicationView> createState() => _AddMedicationViewState();
}

class _AddMedicationViewState extends State<AddMedicationView> {
  final _formKey = GlobalKey<FormState>();
  final _medicationNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  String _frequency = 'daily';
  List<TimeOfDay> _timeSlots = [const TimeOfDay(hour: 8, minute: 0)];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _enableLocalNotification = true;
  bool _enableEmailNotification = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _loadScheduleData();
    }
  }

  void _loadScheduleData() {
    final schedule = widget.schedule!;
    _medicationNameController.text = schedule.medicationName;
    _dosageController.text = schedule.dosage ?? '';
    _notesController.text = schedule.notes ?? '';
    _frequency = schedule.frequency;
    _timeSlots = schedule.timeSlots.map((timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }).toList();
    _startDate = schedule.startDate;
    _endDate = schedule.endDate;
    _enableLocalNotification = schedule.enableLocalNotification;
    _enableEmailNotification = schedule.enableEmailNotification;
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.schedule == null ? 'Thêm lịch nhắc nhở' : 'Sửa lịch nhắc nhở',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F7F8),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tên thuốc
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin thuốc',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _medicationNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên thuốc *',
                      hintText: 'VD: Paracetamol',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.medication),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên thuốc';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: 'Liều lượng',
                      hintText: 'VD: 1 viên 500mg',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_pharmacy),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tần suất
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tần suất uống',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Tần suất *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.schedule),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Hàng ngày')),
                      DropdownMenuItem(value: 'twice_daily', child: Text('2 lần/ngày')),
                      DropdownMenuItem(value: 'three_times_daily', child: Text('3 lần/ngày')),
                      DropdownMenuItem(value: 'weekly', child: Text('Hàng tuần')),
                      DropdownMenuItem(value: 'custom', child: Text('Tùy chỉnh')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _frequency = value!;
                        // Auto-set time slots based on frequency
                        if (value == 'daily') {
                          _timeSlots = [const TimeOfDay(hour: 8, minute: 0)];
                        } else if (value == 'twice_daily') {
                          _timeSlots = [
                            const TimeOfDay(hour: 8, minute: 0),
                            const TimeOfDay(hour: 20, minute: 0),
                          ];
                        } else if (value == 'three_times_daily') {
                          _timeSlots = [
                            const TimeOfDay(hour: 8, minute: 0),
                            const TimeOfDay(hour: 14, minute: 0),
                            const TimeOfDay(hour: 20, minute: 0),
                          ];
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Giờ uống thuốc
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giờ uống thuốc',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _addTimeSlot(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Thêm giờ'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._timeSlots.asMap().entries.map((entry) {
                    final index = entry.key;
                    final time = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _selectTime(index),
                              icon: const Icon(Icons.access_time),
                              label: Text(
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          if (_timeSlots.length > 1) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _removeTimeSlot(index),
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Thời gian
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thời gian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Ngày bắt đầu'),
                    subtitle: Text(_formatDate(_startDate)),
                    onTap: () => _selectStartDate(),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event),
                    title: const Text('Ngày kết thúc (tùy chọn)'),
                    subtitle: Text(_endDate != null ? _formatDate(_endDate!) : 'Không giới hạn'),
                    trailing: _endDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _endDate = null),
                          )
                        : null,
                    onTap: () => _selectEndDate(),
                  ),
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
                    'Thông báo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Thông báo trên thiết bị'),
                    subtitle: const Text('Nhận thông báo local'),
                    value: _enableLocalNotification,
                    onChanged: (value) {
                      setState(() => _enableLocalNotification = value);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Thông báo qua Email'),
                    subtitle: const Text('Nhận email nhắc nhở'),
                    value: _enableEmailNotification,
                    onChanged: (value) {
                      setState(() => _enableEmailNotification = value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ghi chú
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ghi chú',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'VD: Uống sau bữa ăn',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nút lưu
            ElevatedButton(
              onPressed: _isLoading ? null : () => _saveSchedule(user!.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.schedule == null ? 'Tạo lịch nhắc nhở' : 'Cập nhật',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),

            const SizedBox(height: 32),
          ],
        ),
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

  void _addTimeSlot() {
    setState(() {
      _timeSlots.add(const TimeOfDay(hour: 12, minute: 0));
    });
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  Future<void> _selectTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _timeSlots[index],
    );

    if (time != null) {
      setState(() {
        _timeSlots[index] = time;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 7)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _saveSchedule(int userId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final schedule = MedicationSchedule(
      scheduleId: widget.schedule?.scheduleId,
      userId: userId,
      medicationName: _medicationNameController.text.trim(),
      dosage: _dosageController.text.trim().isEmpty ? null : _dosageController.text.trim(),
      frequency: _frequency,
      timeSlots: _timeSlots.map((time) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }).toList(),
      startDate: _startDate,
      endDate: _endDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      enableLocalNotification: _enableLocalNotification,
      enableEmailNotification: _enableEmailNotification,
    );

    bool success;
    if (widget.schedule == null) {
      // Create new
      final viewModel = MedicationViewModel(userId);
      success = await viewModel.createSchedule(schedule);
    } else {
      // Update existing
      final viewModel = MedicationViewModel(userId);
      success = await viewModel.updateSchedule(widget.schedule!.scheduleId!, schedule);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.schedule == null 
                ? '✅ Đã tạo lịch nhắc nhở' 
                : '✅ Đã cập nhật lịch nhắc nhở'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Có lỗi xảy ra. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
