import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilev2/viewmodels/health_profile_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

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

  @override
  void dispose() {
    _allergiesController.dispose();
    _chronicDiseasesController.dispose();
    _medicationsController.dispose();
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.medical_information,
                                    size: 32,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thông tin y tế',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Cập nhật thông tin sức khỏe của bạn',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date of Birth
                        _buildSectionTitle('Thông tin cơ bản'),
                        const SizedBox(height: 12),
                        _buildDateOfBirthField(context, viewModel),
                        const SizedBox(height: 16),

                        // Gender
                        _buildGenderField(viewModel),
                        const SizedBox(height: 24),

                        // Allergies
                        _buildSectionTitle('Thông tin y tế'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _allergiesController,
                          label: 'Dị ứng',
                          hint: 'VD: Penicillin, Đậu phộng',
                          icon: Icons.warning_amber_rounded,
                          iconColor: Colors.orange,
                          onChanged: (value) {
                            viewModel.setAllergiesFromString(value);
                          },
                        ),
                        if (viewModel.allergies.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildChips(viewModel.allergies, viewModel.removeAllergy),
                        ],
                        const SizedBox(height: 16),

                        // Chronic Diseases
                        _buildTextField(
                          controller: _chronicDiseasesController,
                          label: 'Bệnh mãn tính',
                          hint: 'VD: Tiểu đường type 2, Cao huyết áp',
                          icon: Icons.local_hospital,
                          iconColor: Colors.red,
                          onChanged: (value) {
                            viewModel.setChronicDiseasesFromString(value);
                          },
                        ),
                        if (viewModel.chronicDiseases.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildChips(viewModel.chronicDiseases, viewModel.removeChronicDisease),
                        ],
                        const SizedBox(height: 16),

                        // Current Medications
                        _buildTextField(
                          controller: _medicationsController,
                          label: 'Thuốc đang dùng',
                          hint: 'VD: Metformin 500mg, Aspirin 100mg',
                          icon: Icons.medication,
                          iconColor: Colors.green,
                          onChanged: (value) {
                            viewModel.setMedicationsFromString(value);
                          },
                        ),
                        if (viewModel.currentMedications.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildChips(viewModel.currentMedications, viewModel.removeMedication),
                        ],
                        const SizedBox(height: 32),

                        // Save Button
                        ElevatedButton(
                          onPressed: viewModel.isSaving
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await viewModel.saveHealthProfile();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? '✅ Lưu hồ sơ thành công!'
                                                : '❌ ${viewModel.errorMessage ?? "Lỗi khi lưu hồ sơ"}',
                                          ),
                                          backgroundColor: success ? Colors.green : Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: viewModel.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Lưu hồ sơ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDateOfBirthField(BuildContext context, HealthProfileViewModel viewModel) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: viewModel.dateOfBirth ?? DateTime(1990, 1, 1),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blue.shade600,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (date != null) {
            viewModel.setDateOfBirth(date);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.cake, color: Colors.blue.shade600),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày sinh',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      viewModel.dateOfBirth != null
                          ? DateFormat('dd/MM/yyyy').format(viewModel.dateOfBirth!)
                          : 'Chọn ngày sinh',
                      style: TextStyle(
                        fontSize: 16,
                        color: viewModel.dateOfBirth != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField(HealthProfileViewModel viewModel) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue.shade600),
                const SizedBox(width: 16),
                const Text(
                  'Giới tính',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption('Nam', viewModel),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderOption('Nữ', viewModel),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderOption('Khác', viewModel),
                ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              color: isSelected ? Colors.blue.shade600 : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
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
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 2,
              onChanged: onChanged,
            ),
            const SizedBox(height: 4),
            const Text(
              'Phân cách bằng dấu phẩy (,)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
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
          deleteIconColor: Colors.blue.shade600,
        );
      }).toList(),
    );
  }
}
