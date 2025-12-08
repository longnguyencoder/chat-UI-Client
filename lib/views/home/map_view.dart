import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/itinerary_item.dart';
import '../../viewmodels/home/map_viewmodel.dart';
import '../widgets/save_itinerary_dialog.dart';
import '../widgets/attraction_info_card.dart';
import '../widgets/itinerary_item_card.dart';
import '../widgets/attraction_chip.dart';
import '../widgets/legend_item.dart';
import '../../providers/user_provider.dart';

class MapView extends StatelessWidget {
  final List<String> places;
  final int conversationId;
  final String language;

  const MapView({
    super.key,
    required this.places,
    required this.conversationId,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: _MapViewContent(
        places: places,
        conversationId: conversationId,
        language: language,
      ),
    );
  }
}

class _MapViewContent extends StatefulWidget {
  final List<String> places;
  final int conversationId;
  final String language;

  const _MapViewContent({
    required this.places,
    required this.conversationId,
    required this.language,
  });

  @override
  State<_MapViewContent> createState() => _MapViewContentState();
}

class _MapViewContentState extends State<_MapViewContent>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<MapViewModel>(context, listen: false);
      viewModel.initialize(widget.places, widget.conversationId, widget.language);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bản đồ du lịch'),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.map), text: 'Bản đồ'),
                Tab(icon: Icon(Icons.calendar_today), text: 'Lịch trình'),
                Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  viewModel.getCurrentLocation();
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _showSearchDialog(context, viewModel);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng chia sẻ đang được phát triển'),
                    ),
                  );
                },
              ),
            ],
          ),
          body:
              viewModel.isLoading
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Đang tải bản đồ...'),
                      ],
                    ),
                  )
                  : TabBarView(
                    controller: _tabController,
                    children: [
                      _MapTab(viewModel: viewModel),
                      _CalendarTab(viewModel: viewModel),
                      _TimelineTab(viewModel: viewModel),
                    ],
                  ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context, MapViewModel viewModel) {
    String selectedLanguage = 'vietnamese';
    final queryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tìm kiếm địa điểm'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Language selection
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: const InputDecoration(
                    labelText: 'Ngôn ngữ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'vietnamese', child: Text('Tiếng Việt')),
                    DropdownMenuItem(value: 'english', child: Text('English')),
                    DropdownMenuItem(value: 'chinese', child: Text('中文')),
                    DropdownMenuItem(value: 'korean', child: Text('한국어')),
                    DropdownMenuItem(value: 'japanese', child: Text('日本語')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Search query
                TextField(
                  controller: queryController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tên địa điểm...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      viewModel.searchAttractions(query, language: selectedLanguage);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  final query = queryController.text.trim();
                  if (query.isNotEmpty) {
                    viewModel.searchAttractions(query, language: selectedLanguage);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tìm kiếm'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Tab bản đồ
class _MapTab extends StatelessWidget {
  final MapViewModel viewModel;

  const _MapTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thông tin vị trí hiện tại
        if (viewModel.currentPosition != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.green.shade50,
            child: Row(
              children: [
                Icon(Icons.my_location, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 6),
                Text(
                  'Vị trí hiện tại: ${viewModel.currentPosition!.latitude.toStringAsFixed(4)}, ${viewModel.currentPosition!.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // Địa điểm được phát hiện với chú thích màu sắc
        if (viewModel.detectedAttractions.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 12,
              top: 0,
              right: 12,
              bottom: 10,
            ),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Địa điểm được phát hiện (${viewModel.detectedAttractions.length}):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    // Button toggle route
                    if (viewModel.todayItinerary.length >= 2)
                      IconButton(
                        onPressed: () {
                          // Toggle hiển thị route
                          if (viewModel.polylines.isNotEmpty) {
                            viewModel.clearSelection();
                          } else {
                            // Vẽ lại route cho lịch trình hôm nay
                            viewModel.selectDate(viewModel.selectedDate);
                          }
                        },
                        icon: Icon(
                          viewModel.polylines.isNotEmpty
                              ? Icons.route_outlined
                              : Icons.route,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                        tooltip:
                            viewModel.polylines.isNotEmpty
                                ? 'Ẩn tuyến đường'
                                : 'Hiện tuyến đường',
                      ),
                  ],
                ),

                // Chú thích màu sắc marker
                Wrap(
                  spacing: 12,
                  children: [
                    LegendItem(color: Colors.blue, label: 'Vị trí hiện tại'),
                    LegendItem(color: Colors.red, label: 'Địa điểm'),
                    LegendItem(color: Colors.orange, label: 'Trong lịch trình'),
                    LegendItem(color: Colors.green, label: 'Đang chọn'),
                  ],
                ),

                const SizedBox(height: 8),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.detectedAttractions.length,
                    itemBuilder: (context, index) {
                      final attraction = viewModel.detectedAttractions[index];
                      final isSelected =
                          viewModel.selectedAttraction?.id == attraction.id;
                      final isInItinerary = viewModel.todayItinerary.any(
                        (item) => item.attraction.id == attraction.id,
                      );

                      return AttractionChip(
                        attraction: attraction,
                        isSelected: isSelected,
                        isInItinerary: isInItinerary,
                        onTap: () => viewModel.selectAttraction(attraction),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        // Thông tin tuyến đường (nếu có)
        if (viewModel.polylines.isNotEmpty &&
            viewModel.todayItinerary.length >= 2)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                Icon(Icons.route, size: 16, color: Colors.blue.shade600),
                const SizedBox(width: 6),
                Text(
                  'Đang hiển thị tuyến đường cho ${viewModel.todayItinerary.length} địa điểm',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                ),
                const Spacer(),
                Text(
                  '${viewModel.polylines.length} đoạn đường',
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade500),
                ),
              ],
            ),
          ),

        // Bản đồ Mapbox
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: viewModel.mapController,
                options: MapOptions(
                  center: viewModel.initialPosition,
                  zoom: 12.0,
                  onMapReady: () {
                    viewModel.onMapCreated();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: {
                      'accessToken': viewModel.mapboxAccessToken,
                    },
                  ),
                  PolylineLayer(polylines: viewModel.polylines),
                  MarkerLayer(markers: viewModel.markers),
                ],
              ),

              // Loading overlay khi đang lấy vị trí
              if (viewModel.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Đang lấy vị trí hiện tại...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

              // Floating action buttons
              Positioned(
                right: 16,
                bottom: 100,
                child: Column(
                  children: [
                    // Button về vị trí hiện tại
                    FloatingActionButton(
                      mini: true,
                      heroTag: "current_location",
                      onPressed: () {
                        viewModel.getCurrentLocation();
                      },
                      backgroundColor: Colors.blue.shade600,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),

                    const SizedBox(height: 8),

                    // Button hiện/ẩn tuyến đường
                    if (viewModel.todayItinerary.length >= 2)
                      FloatingActionButton(
                        mini: true,
                        heroTag: "toggle_route",
                        onPressed: () {
                          if (viewModel.polylines.isNotEmpty) {
                            viewModel.clearSelection();
                          } else {
                            viewModel.selectDate(viewModel.selectedDate);
                          }
                        },
                        backgroundColor:
                            viewModel.polylines.isNotEmpty
                                ? Colors.green.shade600
                                : Colors.grey.shade600,
                        child: Icon(Icons.route, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Thông tin địa điểm được chọn
        if (viewModel.selectedAttraction != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: AttractionInfoCard(
              attraction: viewModel.selectedAttraction!,
              onAddToItinerary:
                  () => _showAddToItineraryDialog(context, viewModel),
              onClose: () => viewModel.clearSelection(),
            ),
          ),
      ],
    );
  }

  void _showAddToItineraryDialog(BuildContext context, MapViewModel viewModel) {
    DateTime selectedDate = viewModel.selectedDate;
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
    Duration selectedDuration = const Duration(hours: 2);
    String notes = '';
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.add_location, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    const Text('Thêm vào lịch trình'),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Thông tin địa điểm
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.blue.shade600, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Thông tin địa điểm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              viewModel.selectedAttraction!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              viewModel.selectedAttraction!.address,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange.shade600, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${viewModel.selectedAttraction!.rating}/5',
                                  style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
                                ),
                                if (viewModel.selectedAttraction!.price != null) ...[
                                  const SizedBox(width: 12),
                                  Icon(Icons.attach_money, color: Colors.green.shade600, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${viewModel.selectedAttraction!.price!.toInt()} VND',
                                    style: TextStyle(color: Colors.green.shade600, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Chọn ngày
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue.shade600),
                        title: Text(
                          'Ngày: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                        subtitle: const Text('Chọn ngày tham quan'),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                      ),
                      
                      // Chọn giờ
                      ListTile(
                        leading: Icon(Icons.access_time, color: Colors.blue.shade600),
                        title: Text('Giờ: ${selectedTime.format(context)}'),
                        subtitle: const Text('Chọn giờ bắt đầu'),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                            });
                          }
                        },
                      ),
                      
                      // Chọn thời lượng
                      ListTile(
                        leading: Icon(Icons.timer, color: Colors.green.shade600),
                        title: Text('Thời lượng: ${selectedDuration.inHours} giờ ${selectedDuration.inMinutes % 60} phút'),
                        subtitle: const Text('Thời gian dự kiến tham quan'),
                        onTap: () async {
                          final hours = await showDialog<int>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Chọn thời lượng'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Số giờ:'),
                                  DropdownButton<int>(
                                    value: selectedDuration.inHours,
                                    items: List.generate(8, (index) => index + 1)
                                        .map((hour) => DropdownMenuItem(
                                              value: hour,
                                              child: Text('$hour giờ'),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDuration = Duration(hours: value!);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Ghi chú
                      const SizedBox(height: 8),
                      TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: 'Ghi chú (tùy chọn)',
                          hintText: 'Nhập ghi chú cho địa điểm này...',
                          prefixIcon: Icon(Icons.note, color: Colors.orange.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.orange.shade600),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          notes = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.addToItinerary(
                        viewModel.selectedAttraction!,
                        date: selectedDate,
                        time: selectedTime,
                        notes: notes,
                        estimatedDuration: selectedDuration,
                      );
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Đã thêm ${viewModel.selectedAttraction!.name} vào lịch trình',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm vào lịch trình'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

// Tab lịch
class _CalendarTab extends StatelessWidget {
  final MapViewModel viewModel;

  const _CalendarTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar widget
        TableCalendar<ItineraryItem>(
          firstDay: DateTime.now().subtract(const Duration(days: 30)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: viewModel.selectedDate,
          selectedDayPredicate: (day) => isSameDay(viewModel.selectedDate, day),
          eventLoader: (day) {
            final dateKey = DateTime(day.year, day.month, day.day);
            return viewModel.dailyItineraries[dateKey] ?? [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            viewModel.selectDate(selectedDay);
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            markerDecoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orange.shade600,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),

        const Divider(),

        // Danh sách lịch trình trong ngày
        Expanded(
          child:
              viewModel.todayItinerary.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có lịch trình cho ngày này',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thêm địa điểm từ tab Bản đồ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.todayItinerary.length,
                    onReorder: viewModel.reorderItinerary,
                    itemBuilder: (context, index) {
                      final item = viewModel.todayItinerary[index];
                      return ItineraryItemCard(
                        key: ValueKey(
                          item.attraction.id + item.visitTime.toString(),
                        ),
                        item: item,
                        index: index,
                        onRemove: () => _showRemoveItineraryDialog(context, viewModel, item),
                        onEdit:
                            () => _showEditItineraryDialog(
                              context,
                              viewModel,
                              item,
                            ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  void _showEditItineraryDialog(
    BuildContext context,
    MapViewModel viewModel,
    ItineraryItem item,
  ) {
    DateTime selectedDate = item.visitTime;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(item.visitTime);
    Duration selectedDuration = item.estimatedDuration;
    String notes = item.notes;
    final notesController = TextEditingController(text: notes);

    showDialog(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Chỉnh sửa lịch trình'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          'Ngày: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text('Giờ: ${selectedTime.format(context)}'),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.timer),
                        title: Text(
                          'Thời gian dự kiến: ${selectedDuration.inHours}h ${selectedDuration.inMinutes % 60}m',
                        ),
                        onTap: () {
                          _showDurationPicker(context, selectedDuration, (
                            duration,
                          ) {
                            setState(() {
                              selectedDuration = duration;
                            });
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú',
                          hintText: 'Thêm ghi chú cho địa điểm này...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) => notes = value,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newItem = item.copyWith(
                        visitTime: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        estimatedDuration: selectedDuration,
                        notes: notes,
                      );
                      viewModel.updateItineraryItem(item, newItem);
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã cập nhật lịch trình'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Lưu'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showRemoveItineraryDialog(
      BuildContext context,
      MapViewModel viewModel,
      ItineraryItem item,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa lịch trình tại địa điểm "${item.attraction.name}" vào lúc ${TimeOfDay.fromDateTime(item.visitTime).format(context)} không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                viewModel.removeFromItinerary(item);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa lịch trình'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showDurationPicker(
    BuildContext context,
    Duration currentDuration,
    Function(Duration) onDurationSelected,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chọn thời gian'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('30 phút'),
                  onTap: () {
                    onDurationSelected(const Duration(minutes: 30));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('1 giờ'),
                  onTap: () {
                    onDurationSelected(const Duration(hours: 1));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('2 giờ'),
                  onTap: () {
                    onDurationSelected(const Duration(hours: 2));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('3 giờ'),
                  onTap: () {
                    onDurationSelected(const Duration(hours: 3));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Nửa ngày (4 giờ)'),
                  onTap: () {
                    onDurationSelected(const Duration(hours: 4));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Cả ngày (8 giờ)'),
                  onTap: () {
                    onDurationSelected(const Duration(hours: 8));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}

// Tab timeline
class _TimelineTab extends StatelessWidget {
  final MapViewModel viewModel;

  const _TimelineTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date selector
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(
                'Lịch trình ngày ${viewModel.selectedDate.day}/${viewModel.selectedDate.month}/${viewModel.selectedDate.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: viewModel.selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    viewModel.selectDate(date);
                  }
                },
                icon: const Icon(Icons.edit_calendar),
              ),
            ],
          ),
        ),

        const Divider(),

        // Timeline
        Expanded(
          child:
              viewModel.todayItinerary.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timeline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có lịch trình cho ngày này',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.todayItinerary.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.todayItinerary[index];
                      final isLast =
                          index == viewModel.todayItinerary.length - 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline column
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  TimeOfDay.fromDateTime(
                                    item.visitTime,
                                  ).format(context),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.estimatedDuration.inHours}h ${item.estimatedDuration.inMinutes % 60}m',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Timeline line
                          Column(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 80,
                                  color: Colors.blue.shade300,
                                ),
                            ],
                          ),

                          const SizedBox(width: 12),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.attraction.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.attraction.address,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (item.notes.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            item.notes,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            Text(
                                              ' ${item.attraction.rating}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (item.attraction.price != null)
                                              Text(
                                                '${NumberFormat('#,###', 'vi_VN').format(item.attraction.price)}đ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.green.shade600,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại chat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      viewModel.todayItinerary.isEmpty
                          ? null
                          : () async {
                              // Show confirmation dialog
                              final userProvider = Provider.of<UserProvider>(context, listen: false);
                              final currentUser = userProvider.user;

                              await SaveItineraryDialog.show(
                                context,
                                itinerary: viewModel.todayItinerary,
                                selectedDate: viewModel.selectedDate,
                                userId: currentUser?.id, // Lấy user ID từ provider
                              );
                            },
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu lịch trình'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
