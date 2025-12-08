import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobilev2/services/home/itinerary_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../helpers/hcm_map_helper.dart';
import '../../models/itinerary_item.dart';

class SaveItineraryDialog extends StatefulWidget {
  final List<ItineraryItem> itinerary;
  final DateTime selectedDate;
  final int? userId;

  const SaveItineraryDialog({
    super.key,
    required this.itinerary,
    required this.selectedDate,
    this.userId,
  });

  static Future<void> show(
    BuildContext context, {
    required List<ItineraryItem> itinerary,
    required DateTime selectedDate,
    int? userId,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => SaveItineraryDialog(
        itinerary: itinerary,
        selectedDate: selectedDate,
        userId: userId,
      ),
    );
  }

  @override
  State<SaveItineraryDialog> createState() => _SaveItineraryDialogState();
}

class _SaveItineraryDialogState extends State<SaveItineraryDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _printItineraryInfo();
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.save, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
              child: Text(
            'Xác nhận lưu lịch trình',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22, color: Colors.green),
          ))
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn có muốn lưu lịch trình cho ngày ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}?',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          // Text input cho tên chuyến du lịch
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Tên chuyến du lịch',
              hintText: 'Nhập tên chuyến du lịch...',
              border: OutlineInputBorder(),
              errorText: _errorText,
              prefixIcon: Icon(Icons.edit_location_alt, color: Colors.blue),
            ),
            maxLength: 50,
            onChanged: (_) {
              setState(() {
                _errorText = null;
              });
            },
          ),
          if (widget.userId == null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                'Bạn cần đăng nhập để lưu lịch trình vào tài khoản.',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          // Thông tin lịch trình
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
                    Icon(
                      MdiIcons.informationOutline,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Thông tin lịch trình:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('• Số địa điểm: ${widget.itinerary.length}'),
                Text('• Thời gian bắt đầu: ${_getStartTime()}'),
                Text('• Thời gian kết thúc: ${_getEndTime()}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(MdiIcons.checkCircle, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    const Text(
                      'Xuất lịch trình thành file PDF',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(MdiIcons.checkCircle, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    const Text(
                      'Bao gồm bản đồ Hồ Chí Minh',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: widget.userId == null
              ? null
              : () async {
                  if (_nameController.text.trim().isEmpty) {
                    setState(() {
                      _errorText = 'Vui lòng nhập tên chuyến du lịch';
                    });
                    return;
                  }
                  // Close the confirmation dialog
                  Navigator.of(context).pop();
                  // Handle saving and PDF generation
                  await _handleSaveAndPDF(context, _nameController.text.trim());
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
          ),
          child: const Text('Xác nhận lưu'),
        ),
      ],
    );
  }

  Future<void> _handleSaveAndPDF(BuildContext context, String itineraryName) async {
    print('💾 BẮT ĐẦU LƯU LỊCH TRÌNH...');
    print('📅 Ngày: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}');
    print('📍 Số địa điểm: ${widget.itinerary.length}');
    print('⏰ Thời gian: ${_getStartTime()} - ${_getEndTime()}');
    print('💰 Tổng chi phí: ${_formatPrice(_getTotalPrice())} VND');
    print('Tên chuyến du lịch: $itineraryName');
    print('👤 User ID: ${widget.userId}');
    print('-' * 40);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang lưu vào database...'),
            ],
          ),
        );
      },
    );

    try {
      bool success = false;
      if (widget.userId != null) {
        final itineraryService = ItineraryService();
        success = await itineraryService.saveItinerary(
          itinerary: widget.itinerary,
          selectedDate: widget.selectedDate,
          userId: widget.userId!,
          title: itineraryName,
        );
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Lịch trình đã lưu thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          // Generate and show PDF after successful save
          await _generateAndShowPdf(context);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Lỗi khi lưu vào database'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi kết nối: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generateAndShowPdf(BuildContext context) async {
    try {
      // Load fonts
      final fontRegular = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();
      final fontItalic = await PdfGoogleFonts.robotoItalic();

      // Load Material Design Icons font từ package
      pw.Font? iconFont;
      try {
        final iconFontData = await rootBundle.load(
          'packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf',
        );
        iconFont = pw.Font.ttf(iconFontData);
      } catch (e) {
        print('Could not load MDI font: $e');
      }

      // Tạo bản đồ tĩnh
      final mapImage = await _generateMapImage();

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              // Trang đầu tiên với layout 2 cột
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Cột bên trái - Lịch trình chi tiết
                  pw.Expanded(
                    flex: 3,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.teal700,
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề lịch trình
                          pw.Text(
                            'Hồ Chí Minh - ngày ${widget.selectedDate.day}',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 24,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 20),

                          // Timeline lịch trình
                          ...widget.itinerary.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final isLast = index == widget.itinerary.length - 1;

                            return pw.Column(
                              children: [
                                pw.Row(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    // Cột thời gian
                                    pw.Container(
                                      width: 50,
                                      child: pw.Text(
                                        '${item.visitTime.hour.toString().padLeft(2, '0')}:${item.visitTime.minute.toString().padLeft(2, '0')}',
                                        style: pw.TextStyle(
                                          font: fontBold,
                                          fontSize: 14,
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),

                                    // Cột timeline
                                    pw.Container(
                                      width: 20,
                                      child: pw.Column(
                                        children: [
                                          pw.Container(
                                            width: 12,
                                            height: 12,
                                            decoration: pw.BoxDecoration(
                                              color: PdfColors.white,
                                              shape: pw.BoxShape.circle,
                                            ),
                                          ),
                                          if (!isLast)
                                            pw.Container(
                                              width: 2,
                                              height: 60,
                                              color: PdfColors.white,
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Cột nội dung
                                    pw.Expanded(
                                      child: pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            item.attraction.name,
                                            style: pw.TextStyle(
                                              font: fontBold,
                                              fontSize: 16,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                          pw.SizedBox(height: 4),
                                          pw.Text(
                                            'Thời gian tham quan: ${_formatDuration(item.estimatedDuration)}',
                                            style: pw.TextStyle(
                                              font: fontRegular,
                                              fontSize: 12,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: isLast ? 0 : 10),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 15),

                  // Cột bên phải - Bản đồ và thông tin tổng quan
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề và ngày
                        pw.Container(
                          padding: const pw.EdgeInsets.all(15),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue600,
                            borderRadius: pw.BorderRadius.circular(10),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(
                                'Lịch trình du lịch',
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: 20,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text(
                                '${widget.selectedDate.day} THÁNG ${widget.selectedDate.month} ${widget.selectedDate.year}',
                                style: pw.TextStyle(
                                  font: fontRegular,
                                  fontSize: 14,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                '${widget.itinerary.length} ĐỊA ĐIỂM',
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: 12,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        pw.SizedBox(height: 15),

                        // Bản đồ Hồ Chí Minh
                        if (mapImage != null)
                          pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300),
                              borderRadius: pw.BorderRadius.circular(10),
                            ),
                            child: pw.ClipRRect(
                              horizontalRadius: 10,
                              verticalRadius: 10,
                              child: pw.Image(mapImage as pw.ImageProvider),
                            ),
                          ),

                        pw.SizedBox(height: 15),

                        // Thông tin tổng quan
                        pw.Container(
                          padding: const pw.EdgeInsets.all(15),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey100,
                            borderRadius: pw.BorderRadius.circular(10),
                            border: pw.Border.all(color: PdfColors.grey300),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                children: [
                                  _buildMDIIcon(
                                    iconFont,
                                    MdiIcons.informationOutline,
                                    PdfColors.blue800,
                                    18,
                                  ),
                                  pw.SizedBox(width: 8),
                                  pw.Text(
                                    'THÔNG TIN CHUYẾN ĐI',
                                    style: pw.TextStyle(
                                      font: fontBold,
                                      fontSize: 14,
                                      color: PdfColors.blue800,
                                    ),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 10),

                              pw.Row(
                                children: [
                                  _buildMDIIcon(
                                    iconFont,
                                    MdiIcons.clockOutline,
                                    PdfColors.blue600,
                                    14,
                                  ),
                                  pw.SizedBox(width: 6),
                                  pw.Text(
                                    'Bắt đầu: ${_getStartTime()}',
                                    style: pw.TextStyle(
                                      font: fontRegular,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  _buildMDIIcon(
                                    iconFont,
                                    MdiIcons.clockOutline,
                                    PdfColors.blue600,
                                    14,
                                  ),
                                  pw.SizedBox(width: 6),
                                  pw.Text(
                                    'Kết thúc: ${_getEndTime()}',
                                    style: pw.TextStyle(
                                      font: fontRegular,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  _buildMDIIcon(
                                    iconFont,
                                    MdiIcons.timerOutline,
                                    PdfColors.blue600,
                                    14,
                                  ),
                                  pw.SizedBox(width: 6),
                                  pw.Text(
                                    'Tổng thời gian: ${_getTotalDuration()}',
                                    style: pw.TextStyle(
                                      font: fontRegular,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              if (_getTotalPrice() > 0) ...[
                                pw.SizedBox(height: 4),
                                pw.Row(
                                  children: [
                                    _buildMDIIcon(
                                      iconFont,
                                      MdiIcons.currencyUsd,
                                      PdfColors.green600,
                                      14,
                                    ),
                                    pw.SizedBox(width: 6),
                                    pw.Text(
                                      'Chi phí: ${_formatPrice(_getTotalPrice())} VND',
                                      style: pw.TextStyle(
                                        font: fontBold,
                                        fontSize: 12,
                                        color: PdfColors.green600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Trang thứ hai - Chi tiết các địa điểm
              pw.Header(
                level: 1,
                child: pw.Row(
                  children: [
                    _buildMDIIcon(
                      iconFont,
                      MdiIcons.mapMarkerRadius,
                      PdfColors.blue800,
                      20,
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'CHI TIẾT CÁC ĐỊA ĐIỂM',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 18,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // Danh sách địa điểm chi tiết
              ...widget.itinerary.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Header với số thứ tự và tên
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 35,
                            height: 35,
                            decoration: pw.BoxDecoration(
                              color: PdfColors.blue600,
                              borderRadius: pw.BorderRadius.circular(17.5),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                '${index + 1}',
                                style: pw.TextStyle(
                                  font: fontBold,
                                  color: PdfColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 12),
                          pw.Expanded(
                            child: pw.Text(
                              item.attraction.name,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 16,
                                color: PdfColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 12),

                      // Địa chỉ với icon
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildMDIIcon(
                            iconFont,
                            MdiIcons.mapMarker,
                            PdfColors.grey600,
                            14,
                          ),
                          pw.SizedBox(width: 6),
                          pw.Expanded(
                            child: pw.Text(
                              item.attraction.address,
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 12,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 8),

                      // Thời gian với icon
                      pw.Row(
                        children: [
                          _buildMDIIcon(
                            iconFont,
                            MdiIcons.clockOutline,
                            PdfColors.blue700,
                            14,
                          ),
                          pw.SizedBox(width: 6),
                          pw.Text(
                            '${item.visitTime.hour.toString().padLeft(2, '0')}:${item.visitTime.minute.toString().padLeft(2, '0')}',
                            style: pw.TextStyle(
                              font: fontRegular,
                              fontSize: 12,
                              color: PdfColors.blue700,
                            ),
                          ),
                          pw.SizedBox(width: 20),
                          _buildMDIIcon(
                            iconFont,
                            MdiIcons.timerOutline,
                            PdfColors.green700,
                            14,
                          ),
                          pw.SizedBox(width: 6),
                          pw.Text(
                            '${item.estimatedDuration.inHours}h ${item.estimatedDuration.inMinutes % 60}m',
                            style: pw.TextStyle(
                              font: fontRegular,
                              fontSize: 12,
                              color: PdfColors.green700,
                            ),
                          ),
                        ],
                      ),

                      // Ghi chú với icon
                      if (item.notes.isNotEmpty) ...[
                        pw.SizedBox(height: 8),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildMDIIcon(
                              iconFont,
                              MdiIcons.noteTextOutline,
                              PdfColors.orange700,
                              14,
                            ),
                            pw.SizedBox(width: 6),
                            pw.Expanded(
                              child: pw.Text(
                                item.notes,
                                style: pw.TextStyle(
                                  font: fontItalic,
                                  fontSize: 11,
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      pw.SizedBox(height: 8),

                      // Rating và giá với icon
                      pw.Row(
                        children: [
                          _buildMDIIcon(
                            iconFont,
                            MdiIcons.star,
                            PdfColors.orange600,
                            14,
                          ),
                          pw.SizedBox(width: 4),
                          pw.Text(
                            '${item.attraction.rating}/5',
                            style: pw.TextStyle(
                              font: fontRegular,
                              fontSize: 12,
                              color: PdfColors.orange700,
                            ),
                          ),
                          if (item.attraction.price != null) ...[
                            pw.SizedBox(width: 20),
                            _buildMDIIcon(
                              iconFont,
                              MdiIcons.currencyUsd,
                              PdfColors.green600,
                              14,
                            ),
                            pw.SizedBox(width: 4),
                            pw.Text(
                              '${_formatPrice(item.attraction.price!)} VND',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                                color: PdfColors.green600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.blue100),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Tạo bởi ứng dụng Lịch trình Du lịch',
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'Ngày tạo: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      // Tải PDF về
      final fileName =
          'Lich_trinh_${widget.selectedDate.day}_${widget.selectedDate.month}_${widget.selectedDate.year}.pdf';

      await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
    } catch (e) {
      print('Error generating PDF with MDI icons: $e');
      rethrow;
    }
  }

  // Helper function để tạo MDI icon
  pw.Widget _buildMDIIcon(
    pw.Font? iconFont,
    IconData iconData,
    PdfColor color,
    double size,
  ) {
    if (iconFont != null) {
      return pw.Text(
        String.fromCharCode(iconData.codePoint),
        style: pw.TextStyle(font: iconFont, fontSize: size, color: color),
      );
    } else {
      // Fallback: vẽ hình tròn đơn giản
      return pw.Container(
        width: size,
        height: size,
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: pw.BorderRadius.circular(size / 2),
        ),
      );
    }
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _getStartTime() {
    if (widget.itinerary.isEmpty) return '--:--';
    final startTime = widget.itinerary.first.visitTime;
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  String _getEndTime() {
    if (widget.itinerary.isEmpty) return '--:--';
    final lastItem = widget.itinerary.last;
    final endTime = lastItem.visitTime.add(lastItem.estimatedDuration);
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  String _getTotalDuration() {
    if (widget.itinerary.isEmpty) return '0h 0m';

    final totalMinutes = widget.itinerary.fold<int>(
      0,
      (sum, item) => sum + item.estimatedDuration.inMinutes,
    );

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return '${hours}h ${minutes}m';
  }

  double _getTotalPrice() {
    return widget.itinerary.fold<double>(
      0.0,
      (sum, item) => sum + (item.attraction.price ?? 0.0),
    );
  }

  // Tạo hình ảnh bản đồ Hồ Chí Minh
  Future<pw.MemoryImage?> _generateMapImage() async {
    try {
      // Lấy Mapbox access token từ biến môi trường
      final mapboxAccessToken = dotenv.env["MAPBOX_ACCESS_TOKEN"];

      // Tạo danh sách các điểm trên bản đồ từ lịch trình
      final List<LatLng> points = widget.itinerary.map((item) => item.attraction.location).toList();

      // Tạo danh sách tên các địa điểm
      final List<String> locationNames = widget.itinerary.map((item) => item.attraction.name).toList();

      if (mapboxAccessToken == null || mapboxAccessToken.isEmpty) {
        print('Mapbox access token is missing, falling back to OpenStreetMap');
        // Sử dụng OpenStreetMap với các điểm trong lịch trình
        return await HCMCMapHelper.generateHCMCOpenStreetMapImage(
          itineraryPoints: points,
          locationNames: locationNames,
        );
      }

      // Sử dụng helper để tạo bản đồ Hồ Chí Minh với Mapbox và các điểm trong lịch trình
      final mapboxMapImage = await HCMCMapHelper.generateHCMCMapImage(
        mapboxAccessToken: mapboxAccessToken,
        itineraryPoints: points,
        locationNames: locationNames,
        mapStyle: 'streets-v11',
        width: 600,
        height: 400,
        zoom: 12.0,
      );

      if (mapboxMapImage != null) {
        return mapboxMapImage;
      }

      // Fallback to OpenStreetMap if Mapbox fails
      final osmMapImage = await HCMCMapHelper.generateHCMCOpenStreetMapImage(
        itineraryPoints: points,
        locationNames: locationNames,
      );

      if (osmMapImage != null) {
        return osmMapImage;
      }

      // Nếu cả hai đều thất bại, sử dụng phương pháp dự phòng
      return await HCMCMapHelper.generateFallbackMapImage(
        itineraryPoints: points,
        locationNames: locationNames,
      );
    } catch (e) {
      print('❌ Error generating map image: $e');
      // Fallback to generated image with itinerary points
      final points = widget.itinerary.map((item) => item.attraction.location).toList();
      final locationNames = widget.itinerary.map((item) => item.attraction.name).toList();

      return await HCMCMapHelper.generateFallbackMapImage(
        itineraryPoints: points,
        locationNames: locationNames,
      );
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '$hours giờ ${minutes > 0 ? '$minutes phút' : ''}';
    } else {
      return '$minutes phút';
    }
  }

  void _printItineraryInfo() {
    print('=' * 50);
    print('📋 THÔNG TIN LỊCH TRÌNH DU LỊCH');
    print('=' * 50);
    print('📅 Ngày: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}');
    print('📍 Số địa điểm: ${widget.itinerary.length}');
    print('⏰ Thời gian bắt đầu: ${_getStartTime()}');
    print('⏰ Thời gian kết thúc: ${_getEndTime()}');
    print('⏱️ Tổng thời gian: ${_getTotalDuration()}');
    print('💰 Tổng chi phí: ${_formatPrice(_getTotalPrice())} VND');
    print('');
    
    if (widget.itinerary.isNotEmpty) {
      print('🗺️ DANH SÁCH ĐỊA ĐIỂM:');
      print('-' * 50);
      
      for (int i = 0; i < widget.itinerary.length; i++) {
        final item = widget.itinerary[i];
        print('${i + 1}. ${item.attraction.name}');
        if (item.id != null) {
          print('   🆔 ID: ${item.id}');
        }
        print('   📍 Địa chỉ: ${item.attraction.address}');
        print('   ⏰ Thời gian: ${item.visitTime.hour.toString().padLeft(2, '0')}:${item.visitTime.minute.toString().padLeft(2, '0')}');
        print('   ⏱️ Thời lượng: ${_formatDuration(item.estimatedDuration)}');
        print('   ⭐ Rating: ${item.attraction.rating}/5');
        if (item.attraction.price != null) {
          print('   💰 Giá: ${_formatPrice(item.attraction.price!)} VND');
        }
        if (item.notes.isNotEmpty) {
          print('   📝 Ghi chú: ${item.notes}');
        }
        print('   🏷️ Danh mục: ${item.attraction.category}');
        print('   🏷️ Tags: ${item.attraction.tags.join(', ')}');
        if (item.createdAt != null) {
          print('   📅 Tạo lúc: ${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year} ${item.createdAt!.hour}:${item.createdAt!.minute}');
        }
        print('');
      }
      
      print('📊 THỐNG KÊ:');
      print('-' * 30);
      print('• Địa điểm có giá: ${widget.itinerary.where((item) => item.attraction.price != null).length}/${widget.itinerary.length}');
      print('• Địa điểm có ghi chú: ${widget.itinerary.where((item) => item.notes.isNotEmpty).length}/${widget.itinerary.length}');
      print('• Rating trung bình: ${_getAverageRating().toStringAsFixed(1)}/5');
      print('• Địa điểm miễn phí: ${widget.itinerary.where((item) => item.attraction.price == null || item.attraction.price == 0).length}');
      print('• Địa điểm có phí: ${widget.itinerary.where((item) => item.attraction.price != null && item.attraction.price! > 0).length}');
    } else {
      print('❌ Không có địa điểm nào trong lịch trình!');
    }
    
    print('=' * 50);
  }
  
  double _getAverageRating() {
    if (widget.itinerary.isEmpty) return 0.0;
    final totalRating = widget.itinerary.fold<double>(
      0.0,
      (sum, item) => sum + item.attraction.rating,
    );
    return totalRating / widget.itinerary.length;
  }
}
