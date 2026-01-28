import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilev2/viewmodels/health_profile_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/health_advice_bottom_sheet.dart';

class HealthProfileView extends StatelessWidget {
  const HealthProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Người dùng chưa đăng nhập')),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => HealthProfileViewModel(user.id),
          child: const _HealthProfileContent(),
        );
      },
    );
  }
}

class _HealthProfileContent extends StatefulWidget {
  const _HealthProfileContent();

  @override
  State<_HealthProfileContent> createState() => _HealthProfileContentState();
}

class _HealthProfileContentState extends State<_HealthProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  final _chronicDiseasesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _familyHistoryController = TextEditingController();
  
  int _currentStep = 0;

  @override
  void dispose() {
    _allergiesController.dispose();
    _chronicDiseasesController.dispose();
    _medicationsController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _familyHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProfileViewModel>(
      builder: (context, viewModel, child) {
        // Initialize text controllers with existing data
        if (viewModel.allergies.isNotEmpty && _allergiesController.text.isEmpty) {
          _allergiesController.text = viewModel.allergies.join(', ');
        }
        if (viewModel.chronicDiseases.isNotEmpty && _chronicDiseasesController.text.isEmpty) {
          _chronicDiseasesController.text = viewModel.chronicDiseases.join(', ');
        }
        if (viewModel.currentMedications.isNotEmpty && _medicationsController.text.isEmpty) {
          _medicationsController.text = viewModel.currentMedications.join(', ');
        }
        if (viewModel.height != null && _heightController.text.isEmpty) {
          _heightController.text = viewModel.height.toString();
        }
        if (viewModel.weight != null && _weightController.text.isEmpty) {
          _weightController.text = viewModel.weight.toString();
        }
        if (viewModel.familyHistory != null && _familyHistoryController.text.isEmpty) {
          _familyHistoryController.text = viewModel.familyHistory!;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F8),
          appBar: AppBar(
            title: const Text(
              'Hồ sơ sức khỏe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (viewModel.healthRecommendations != null || viewModel.isLoadingAdvice)
                IconButton(
                  icon: viewModel.isLoadingAdvice 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(
                            color: Colors.white, 
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.analytics_outlined),
                  tooltip: 'Xem lời khuyên sức khỏe',
                  onPressed: viewModel.isLoadingAdvice
                      ? null
                      : () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => HealthAdviceBottomSheet(
                              aiAnalysis: viewModel.aiAnalysis,
                              healthAnalysis: viewModel.healthAnalysis,
                              healthRecommendations: viewModel.healthRecommendations,
                            ),
                          );
                        },
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Đang tải hồ sơ...'),
                    ],
                  ),
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: Colors.blue.shade600),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Stepper(
                      type: StepperType.vertical,
                      currentStep: _currentStep,
                      onStepTapped: (step) => setState(() => _currentStep = step),
                      onStepContinue: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          _handleSave(viewModel);
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        }
                      },
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: viewModel.isSaving ? null : details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: viewModel.isSaving && _currentStep == 2
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : Text(_currentStep == 2 ? 'Lưu hồ sơ' : 'Tiếp tục'),
                                ),
                              ),
                              if (_currentStep > 0) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: details.onStepCancel,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Quay lại'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      steps: [
                        Step(
                          title: const Text('Thông tin cơ bản'),
                          subtitle: const Text('Ngày sinh, Giới tính, Nhóm máu'),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0 ? StepState.complete : StepState.editing,
                          content: Column(
                            children: [
                              _buildDateOfBirthField(context, viewModel),
                              const SizedBox(height: 16),
                              _buildGenderField(viewModel),
                              const SizedBox(height: 16),
                              _buildBloodTypeField(viewModel),
                            ],
                          ),
                        ),
                        Step(
                          title: const Text('Chỉ số cơ thể'),
                          subtitle: const Text('Chiều cao, Cân nặng & BMI'),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1 ? StepState.complete : (_currentStep == 1 ? StepState.editing : StepState.indexed),
                          content: Column(
                            children: [
                              _buildBMIRealtimeCard(viewModel),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildNumberField(
                                      controller: _heightController,
                                      label: 'Chiều cao (cm)',
                                      icon: Icons.height,
                                      onChanged: (val) => viewModel.setHeight(double.tryParse(val)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildNumberField(
                                      controller: _weightController,
                                      label: 'Cân nặng (kg)',
                                      icon: Icons.monitor_weight_outlined,
                                      onChanged: (val) => viewModel.setWeight(double.tryParse(val)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Step(
                          title: const Text('Tiền sử y tế'),
                          subtitle: const Text('Dị ứng, Bệnh lý & Thuốc'),
                          isActive: _currentStep >= 2,
                          state: _currentStep == 2 ? StepState.editing : StepState.indexed,
                          content: Column(
                            children: [
                              _buildTextField(
                                controller: _allergiesController,
                                label: 'Dị ứng',
                                hint: 'VD: Penicillin, Đậu phộng',
                                icon: Icons.warning_amber_rounded,
                                iconColor: Colors.orange,
                                onChanged: (value) => viewModel.setAllergiesFromString(value),
                              ),
                              if (viewModel.allergies.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildChips(viewModel.allergies, viewModel.removeAllergy),
                              ],
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _chronicDiseasesController,
                                label: 'Bệnh mãn tính',
                                hint: 'VD: Tiểu đường, Cao huyết áp',
                                icon: Icons.local_hospital,
                                iconColor: Colors.red,
                                onChanged: (value) => viewModel.setChronicDiseasesFromString(value),
                              ),
                              if (viewModel.chronicDiseases.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildChips(viewModel.chronicDiseases, viewModel.removeChronicDisease),
                              ],
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _medicationsController,
                                label: 'Thuốc đang dùng',
                                hint: 'VD: Metformin, Vitamin B12',
                                icon: Icons.medication,
                                iconColor: Colors.green,
                                onChanged: (value) => viewModel.setMedicationsFromString(value),
                              ),
                              if (viewModel.currentMedications.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildChips(viewModel.currentMedications, viewModel.removeMedication),
                              ],
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _familyHistoryController,
                                label: 'Tiền sử gia đình',
                                hint: 'VD: Bố bị tiểu đường, Mẹ bị cao huyết áp',
                                icon: Icons.family_restroom,
                                iconColor: Colors.purple,
                                showSub: false,
                                onChanged: (value) => viewModel.setFamilyHistory(value),
                              ),
                            ],
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

  Future<void> _handleSave(HealthProfileViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await viewModel.saveHealthProfile();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Lưu hồ sơ thành công!'), backgroundColor: Colors.green),
          );
          if (!viewModel.isLoadingAdvice) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => HealthAdviceBottomSheet(
                aiAnalysis: viewModel.aiAnalysis,
                healthAnalysis: viewModel.healthAnalysis,
                healthRecommendations: viewModel.healthRecommendations,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ ${viewModel.errorMessage ?? "Lỗi khi lưu hồ sơ"}'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Widget _buildBMIRealtimeCard(HealthProfileViewModel viewModel) {
    final bmi = viewModel.bmi;
    final category = viewModel.bmiCategory;
    Color color;
    if (category == 'Bình thường') color = Colors.green;
    else if (category == 'Thiếu cân') color = Colors.orange;
    else color = Colors.red;

    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.speed, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chỉ số BMI (Real-time)', style: TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  bmi != null ? bmi.toStringAsFixed(1) : '--',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Trạng thái', style: TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypeField(HealthProfileViewModel viewModel) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bloodtype, color: Colors.red),
                SizedBox(width: 16),
                Text('Nhóm máu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['A', 'B', 'AB', 'O'].map((type) {
                final isSelected = viewModel.bloodType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (val) => viewModel.setBloodType(val ? type : null),
                  selectedColor: Colors.red.shade100,
                  labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black87),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.blue.shade600),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField(BuildContext context, HealthProfileViewModel viewModel) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: viewModel.dateOfBirth ?? DateTime(1990, 1, 1),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) viewModel.setDateOfBirth(date);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.cake, color: Colors.blue.shade600),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ngày sinh', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.dateOfBirth != null ? DateFormat('dd/MM/yyyy').format(viewModel.dateOfBirth!) : 'Chọn ngày sinh',
                    style: TextStyle(fontSize: 16, color: viewModel.dateOfBirth != null ? Colors.black87 : Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField(HealthProfileViewModel viewModel) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue.shade600),
                const SizedBox(width: 16),
                const Text('Giới tính', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildGenderOption('Nam', viewModel)),
                const SizedBox(width: 8),
                Expanded(child: _buildGenderOption('Nữ', viewModel)),
                const SizedBox(width: 8),
                Expanded(child: _buildGenderOption('Khác', viewModel)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, HealthProfileViewModel viewModel) {
    final isSelected = viewModel.gender == gender;
    return InkWell(
      onTap: () => viewModel.setGender(gender),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(gender, style: TextStyle(color: isSelected ? Colors.blue.shade600 : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Function(String) onChanged,
    bool showSub = true,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 16),
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 2,
              onChanged: onChanged,
            ),
            if (showSub) ...[
              const SizedBox(height: 4),
              const Text('Phân cách bằng dấu phẩy (,)', style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<String> items, Function(String) onDelete) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Chip(
          label: Text(item),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () => onDelete(item),
          backgroundColor: Colors.blue.shade50,
          labelStyle: TextStyle(color: Colors.blue.shade800),
        );
      }).toList(),
    );
  }
}
