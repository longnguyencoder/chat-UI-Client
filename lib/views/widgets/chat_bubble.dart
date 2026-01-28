import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobilev2/models/message_model.dart';
import 'package:mobilev2/views/widgets/hospital_map_card.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isUser;
  final bool showActions;
  final Widget? extraAction;
  final String? voiceUrl;
  final String? imageBase64; // ✅ Thêm
  final String messageType;
  final Function(String, BuildContext)? onCopyPressed;
  final Message? messageObject; // ✅ Thêm để truy cập map_data

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.showActions = false,
    this.extraAction,
    this.voiceUrl,
    this.imageBase64, // ✅ Thêm
    this.messageType = 'text',
    this.onCopyPressed,
    this.messageObject, // ✅ Thêm
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
        if (widget.voiceUrl != null) {
          if (_position >= _duration && _duration.inMilliseconds > 0) {
            await _audioPlayer.seek(Duration.zero);
          }
           print('Playing audio from: ${widget.voiceUrl}');
           await _audioPlayer.play(UrlSource(widget.voiceUrl!));
        }
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
    // Tiền xử lý tin nhắn để tránh lỗi hiển thị đè chữ khi dùng custom builder
    final processedMessage = _processMessage(widget.message);
    
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
              gradient: widget.isUser
                  ? const LinearGradient(
                      colors: [Color(0xFFE8EAF6), Color(0xFFD1D5E8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
              boxShadow: [
                BoxShadow(
                  color: widget.isUser
                      ? Colors.black.withOpacity(0.05)
                      : const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: widget.isUser ? 4 : 8,
                  offset: Offset(0, widget.isUser ? 2 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Hiển thị ảnh nếu có
                if (widget.imageBase64 != null && widget.imageBase64!.isNotEmpty)
                  _buildImageMessage(),
                  
                // Hiển thị voice message nếu có
                if (widget.messageType == 'voice' && widget.voiceUrl != null && widget.voiceUrl!.isNotEmpty)
                  _buildVoiceMessage(),

                // ✅ Hiển thị PDF nếu có
                if (widget.messageObject?.pdfName != null)
                  _buildPdfMessage(),

                // Hiển thị text message với định dạng
                if (widget.message.isNotEmpty)
                    MarkdownBody(
                      data: processedMessage, // ✅ Dùng tin nhắn đã xử lý
                      selectable: false, // ❌ Tắt cái này đi để tránh crash trên Web
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          final uri = Uri.parse(href);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 16,
                          color: widget.isUser ? const Color(0xFF2C3E50) : Colors.white,
                          height: 1.4,
                        ),
                        a: TextStyle(
                          color: widget.isUser ? Colors.blue.shade700 : Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                        listBullet: TextStyle(
                          color: widget.isUser ? const Color(0xFF2C3E50) : Colors.white,
                        ),
                      ),
                      builders: {
                        'a': _GoogleMapLinkBuilder(
                          isUser: widget.isUser,
                          onTap: (href) async {
                            if (href != null) {
                              final uri = Uri.parse(href);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            }
                          },
                        ),
                      },
                    ),
              ],
            ),
          ),

          // ✅ Hiển thị Hospital Map Card nếu có map_data
          if (!widget.isUser && 
              widget.messageObject?.mapData != null && 
              widget.messageObject!.mapData!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: HospitalMapCard(
                hospitals: widget.messageObject!.mapData!,
              ),
            ),

          // Actions cho tin nhắn bot
          if (widget.showActions && !widget.isUser)
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ... (keep actions)
                  // Nút copy
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                    onPressed: () {
                      if (widget.onCopyPressed != null) {
                        widget.onCopyPressed!(widget.message, context);
                      }
                    },
                    tooltip: 'Sao chép',
                  ),
                  // ... (other buttons)
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_up_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                    tooltip: 'Thích',
                  ),
                  if (widget.extraAction != null) widget.extraAction!,
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Widget hiển thị ảnh
  Widget _buildImageMessage() {
    try {
      Uint8List bytes;
      String base64String = widget.imageBase64!;
      
      // Remove data URI prefix if present
      if (base64String.startsWith('data:image')) {
        final commaIndex = base64String.indexOf(',');
        if (commaIndex != -1) {
          base64String = base64String.substring(commaIndex + 1);
        }
      }
      
      bytes = base64Decode(base64String);
      
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: 200,
            // height: 200, // Để height tự động theo tỉ lệ
            errorBuilder: (context, error, stackTrace) {
              return const Text('❌ Lỗi hiển thị ảnh', style: TextStyle(fontSize: 12));
            },
          ),
        ),
      );
    } catch (e) {
      print("Error decoding image: $e");
      return const SizedBox.shrink();
    }
  }

  // ✅ Widget hiển thị PDF
  Widget _buildPdfMessage() {
    final pdfName = widget.messageObject!.pdfName!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isUser ? Colors.white.withOpacity(0.9) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.isUser ? Colors.blue.shade100 : Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              pdfName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: widget.isUser ? Colors.blue.shade800 : Colors.blue.shade900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  String _processMessage(String message) {
    // Tìm TẤT CẢ các link và thay thế text bằng Zero-Width Space (\u200b) để tránh đè chữ
    return message.replaceAllMapped(
      RegExp(r'\[(.*?)\]\((https?:\/\/[^\)]+)\)'),
      (match) {
        final text = match.group(1);
        final url = match.group(2);
        
        // Thêm thông tin text gốc vào query param để builder đọc lại
        final separator = url!.contains('?') ? '&' : '?';
        return '[\u200b]($url${separator}original_text=${Uri.encodeComponent(text ?? "Liên kết")})';
      },
    );
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

class _GoogleMapLinkBuilder extends MarkdownElementBuilder {
  final bool isUser;
  final Function(String?) onTap;

  _GoogleMapLinkBuilder({required this.isUser, required this.onTap});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String text = element.textContent;
    final String? href = element.attributes['destination'] ?? element.attributes['href'];
    
    // Nếu là link đã được chúng ta xử lý (chứa Zero-Width Space)
    if (text == '\u200b' && href != null) {
      try {
        final uri = Uri.parse(href);
        final label = uri.queryParameters['original_text'] ?? "Xem chi tiết";
        
        bool isMap = href.contains('google.com/maps') || href.contains('maps.app.goo.gl');
        bool isBooking = href.toLowerCase().contains('booking') || href.toLowerCase().contains('dat-lich');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ActionChip(
            onPressed: () => onTap(href),
            avatar: Icon(
              isMap ? Icons.location_on : (isBooking ? Icons.calendar_today : Icons.link),
              size: 14,
              color: isUser ? Colors.white : (isMap ? Colors.blue.shade700 : Colors.teal.shade700),
            ),
            label: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUser ? Colors.white : (isMap ? Colors.blue.shade700 : Colors.teal.shade700),
              ),
            ),
            backgroundColor: isUser 
                ? Colors.blue.shade400 
                : (isMap ? Colors.blue.shade50 : Colors.teal.shade50),
            side: BorderSide(
              color: isUser 
                  ? Colors.transparent 
                  : (isMap ? Colors.blue.shade200 : Colors.teal.shade200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
        );
      } catch (e) {
        // Fallback below
      }
    }

    // Nếu không khớp với link đã xử lý, hoặc có lỗi, render ra text bình thường nhưng ĐẢM BẢO không đè lên cái khác
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () => onTap(href),
        child: Text(
          text,
          style: preferredStyle?.copyWith(
            color: isUser ? Colors.blue.shade700 : Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
