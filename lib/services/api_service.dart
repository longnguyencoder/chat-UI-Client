class ApiService {
  // static const String _baseUrl = "http://10.0.2.2:5000/api";
  static const String _baseUrl = "http://localhost:5000/api";

  //auth api
  static String get loginUrl => "$_baseUrl/auth/login";
  static String get registerUrl => "$_baseUrl/auth/register";
  static String get verifyOtpUrl => "$_baseUrl/auth/verify-otp";
  static String get forgotPasswordUrl => "$_baseUrl/auth/forgot-password";
  static String get verifyForgotPasswordOtpUrl => "$_baseUrl/auth/verify-reset-otp";
  static String get resetPasswordUrl => "$_baseUrl/auth/reset-password";
  static String get updateUsernameUrl => "$_baseUrl/auth/update-username";
  static String get resendRegisterOtpUrl => "$_baseUrl/auth/resend-register-otp";
  static String get resendForgotPasswordOtpUrl => "$_baseUrl/auth/resend-forgot-password-otp";

  //chatting api
  static String get createNewConversationUrl =>
      "$_baseUrl/chatting/conversations";
  static String getUserConversationsUrl(int userId) =>
      "$_baseUrl/chatting/conversations/list?user_id=$userId";
  static String messagesByConversationUrl(int conversationId) =>
      "$_baseUrl/chatting/conversations/messages?conversation_id=$conversationId";
  static String get saveMessageUrl => "$_baseUrl/chatting/messages";
  static String get sendMessageUrl => "$_baseUrl/chatting/messages/update";
  static String endConversationUrl(int conversationId) =>
      "$_baseUrl/chatting/conversations/end?conversation_id=$conversationId";
  static String sendVoiceMessagesUrl(int conversationId, String sender) => "$_baseUrl/chatting/messages/voice?conversation_id=$conversationId&sender=$sender";

  //map api
  static String get detectAttractionsUrl => "$_baseUrl/map/attractions/from-places";
  static String get searchAttractionsUrl => "$_baseUrl/map/attractions/search";

  //itinerary api
  static String get createItineraryUrl => "$_baseUrl/itinerary/create";
  static String getItineraryByUserIdUrl(int userId) => "$_baseUrl/itinerary/list?user_id=$userId";
  static String removeItineraryUrl(int itineraryId, int userId) => "$_baseUrl/itinerary/delete?itinerary_id=$itineraryId&user_id=$userId";
}
/*
# Kiểm tra thiết bị
adb devices

# Forward port
adb reverse tcp:5000 tcp:5000

# Kiểm tra
adb reverse --list
✅ ❌ ℹ️
 */
