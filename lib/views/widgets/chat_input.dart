import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilev2/viewmodels/home/main_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isEnabled;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.isEnabled = true,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  double _currentAmplitude = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);

    // Animation cho hiệu ứng pulse khi ghi âm
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _onTextChanged() {
    final canSend = _controller.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() {
        _canSend = canSend;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_canSend && widget.isEnabled) {
      final message = _controller.text.trim();
      _controller.clear();
      widget.onSendMessage(message);
    }
  }

  void _startVoiceRecording() async {
    final viewModel = context.read<MainViewModel>();
    await viewModel.startVoiceRecording();

    if (viewModel.isRecording) {
      _startRecordingTimer();
      _pulseController.repeat(reverse: true);
      _startAmplitudeListener(viewModel);
    }
  }

  void _stopVoiceRecording() async {
    final viewModel = context.read<MainViewModel>();
    await viewModel.stopVoiceRecording();
    _stopRecordingTimer();
    _pulseController.stop();
    _amplitudeSubscription?.cancel();
  }

  void _cancelVoiceRecording() async {
    final viewModel = context.read<MainViewModel>();
    await viewModel.cancelVoiceRecording();
    _stopRecordingTimer();
    _pulseController.stop();
    _amplitudeSubscription?.cancel();
  }

  void _startRecordingTimer() {
    _recordingDuration = 0;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingDuration = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 8,
                color: const Color.fromARGB(25,0,0,0),
              ),
            ],
          ),
          child: SafeArea(
            child:
                viewModel.isRecording
                    ? _buildRecordingUI(viewModel)
                    : _buildNormalUI(viewModel),
          ),
        );
      },
    );
  }

  _buildRecordingUI(MainViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Thanh thời gian ghi âm
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                'Đang ghi âm: ${_formatDuration(_recordingDuration)}',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Các nút điều khiển khi ghi âm
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nút hủy
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _cancelVoiceRecording,
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                tooltip: 'Hủy ghi âm',
              ),
            ),

            // Hiển thị waveform dựa trên amplitude thực tế
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    // Tạo hiệu ứng waveform dựa trên amplitude
                    final baseHeight = 8.0;
                    final amplitudeHeight = (_currentAmplitude * 20).clamp(
                      0.0,
                      20.0,
                    );
                    final height =
                        baseHeight +
                        amplitudeHeight * (1 - (index - 3).abs() / 3);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 3,
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Nút dừng và gửi
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: viewModel.isSending ? null : _stopVoiceRecording,
                icon:
                    viewModel.isSending
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                tooltip: 'Gửi tin nhắn giọng nói',
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Hướng dẫn
        Text(
          'Nhấn nút xanh để gửi, nút xám để hủy',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  _buildNormalUI(MainViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _controller,
              enabled: widget.isEnabled && !viewModel.isRecording,
              decoration: const InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Nút microphone
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed:
                widget.isEnabled && !viewModel.isSending
                    ? _startVoiceRecording
                    : null,
            icon: const Icon(Icons.mic, color: Colors.white, size: 20),
            tooltip: 'Ghi âm tin nhắn',
          ),
        ),

        const SizedBox(width: 8),

        // Nút gửi tin nhắn
        Container(
          decoration: BoxDecoration(
            color:
                _canSend && widget.isEnabled && !viewModel.isRecording
                    ? Colors.blue.shade600
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed:
                _canSend && widget.isEnabled && !viewModel.isRecording
                    ? _sendMessage
                    : null,
            icon:
                viewModel.isSending
                    ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                    : const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int recordingDuration) {
    final minutes = recordingDuration ~/ 60;
    final remainingSeconds = recordingDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startAmplitudeListener(MainViewModel viewModel) {
    // Lắng nghe amplitude để tạo hiệu ứng waveform thực tế
    _amplitudeSubscription = viewModel.getAmplitudeStream()?.listen((
      amplitude,
    ) {
      setState(() {
        _currentAmplitude = amplitude.current;
      });
    });
  }
}
