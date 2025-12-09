import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mobilev2/models/conversation_model.dart';
import 'package:mobilev2/models/message_model.dart';
import 'package:mobilev2/services/api_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  // Tạo cuộc trò chuyện mới
  Future<Conversation> createNewConversation(int userId, String sourceLanguage,) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.createNewConversationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'source_language': sourceLanguage,
          'started_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        print("📥 RAW RESPONSE: ${response.body}");
        final responseData = jsonDecode(response.body);
        
        // Flexible parsing: Try 'data', then 'conversation', then root
        dynamic conversationJson = responseData['data'];
        if (conversationJson == null && responseData is Map) {
          conversationJson = responseData['conversation'];
        }
        if (conversationJson == null && responseData is Map && responseData['conversation_id'] != null) {
          conversationJson = responseData;
        }

        if (conversationJson == null) {
          throw Exception('Invalid response structure: ${response.body}');
        }

        // ✅ INJECT user_id if missing (do backend ko trả về verify chính chủ)
        // Chúng ta tạo bản copy để an toàn (tránh lỗi mutate immutable map)
        final Map<String, dynamic> mutableJson = Map<String, dynamic>.from(conversationJson);
        if (mutableJson['user_id'] == null) {
           print("⚠️ Injecting missing user_id $userId into conversation JSON");
           mutableJson['user_id'] = userId;
        }

        return Conversation.fromJson(mutableJson);
      } else {
        throw Exception('Không thể tạo cuộc trò chuyện mới');
      }
    } catch (e) {
      throw Exception('Lỗi tạo cuộc trò chuyện: $e');
    }
  }

  // Lấy danh sách cuộc trò chuyện của user
  Future<List<Conversation>> getUserConversations(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiService.getUserConversationsUrl(userId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("📥 getUserConversations RAW: ${response.body}"); // Debug log
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        // Flexible parsing: Try 'data', then 'conversations', then root list if applicable
        dynamic data = jsonData['data'];
        if (data == null) {
           data = jsonData['conversations'];
        }
        
        if (data == null) {
           print("⚠️ No conversations list found in response");
           return [];
        }

        if (data is! List) {
           print("❌ Expected List but got ${data.runtimeType}");
           return [];
        }

        return (data as List).map((json) {
           // Inject user_id vào từng item nếu thiếu
           if (json is Map<String, dynamic> && json['user_id'] == null) {
               json['user_id'] = userId;
           }
           return Conversation.fromJson(json);
        }).toList();
      } else {
        throw Exception('Không thể tải danh sách cuộc trò chuyện');
      }
    } catch (e) {
      throw Exception('Lỗi tải cuộc trò chuyện: $e');
    }
  }

  // Lấy tin nhắn của một cuộc trò chuyện
  Future<List<Message>> getConversationMessages(int conversationId, int userId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiService.messagesByConversationUrl(conversationId, userId)),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print("📥 getConversationMessages RAW: ${response.body}");
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        
        dynamic jsonData = jsonMap['data'];
        if (jsonData == null) {
           jsonData = jsonMap['messages'];
        }

        if (jsonData == null) {
           print("⚠️ No messages found in response");
           return [];
        }

        if (jsonData is! List) {
           print("❌ Expected List for messages but got ${jsonData.runtimeType}");
           return [];
        }
        
        print("📥 Loading ${jsonData.length} messages for conversation $conversationId");
        
        return jsonData.map((json) {
          // Đảm bảo tin nhắn cũ có places = null
          if (json['places'] == null) {
            json['places'] = null;
          }
          
          final messageId = json['message_id'] ?? 'N/A';
          final sender = json['sender'] ?? 'N/A';
          
          print("📨 Message ID: $messageId | Sender: $sender");
          
          return Message.fromJson(json);
        }).toList();
      } else {
        throw Exception('Không thể tải tin nhắn');
      }
    } catch (e) {
      print('Lỗi tải tin nhắn: $e');
      throw Exception('Lỗi tải tin nhắn: $e');
    }
  }

  // Lưu tin nhắn vào database (Đã update ở step trước, giữ nguyên)
    // Gửi tin nhắn text (Đã sửa để gửi kèm Token)
  Future<Map<String, dynamic>> sendMessageAndGetResponse({
    required int conversationId,
    required String messageText,
    required String token, // ✅ Thêm Token vào tham số
    String translatedText = '',
    String messageType = 'text',
    String? voiceUrl,
  }) async {
    try {
      print("🔐 Token used: $token");
      print("📤 Sending secure message to: ${ApiService.sendMessageUrl}");
      
      final response = await http.post(
        Uri.parse(ApiService.sendMessageUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ Gửi Token xác thực
        },
        body: jsonEncode({
          'conversation_id': conversationId,
          'question': messageText,       // ✅ Backend chat-secure dùng 'question'
          // Các trường phụ có thể gửi thêm nếu backend cần log
          'message_text': messageText,   
          'message_type': messageType,
        }),
      );

      print("📥 Send Message Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Backend trả về trực tiếp object kết quả:{ 'answer': '...', ... }
        // Cần chuẩn hóa lại để UI dễ xử lý (giả lập cấu trúc cũ nếu cần)
        
        return {
          'status': 'success',
          'data': {
            'bot_message': {
              'message_text': responseData['answer'],
              'sender': 'bot',
              'sent_at': DateTime.now().toIso8601String(),
              // Mapping sources nếu có
              'sources': responseData['sources']
            },
            // Backend chat-secure không trả lại user_message, ta tự fake để UI hiển thị
            'user_message': {
              'message_text': messageText,
              'sender': 'user',
              'sent_at': DateTime.now().toIso8601String(),
            }
          }
        };
      } else if (response.statusCode == 401) {
        throw Exception('Hết phiên đăng nhập. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('Lỗi gửi tin nhắn: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      throw Exception('Lỗi gửi tin nhắn: $e');
    }
  }

  // Helper method để decode Unicode escape sequences và fix UTF-8 encoding issues
  String _decodeUnicode(String text) {
    try {
      // Bước 1: Decode Unicode escape sequences như \u00ed, \u00e0, etc.
      String decoded = text.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
      
      // Bước 2: Fix UTF-8 encoding issues với nhiều trường hợp
      try {
        if (decoded.contains('Ã') || decoded.contains('Â') || 
            decoded.contains('Æ') || decoded.contains('áº') || 
            decoded.contains('áº»') || decoded.contains('áº­')) {
          String result = decoded;
          try {
            final bytes1 = latin1.encode(decoded);
            result = utf8.decode(bytes1, allowMalformed: true);
          } catch (e) {
            // Ignore error
          }
          if (result.contains('Ã') || result.contains('Â')) {
             try {
               final bytes2 = latin1.encode(result);
               result = utf8.decode(bytes2, allowMalformed: true);
             } catch (e) {}
          }
          decoded = result;
        }
      } catch (e) {
        print('Lỗi khi fix UTF-8 encoding: $e');
      }
      return decoded;
    } catch (e) {
      print('Lỗi khi decode Unicode: $e');
      return text;
    }
  }

  // Helper method để trích xuất places từ travel_data
  List<String>? _extractPlacesFromTravelData(dynamic travelData) {
    if (travelData == null) return null;
    
    try {
      final travelDataMap = travelData as Map<String, dynamic>;
      if (travelDataMap['success'] != true) return null;
      
      final searchResults = travelDataMap['search_results'];
      if (searchResults == null || searchResults is! List) return null;
      
      final places = <String>[];
      for (final result in searchResults) {
        if (result is Map<String, dynamic> && result['ten_dia_diem'] != null) {
          final placeName = result['ten_dia_diem'] as String;
          places.add(_decodeUnicode(placeName));
        }
      }
      
      return places.isNotEmpty ? places : null;
    } catch (e) {
      print('Lỗi khi trích xuất places từ travel_data: $e');
      return null;
    }
  }

  // Gửi tin nhắn giọng nói và nhận phản hồi
  Future<Map<String, dynamic>> sendVoiceMessageAndGetResponse({
    required int conversationId,
    required String sender,
    required String audioFilePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      // POST /speech/chat
      final uri = Uri.parse(ApiService.sendVoiceMessagesUrl);
      final request = http.MultipartRequest('POST', uri);

      request.headers['accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add fields expected by backend
      request.fields['conversation_id'] = conversationId.toString();
      request.fields['sender'] = sender;

      final audioFile = File(audioFilePath);
      final fileExtension = audioFilePath.split('.').last.toLowerCase();
      final mimeType = fileExtension == 'wav' ? 'audio/wav' :
      fileExtension == 'mp3' ? 'audio/mpeg' : 'audio/wav';

      request.files.add(
        http.MultipartFile(
          'audio',
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: audioFile.path.split('/').last,
          contentType: MediaType.parse(mimeType),
        ),
      );

      print('Sending voice message to: ${request.url}');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
         final Map<String, dynamic> responseData = jsonDecode(response.body);
         if (responseData['status'] != 'success') {
           throw Exception(responseData['message'] ?? 'Lỗi không xác định');
         }
         return responseData;
      } else {
        throw Exception('❌ Lỗi server: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Lỗi gửi tin nhắn giọng nói: $e');
      throw Exception('Lỗi gửi tin nhắn giọng nói: $e');
    }
  }

  // Kết thúc cuộc trò chuyện (backend ko co end, dung delete)
  Future<void> endConversation(int conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Chưa đăng nhập (thiếu token)');
      }

      print("🔄 Deleting conversation $conversationId");
      
      final response = await http.delete(
        Uri.parse(ApiService.deleteConversationUrl(conversationId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("📥 Delete conversation response status: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ Successfully deleted conversation $conversationId");
      } else {
        print("❌ Failed to delete conversation $conversationId: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error deleting conversation $conversationId: $e");
      // Không throw exception để UI không bị crash, chỉ log lỗi
    }
  }
}
