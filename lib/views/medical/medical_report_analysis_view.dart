import 'package:flutter/material.dart';
import 'package:mobilev2/providers/user_provider.dart';
import 'package:mobilev2/viewmodels/medical_report_viewmodel.dart';
import 'package:mobilev2/models/medical_report_analysis_model.dart';
import 'package:provider/provider.dart';

class MedicalReportAnalysisView extends StatelessWidget {
  const MedicalReportAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalReportViewModel>();
    final userProvider = context.read<UserProvider>();
    final token = userProvider.token ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phân tích xét nghiệm (PDF/Ảnh)"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection(context, viewModel, token),
            if (viewModel.status == AnalysisStatus.loading)
              _buildLoadingState(),
            if (viewModel.status == AnalysisStatus.error)
              _buildErrorState(viewModel.error),
            if (viewModel.analysis != null)
              _buildResultsSection(viewModel.analysis!),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, MedicalReportViewModel viewModel, String token) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (viewModel.selectedFile != null && ['jpg', 'jpeg', 'png'].contains(viewModel.selectedFile!.name.split('.').last.toLowerCase()))
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  viewModel.selectedFile!.bytes!,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              )
            else
              const Icon(Icons.picture_as_pdf, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              "Tải lên file PDF hoặc Ảnh xét nghiệm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Hệ thống sẽ sử dụng AI để trích xuất chỉ số và đưa ra nhận định chuyên môn.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: viewModel.status == AnalysisStatus.loading ? null : () => viewModel.pickFile(),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Chọn file (PDF/Ảnh)"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                if (viewModel.selectedFile != null) ...[
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: viewModel.status == AnalysisStatus.loading ? null : () => viewModel.analyzeReport(token),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Phân tích ngay"),
                  ),
                ],
              ],
            ),
            if (viewModel.selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Đã chọn: ${viewModel.selectedFile!.name}",
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("AI đang phân tích kết quả của bạn..."),
            Text("(Có thể mất 5-10 giây)", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(error ?? "Đã xảy ra lỗi không xác định", style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(MedicalReportAnalysis analysis) {
    final data = analysis.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text("KẾT QUẢ PHÂN TÍCH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Divider(),
        
        // Patient Info
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text("Bệnh nhân: ${data.patientInfo.name}"),
          subtitle: Text("Ngày xét nghiệm: ${data.patientInfo.date}"),
          leading: const Icon(Icons.person, color: Colors.blue),
        ),

        const SizedBox(height: 16),
        const Text("Chi tiết chỉ số:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Indicators Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
            columns: const [
              DataColumn(label: Text('Chỉ số')),
              DataColumn(label: Text('Kết quả')),
              DataColumn(label: Text('Tham chiếu')),
              DataColumn(label: Text('Đơn vị')),
              DataColumn(label: Text('Trạng thái')),
            ],
            rows: data.indicators.map((indicator) {
              final isAbnormal = indicator.isAbnormal;
              return DataRow(cells: [
                DataCell(Text(indicator.name, style: TextStyle(fontWeight: isAbnormal ? FontWeight.bold : FontWeight.normal))),
                DataCell(Text(indicator.result, style: TextStyle(color: isAbnormal ? Colors.red : Colors.black))),
                DataCell(Text(indicator.referenceRange)),
                DataCell(Text(indicator.unit)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAbnormal ? Colors.red.shade100 : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      indicator.status,
                      style: TextStyle(color: isAbnormal ? Colors.red.shade700 : Colors.green.shade700, fontSize: 12),
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),
        _buildSummaryCard("Tóm tắt", data.summary, Icons.summarize, Colors.blue),
        const SizedBox(height: 12),
        _buildSummaryCard("Lời khuyên bác sĩ (AI)", data.advice, Icons.medical_information, Colors.orange),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String content, IconData icon, Color color) {
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
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
