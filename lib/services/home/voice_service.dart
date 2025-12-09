import 'dart:io' show File; // Chỉ import File, tránh import cả thư viện io nếu ko cần
import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceService {
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Kiểm tra và yêu cầu quyền microphone
  Future<bool> requestMicrophonePermission() async {
    // Trên Web, trình duyệt sẽ tự hỏi quyền khi gọi start()
    if (kIsWeb) return true; 
    
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  // Bắt đầu ghi âm
  Future<bool> startRecording() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
          // Thử xin quyền lại lần nữa
          final hasPermission = await requestMicrophonePermission();
          if (!hasPermission) throw Exception('❌ Không có quyền truy cập microphone');
      }

      String? filePath;
      
      // CHỈ cấu hình đường dẫn file khi KHÔNG phải là Web
      if (!kIsWeb) {
        final directory = await getTemporaryDirectory();
        filePath = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.wav';
      }
      
      // Trên Web: path = null -> Ghi vào Blob (Memory)
      
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav, // Web thường hỗ trợ tốt file wav/pcm
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath ?? '', 
      );

      return true;
    } catch (e) {
      print('DEBUG ERROR: $e'); // In lỗi ra console để dễ debug
      throw Exception('❌ Lỗi bắt đầu ghi âm: $e');
    }
  }

  // Dừng ghi âm và trả về đường dẫn file
  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      print("End recording path: $path");
      return path; // Trên Web, path sẽ là URL blob (blob:http://...)
    } catch (e) {
      throw Exception('❌ Lỗi dừng ghi âm: $e');
    }
  }

  // Hủy ghi âm
  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.cancel();
    } catch (e) {
      throw Exception('❌ Lỗi hủy ghi âm: $e');
    }
  }

  // Kiểm tra trạng thái ghi âm
  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  // Lấy amplitude
  Stream<Amplitude> getAmplitudeStream() {
    return _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 200));
  }

  // Xóa file tạm (Chỉ chạy trên Mobile/Desktop)
  Future<void> deleteTemporaryFile(String filePath) async {
    if (kIsWeb) return; // Web ko cần xóa file
    
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      print('❌ Lỗi xóa file tạm: $e');
    }
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}