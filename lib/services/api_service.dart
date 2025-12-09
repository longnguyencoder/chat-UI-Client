import 'package:flutter/foundation.dart';

class ApiService {
  // Config Base URL
  static String get _baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:5000/api";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:5000/api";
    } else {
      return "http://127.0.0.1:5000/api";
    }
  }

  // ========================================================================
  // AUTHENTICATION API (Đã đúng)
  // ========================================================================
  static String get loginUrl => "$_baseUrl/auth/login";
  static String get registerUrl => "$_baseUrl/auth/register";
  static String get verifyOtpUrl => "$_baseUrl/auth/verify-otp";
  static String get forgotPasswordUrl => "$_baseUrl/auth/forgot-password";
  static String get verifyForgotPasswordOtpUrl => "$_baseUrl/auth/verify-reset-otp";
  static String get resetPasswordUrl => "$_baseUrl/auth/reset-password";
  static String get updateUsernameUrl => "$_baseUrl/auth/update-username"; 
  static String get resendRegisterOtpUrl => "$_baseUrl/auth/resend-register-otp";
  static String get resendForgotPasswordOtpUrl => "$_baseUrl/auth/resend-forgot-password-otp";

  // ========================================================================
  // MEDICAL CHATBOT API (Cần sửa lại cho đúng Backend)
  // ========================================================================
  
  // POST: Tạo cuộc hội thoại mới
  static String get createNewConversationUrl =>
      "$_baseUrl/medical-chatbot/conversations";

  // GET: Lấy danh sách hội thoại
  // Backend cần query param: ?user_id=...
  static String getUserConversationsUrl(int userId) =>
      "$_baseUrl/medical-chatbot/conversations?user_id=$userId";

  // GET: Lấy lịch sử tin nhắn
  // ⚠️ SỬA: Backend dùng /history/<id> và cần ?user_id=...
  static String messagesByConversationUrl(int conversationId, int userId) =>
      "$_baseUrl/medical-chatbot/history/$conversationId?user_id=$userId";

  // POST: Gửi tin nhắn
  // ⚠️ SỬA: Backend dùng /chat-secure (Yêu cầu JWT Token)
  static String get sendMessageUrl => "$_baseUrl/medical-chatbot/chat-secure";

  // POST: Gửi voice
  // ⚠️ SỬA: Backend nhận voice tại /speech/chat (không phải /medical-chatbot/...)
  static String get sendVoiceMessagesUrl => 
      "$_baseUrl/speech/chat";

  // DELETE: Xóa cuộc hội thoại (Thay cho End Conversation)
  static String deleteConversationUrl(int conversationId) =>
      "$_baseUrl/medical-chatbot/conversations/$conversationId";
      
  // ⚠️ Backend hiện tại KHÔNG có endpoint "end conversation".
  // Bạn nên dùng deleteConversationUrl nếu muốn xóa, hoặc chỉ cần reset state ở client.

  // ========================================================================
  // HEALTH PROFILE API
  // ========================================================================
  
  // GET: Lấy hồ sơ sức khỏe
  static String getHealthProfileUrl(int userId) =>
      "$_baseUrl/health-profile?user_id=$userId";
  
  // PUT: Cập nhật hồ sơ sức khỏe
  static String get updateHealthProfileUrl => "$_baseUrl/health-profile";

  // ========================================================================
  // STUBS (Giữ nguyên để code không lỗi compile, nhưng backend chưa có)
  // ========================================================================
  static String get detectAttractionsUrl => "$_baseUrl/map/attractions/from-places";
  static String get searchAttractionsUrl => "$_baseUrl/map/attractions/search";
  static String get createItineraryUrl => "$_baseUrl/itinerary/create";
  static String getItineraryByUserIdUrl(int userId) => "$_baseUrl/itinerary/list?user_id=$userId";
  static String removeItineraryUrl(int itineraryId, int userId) => "$_baseUrl/itinerary/delete?itinerary_id=$itineraryId&user_id=$userId";
}