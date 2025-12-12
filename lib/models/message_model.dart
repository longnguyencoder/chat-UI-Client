import 'dart:convert';

class Message {
  final int messageId;
  final int conversationId;
  final String sender;
  final String messageText;
  final String? translatedText;
  final String? messageType;
  final String? voiceUrl;
  final String? imageBase64; // ✅ Thêm trường lưu ảnh base64/url
  final DateTime sentAt;
  final List<String>? places;
  final List<String>? suggestions;

  Message({
    required this.messageId,
    required this.conversationId,
    required this.sender,
    required this.messageText,
    required this.translatedText,
    required this.messageType,
    required this.voiceUrl,
    this.imageBase64, // Optional
    required this.sentAt,
    this.places,
    this.suggestions,
  });

  // Helper method để decode Unicode escape sequences và fix UTF-8 encoding issues
  static String _decodeUnicode(String text) {
    try {
      // print("🔍 Original text: $text");
      
      // Bước 1: Decode Unicode escape sequences như \u00ed, \u00e0, etc.
      String decoded = text.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
      // print("🔍 After Unicode decode: $decoded");
      
      // Bước 2: Fix UTF-8 encoding issues với nhiều trường hợp
      try {
        // Kiểm tra các ký tự UTF-8 bị encode sai
        if (decoded.contains('Ã') || decoded.contains('Â') || 
            decoded.contains('Æ') || decoded.contains('áº') || 
            decoded.contains('áº»') || decoded.contains('áº­')) {
          // print("🔍 Detected UTF-8 encoding issues, attempting multiple fixes...");
          
          // Thử nhiều cách decode khác nhau
          String result = decoded;
          
          // Cách 1: Latin-1 -> UTF-8
          try {
            final bytes1 = latin1.encode(decoded);
            result = utf8.decode(bytes1, allowMalformed: true);
            // print("🔍 After Latin-1 -> UTF-8: $result");
          } catch (e) {
            print('Lỗi Latin-1 -> UTF-8: $e');
          }
          
          // Cách 2: Nếu vẫn còn vấn đề, thử decode lại
          if (result.contains('Ã') || result.contains('Â') || 
              result.contains('Æ') || result.contains('áº')) {
            try {
              final bytes2 = latin1.encode(result);
              result = utf8.decode(bytes2, allowMalformed: true);
              // print("🔍 After second Latin-1 -> UTF-8: $result");
            } catch (e) {
              print('Lỗi second Latin-1 -> UTF-8: $e');
            }
          }
          
          // Cách 3: Thử với ISO-8859-1
          if (result.contains('Ã') || result.contains('Â') || 
              result.contains('Æ') || result.contains('áº')) {
            try {
              final bytes3 = latin1.encode(result);
              result = utf8.decode(bytes3, allowMalformed: true);
              // print("🔍 After ISO-8859-1 -> UTF-8: $result");
            } catch (e) {
              print('Lỗi ISO-8859-1 -> UTF-8: $e');
            }
          }
          
          decoded = result;
        }
      } catch (e) {
        print('Lỗi khi fix UTF-8 encoding: $e');
      }
      
      // print("🔍 Final decoded text: $decoded");
      return decoded;
    } catch (e) {
      print('Lỗi khi decode Unicode: $e');
      return text;
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    // Xử lý places - chỉ bot messages mới có places
    List<String>? places;
    List<String>? suggestions;
    
    // Kiểm tra sender - chỉ bot mới có places
    final sender = json['sender'] as String?;
    final isBotMessage = sender == 'bot';
    
    if (isBotMessage) {
      try {
        // Ưu tiên lấy places đã được xử lý từ ChatService
        if (json['places'] != null) {
          if (json['places'] is List) {
            places = (json['places'] as List).map<String>((place) { // ✅ Fixed map<String>
              final placeStr = place as String;
              // Decode Unicode escape sequences khi đọc từ database
              return _decodeUnicode(placeStr);
            }).toList();
          }
        }
        
        // Nếu không có places, thử xử lý travel_data
        if (places == null && json['travel_data'] != null) {
          final travelData = json['travel_data'] as Map<String, dynamic>;
          if (travelData['success'] == true && travelData['search_results'] != null) {
            final searchResults = travelData['search_results'] as List;
            places = searchResults
                .map<String>((result) { // ✅ Fixed map<String>
                  final placeName = result['ten_dia_diem'] as String;
                  // Decode Unicode escape sequences
                  return _decodeUnicode(placeName);
                })
                .toList();
          }
        }

        // Xử lý suggestions
        if (json['suggestions'] != null) {
          if (json['suggestions'] is List) {
             suggestions = (json['suggestions'] as List).map((e) => e.toString()).toList();
          }
        }

      } catch (e) {
        print('Lỗi khi xử lý places/suggestions trong Message.fromJson: $e');
        places = null;
        suggestions = null;
      }
    } else {
      // User messages luôn có places = null
      places = null;
      suggestions = null;
    }

    return Message(
      messageId: json['message_id'] ?? 0,
      conversationId: json['conversation_id'] ?? 0,
      sender: json['sender'],
      messageText: json['message_text'],
      translatedText: json['translated_text'],
      messageType: json['message_type'],
      voiceUrl: json['voice_url'],
      imageBase64: json['image_base64'], 
      sentAt: DateTime.parse(json['sent_at']),
      places: places,
      suggestions: suggestions,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'message_id': messageId,
      'conversation_id': conversationId,
      'sender': sender,
      'message_text': messageText,
      'translated_text': translatedText,
      'message_type': messageType,
      'voice_url': voiceUrl,
      'image_base64': imageBase64,
      'sent_at': sentAt.toIso8601String(),
      'places': places,
      'suggestions': suggestions,
    };
  }

  Message copyWith({
    int? messageId,
    int? conversationId,
    String? sender,
    String? messageText,
    String? translatedText,
    String? messageType,
    String? voiceUrl,
    String? imageBase64,
    DateTime? sentAt,
    List<String>? places,
    List<String>? suggestions,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      messageText: messageText ?? this.messageText,
      translatedText: translatedText ?? this.translatedText,
      messageType: messageType ?? this.messageType,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      imageBase64: imageBase64 ?? this.imageBase64,
      sentAt: sentAt ?? this.sentAt,
      places: places ?? this.places,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
