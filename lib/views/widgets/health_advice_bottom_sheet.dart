import 'package:flutter/material.dart';

/// Bottom sheet hiển thị lời khuyên sức khỏe với 3 tabs
class HealthAdviceBottomSheet extends StatefulWidget {
  final String? aiAnalysis;
  final dynamic healthAnalysis;
  final dynamic healthRecommendations;

  const HealthAdviceBottomSheet({
    super.key,
    this.aiAnalysis,
    this.healthAnalysis,
    this.healthRecommendations,
  });

  @override
  State<HealthAdviceBottomSheet> createState() => _HealthAdviceBottomSheetState();
}

class _HealthAdviceBottomSheetState extends State<HealthAdviceBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.health_and_safety, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Lời khuyên sức khỏe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Tổng quan'),
                    Tab(text: 'Phân tích'),
                    Tab(text: 'Lời khuyên'),
                  ],
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAnalysisTab(),
                _buildRecommendationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 1: Tổng quan AI Analysis
  Widget _buildOverviewTab() {
    if (widget.aiAnalysis == null || widget.aiAnalysis!.isEmpty) {
      return _buildEmptyState('Chưa có phân tích AI');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.blue.shade600, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Phân tích AI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.aiAnalysis!,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tab 2: Phân tích chi tiết (BMI, chronic conditions)
  Widget _buildAnalysisTab() {
    if (widget.healthAnalysis == null) {
      return _buildEmptyState('Chưa có dữ liệu phân tích');
    }

    final analysis = widget.healthAnalysis;
    final bmi = analysis['bmi'];
    final chronicConditions = analysis['chronic_conditions_analysis'] ?? [];
    final status = analysis['overall_health_status'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BMI Card
          if (bmi != null) ...[
            _buildBMICard(bmi),
            const SizedBox(height: 16),
          ],

          // Health Status
          _buildHealthStatusCard(status),
          const SizedBox(height: 16),

          // Chronic Conditions
          if (chronicConditions.isNotEmpty) ...[
            const Text(
              'Bệnh mãn tính',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...chronicConditions.map((condition) => _buildConditionCard(condition)),
          ],
        ],
      ),
    );
  }

  /// Tab 3: Lời khuyên (diet, rest, exercise)
  Widget _buildRecommendationsTab() {
    if (widget.healthRecommendations == null) {
      return _buildEmptyState('Chưa có lời khuyên');
    }

    final recommendations = widget.healthRecommendations;
    final diet = recommendations['diet'];
    final rest = recommendations['rest'];
    final exercise = recommendations['exercise'];
    final aiInsights = recommendations['ai_insights'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diet
          if (diet != null) ...[
            _buildRecommendationCard(
              title: 'Chế độ ăn uống',
              icon: Icons.restaurant,
              color: Colors.orange,
              summary: diet['summary'],
              recommendations: diet['recommendations'],
              extras: {
                'Nên ăn': diet['foods_to_include'],
                'Nên tránh': diet['foods_to_avoid'],
              },
            ),
            const SizedBox(height: 16),
          ],

          // Rest
          if (rest != null) ...[
            _buildRecommendationCard(
              title: 'Nghỉ ngơi',
              icon: Icons.bedtime,
              color: Colors.purple,
              summary: 'Ngủ ${rest['sleep_hours']} mỗi ngày',
              recommendations: rest['recommendations'],
            ),
            const SizedBox(height: 16),
          ],

          // Exercise
          if (exercise != null) ...[
            _buildRecommendationCard(
              title: 'Tập luyện',
              icon: Icons.fitness_center,
              color: Colors.green,
              summary: '${exercise['frequency']} - ${exercise['duration']}',
              recommendations: exercise['recommendations'],
              extras: {
                'Các bài tập': exercise['types'],
              },
            ),
            const SizedBox(height: 16),
          ],

          // AI Insights
          if (aiInsights.isNotEmpty) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.blue.shade600, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Phân tích chuyên sâu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      aiInsights,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBMICard(Map<String, dynamic> bmi) {
    final value = bmi['value'] ?? 0.0;
    final category = bmi['category_label'] ?? '';
    final assessment = bmi['assessment'] ?? '';
    final recommendations = bmi['recommendations'] ?? [];

    Color getColor() {
      final cat = bmi['category'] ?? '';
      if (cat == 'underweight') return Colors.blue;
      if (cat == 'normal') return Colors.green;
      if (cat == 'overweight') return Colors.orange;
      if (cat == 'obese') return Colors.red;
      return Colors.grey;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_weight, color: getColor(), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Chỉ số BMI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: getColor(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: getColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (assessment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(assessment, style: const TextStyle(fontSize: 14)),
            ],
            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: getColor(), size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatusCard(String status) {
    String label = 'Chưa xác định';
    Color color = Colors.grey;
    IconData icon = Icons.help_outline;

    if (status == 'good') {
      label = 'Tốt';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (status == 'needs_attention') {
      label = 'Cần chú ý';
      color = Colors.orange;
      icon = Icons.warning;
    } else if (status == 'critical') {
      label = 'Nghiêm trọng';
      color = Colors.red;
      icon = Icons.error;
    }

    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tình trạng sức khỏe', style: TextStyle(fontSize: 12)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    final name = condition['condition'] ?? '';
    final dietRecs = condition['diet_recommendations'] ?? [];
    final exerciseRecs = condition['exercise_recommendations'] ?? [];
    final monitoring = condition['monitoring'] ?? [];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (dietRecs.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('🍽️ Chế độ ăn:', style: TextStyle(fontWeight: FontWeight.w500)),
              ...dietRecs.map((rec) => Text('  • $rec', style: const TextStyle(fontSize: 13))),
            ],
            if (exerciseRecs.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('🏃 Tập luyện:', style: TextStyle(fontWeight: FontWeight.w500)),
              ...exerciseRecs.map((rec) => Text('  • $rec', style: const TextStyle(fontSize: 13))),
            ],
            if (monitoring.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('📊 Theo dõi:', style: TextStyle(fontWeight: FontWeight.w500)),
              ...monitoring.map((rec) => Text('  • $rec', style: const TextStyle(fontSize: 13))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required IconData icon,
    required Color color,
    String? summary,
    List<dynamic>? recommendations,
    Map<String, dynamic>? extras,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (summary != null && summary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(summary, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
            if (recommendations != null && recommendations.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: color, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )),
            ],
            if (extras != null) ...[
              ...extras.entries.map((entry) {
                final items = entry.value as List<dynamic>?;
                if (items == null || items.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    ...items.map((item) => Text('  • $item', style: const TextStyle(fontSize: 13))),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
