import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isUser;
  final bool showActions;
  final Widget? extraAction;
  final String? voiceUrl;
  final String messageType;
  final Function(String, BuildContext)? onCopyPressed;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.showActions = false,
    this.extraAction,
    this.voiceUrl,
    this.messageType = 'text',
    this.onCopyPressed,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _audioInitialized = false;

  // Stream subscriptions for proper cleanup
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAudioIfNeeded();
  }

  @override
  void didUpdateWidget(ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the voice URL changed or message type changed
    if (widget.voiceUrl != oldWidget.voiceUrl ||
        widget.messageType != oldWidget.messageType) {
      _initializeAudioIfNeeded();
    }
  }

  void _setupAudioPlayer() {
    // Cancel any existing subscriptions first
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Pre-load the audio file
    if (widget.voiceUrl != null && widget.voiceUrl!.isNotEmpty) {
      _audioPlayer.setSourceUrl(widget.voiceUrl!).catchError((error) {
        print('Error pre-loading audio: $error');
      });
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();

    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (widget.voiceUrl == null || widget.voiceUrl!.isEmpty) {
      print('Voice URL is null or empty');
      return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        print('Audio paused');
      } else {
        // Check if the position is at the end, if so reset to beginning
        if (_position >= _duration && _duration.inMilliseconds > 0) {
          await _audioPlayer.seek(Duration.zero);
        }

        print('Playing audio from: ${widget.voiceUrl}');
        await _audioPlayer.play(UrlSource(widget.voiceUrl!));
      }
    } catch (e) {
      print('Error playing/pausing audio: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi phát âm thanh: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to check message type and voice URL
    print('Building chat bubble: isUser=${widget.isUser}, messageType=${widget.messageType}, voiceUrl=${widget.voiceUrl}');
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        left: widget.isUser ? 50 : 0,
        right: widget.isUser ? 0 : 50,
      ),
      child: Column(
        crossAxisAlignment:
            widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  widget.isUser ? Colors.blue.shade600 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight:
                    widget.isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(20),
                bottomLeft:
                    widget.isUser
                        ? const Radius.circular(20)
                        : const Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị voice message nếu có
                if (widget.messageType == 'voice' && widget.voiceUrl != null && widget.voiceUrl!.isNotEmpty)
                  _buildVoiceMessage(),

                // Hiển thị text message với định dạng
                if (widget.message.isNotEmpty)
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.isUser ? Colors.white : Colors.black87,
                    ),
                  ),
              ],
            ),
          ),

          // Actions cho tin nhắn bot
          if (widget.showActions && !widget.isUser)
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nút copy
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                    onPressed: () {
                      // Implement copy functionality
                      if (widget.onCopyPressed != null) {
                        widget.onCopyPressed!(widget.message, context);
                      }
                    },
                    tooltip: 'Sao chép',
                  ),

                  // Nút like/dislike
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Implement like functionality
                    },
                    tooltip: 'Thích',
                  ),

                  // Extra action nếu có
                  if (widget.extraAction != null) widget.extraAction!,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút play/pause
          GestureDetector(
            onTap: _playPauseAudio,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    widget.isUser
                        ? const Color.fromARGB(51, 0, 0, 0)
                        : Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.isUser ? Colors.white : Colors.blue.shade700,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Waveform hoặc progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value:
                      _duration.inMilliseconds > 0
                          ? _position.inMilliseconds / _duration.inMilliseconds
                          : 0.0,
                  backgroundColor:
                      widget.isUser
                          ? const Color.fromARGB(77, 0, 0, 0)
                          : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isUser ? Colors.white : Colors.blue.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                // Thời gian
                Text(
                  '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        widget.isUser
                            ? const Color.fromARGB(204,0,0,0)
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _initializeAudioIfNeeded() {
    // Only initialize if it's a voice message and has a URL
    if (widget.messageType == 'voice' && widget.voiceUrl != null && !_audioInitialized) {
      print('Initializing audio player for: ${widget.voiceUrl}');
      _setupAudioPlayer();
      _audioInitialized = true;
    }
  }
}
