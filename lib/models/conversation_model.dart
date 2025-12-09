class Conversation {
  final int conversationId;
  final int userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String sourceLanguage;
  final String? title;

  Conversation({
    required this.conversationId,
    required this.userId,
    this.endedAt,       // Có thể null
    required this.startedAt,
    this.sourceLanguage = 'vi', // Mặc định là 'vi'
    this.title
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    // Debug để xem chính xác Backend trả về gì
    print("📦 Conversation JSON: $json"); 

    return Conversation(
      // Backend trả về 'conversation_id', fallback 0 nếu null
      conversationId: json['conversation_id'] ?? 0,
      
      // Backend KHÔNG trả user_id khi tạo mới -> fallback 0
      userId: json['user_id'] ?? 0,
      
      startedAt: json['started_at'] != null 
          ? DateTime.parse(json['started_at']) 
          : DateTime.now(),
          
      endedAt: json['ended_at'] != null 
          ? DateTime.parse(json['ended_at']) 
          : null,
          
      sourceLanguage: json['source_language'] ?? 'vi',
      title: json['title'] ?? 'Cuộc trò chuyện mới'
    );
  }
  
  // ... toJson và copyWith giữ nguyên
}