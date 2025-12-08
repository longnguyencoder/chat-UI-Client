import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceService{
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Kiểm tra và yêu cầu quyền microphone
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  // Bắt đầu ghi âm
  Future<bool> startRecording() async {
    try {
      final hasPermission = await requestMicrophonePermission();
      if (!hasPermission) {
        throw Exception('❌ Không có quyền truy cập microphone');
      }

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      return true;
    } catch (e) {
      throw Exception('❌ Lỗi bắt đầu ghi âm: $e');
    }
  }

  // Dừng ghi âm và trả về đường dẫn file
  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      return path;
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

  // Lấy amplitude (độ lớn âm thanh) để tạo hiệu ứng waveform
  Stream<Amplitude> getAmplitudeStream() {
    return _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 200));
  }

  // Xóa file tạm
  Future<void> deleteTemporaryFile(String filePath) async {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      // Log error nhưng không throw exception
      print('❌ Lỗi xóa file tạm: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _audioRecorder.dispose();
  }
}