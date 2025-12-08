import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mobilev2/models/conversation_model.dart';
import 'package:mobilev2/models/message_model.dart';
import 'package:mobilev2/services/api_service.dart';

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
        final responseData = jsonDecode(response.body);
        final conversationJson = responseData['data'];
        return Conversation.fromJson(conversationJson);
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
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Không thể tải danh sách cuộc trò chuyện');
      }
    } catch (e) {
      throw Exception('Lỗi tải cuộc trò chuyện: $e');
    }
  }

  // Lấy tin nhắn của một cuộc trò chuyện
  Future<List<Message>> getConversationMessages(int conversationId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiService.messagesByConversationUrl(conversationId)),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonData = jsonMap['data'];
        
        print("📥 Loading ${jsonData.length} messages for conversation $conversationId");
        
        return jsonData.map((json) {
          // Đảm bảo tin nhắn cũ có places = null
          if (json['places'] == null) {
            json['places'] = null;
          }
          
          // In thông tin places cho mỗi tin nhắn
          final messageId = json['message_id'] ?? 'N/A';
          final sender = json['sender'] ?? 'N/A';
          final messageText = json['message_text'] ?? '';
          final places = json['places'];
          
          print("📨 Message ID: $messageId | Sender: $sender");
          print("   📝 Text: ${messageText.length > 50 ? '${messageText.substring(0, 50)}...' : messageText}");
          print("   🏛️ Places: $places");
          
          if (places != null && places is List) {
            print("   📍 Places count: ${places.length}");
            for (int i = 0; i < places.length; i++) {
              print("      ${i + 1}. ${places[i]}");
            }
          } else if (places != null) {
            print("   ⚠️ Places is not a List: ${places.runtimeType}");
          } else {
            print("   ❌ No places data");
          }
          print("   " + "-" * 50);
          
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

  // Lưu tin nhắn vào database
  Future<Map<String, dynamic>> sendMessageAndGetResponse({
    required int conversationId,
    required String sender,
    required String messageText,
    String translatedText = '',
    String messageType = 'text',
    String? voiceUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.sendMessageUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversation_id': conversationId,
          'sender': sender,
          'message_text': messageText,
          'translated_text': translatedText,
          'message_type': messageType,
          'voice_url': voiceUrl,
          'sent_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Kiểm tra status
        if (responseData['status'] != 'success') {
          throw Exception(responseData['message'] ?? 'Lỗi không xác định');
        }

        // Xử lý travel_data và thêm places vào bot_message
        final data = responseData['data'] as Map<String, dynamic>;
        
        // Xử lý user_message - KHÔNG thêm places vì user không gợi ý địa điểm
        if (data['user_message'] != null) {
          final userMessage = data['user_message'] as Map<String, dynamic>;
          userMessage['places'] = null; // User message không có places
        }
        
        // Xử lý bot_message - Thêm places vì bot gợi ý địa điểm
        if (data['bot_message'] != null) {
          final botMessage = data['bot_message'] as Map<String, dynamic>;
          botMessage['places'] = _extractPlacesFromTravelData(data['travel_data']);
        }

        return responseData;
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi gửi tin nhắn: $e');
    }
  }

  // Helper method để decode Unicode escape sequences và fix UTF-8 encoding issues
  String _decodeUnicode(String text) {
    try {
      print("🔍 Original text: $text");
      
      // Bước 1: Decode Unicode escape sequences như \u00ed, \u00e0, etc.
      String decoded = text.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})'),
        (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
      print("🔍 After Unicode decode: $decoded");
      
      // Bước 2: Fix UTF-8 encoding issues với nhiều trường hợp
      try {
        // Kiểm tra các ký tự UTF-8 bị encode sai
        if (decoded.contains('Ã') || decoded.contains('Â') || 
            decoded.contains('Æ') || decoded.contains('áº') || 
            decoded.contains('áº»') || decoded.contains('áº­')) {
          print("🔍 Detected UTF-8 encoding issues, attempting multiple fixes...");
          
          // Thử nhiều cách decode khác nhau
          String result = decoded;
          
          // Cách 1: Latin-1 -> UTF-8
          try {
            final bytes1 = latin1.encode(decoded);
            result = utf8.decode(bytes1, allowMalformed: true);
            print("🔍 After Latin-1 -> UTF-8: $result");
          } catch (e) {
            print('Lỗi Latin-1 -> UTF-8: $e');
          }
          
          // Cách 2: Nếu vẫn còn vấn đề, thử decode lại
          if (result.contains('Ã') || result.contains('Â') || 
              result.contains('Æ') || result.contains('áº')) {
            try {
              final bytes2 = latin1.encode(result);
              result = utf8.decode(bytes2, allowMalformed: true);
              print("🔍 After second Latin-1 -> UTF-8: $result");
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
              print("🔍 After ISO-8859-1 -> UTF-8: $result");
            } catch (e) {
              print('Lỗi ISO-8859-1 -> UTF-8: $e');
            }
          }
          
          decoded = result;
        }
      } catch (e) {
        print('Lỗi khi fix UTF-8 encoding: $e');
      }
      
      print("🔍 Final decoded text: $decoded");
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
      
      // Kiểm tra success = true
      if (travelDataMap['success'] != true) return null;
      
      // Kiểm tra search_results
      final searchResults = travelDataMap['search_results'];
      print("ℹ️ searchResults $searchResults");
      if (searchResults == null || searchResults is! List) return null;
      
      // Trích xuất ten_dia_diem từ search_results và decode Unicode
      final places = <String>[];
      for (final result in searchResults) {
        if (result is Map<String, dynamic> && result['ten_dia_diem'] != null) {
          final placeName = result['ten_dia_diem'] as String;
          // Decode Unicode escape sequences
          final decodedPlaceName = _decodeUnicode(placeName);
          print("ℹ️ decodedPlaceName: $decodedPlaceName");
          places.add(decodedPlaceName);
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
      // Tạo request multipart/form-data
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.sendVoiceMessagesUrl(conversationId, sender)),
      );

      // Thêm headers giống như trong curl command
      request.headers['accept'] = 'application/json';

      // Xác định loại file audio
      final audioFile = File(audioFilePath);
      final fileExtension = audioFilePath.split('.').last.toLowerCase();
      final mimeType = fileExtension == 'wav' ? 'audio/wav' :
      fileExtension == 'mp3' ? 'audio/mpeg' : 'audio/wav';

      // Thêm file audio vào request với mime type chính xác
      request.files.add(
        http.MultipartFile(
          'audio',  // Tên field phải là 'audio' như trong curl command
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: audioFile.path.split('/').last,
          contentType: MediaType.parse(mimeType),
        ),
      );

      print('Sending voice message to: ${request.url}');
      print('File path: $audioFilePath');
      print('File size: ${audioFile.lengthSync()} bytes');
      print('MIME type: $mimeType');

      // Gửi request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Kiểm tra status
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

  // Kết thúc cuộc trò chuyện
  Future<void> endConversation(int conversationId) async {
    try {
      print("🔄 Ending conversation $conversationId");
      
      final response = await http.post(
        Uri.parse(ApiService.endConversationUrl(conversationId)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ended_at': DateTime.now().toIso8601String()}),
      );

      print("📥 End conversation response status: ${response.statusCode}");
      print("📥 End conversation response body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Successfully ended conversation $conversationId");
      } else if (response.statusCode == 409) {
        // Conversation đã được kết thúc trước đó - coi như thành công
        print("ℹ️ Conversation $conversationId is already ended (409) - treating as success");
      } else {
        print("❌ Failed to end conversation $conversationId: ${response.statusCode}");
        print("❌ Response body: ${response.body}");
        throw Exception('Không thể kết thúc cuộc trò chuyện: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error ending conversation $conversationId: $e");
      throw Exception('Lỗi kết thúc cuộc trò chuyện: $e');
    }
  }
}
