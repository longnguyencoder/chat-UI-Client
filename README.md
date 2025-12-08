# ChatbotTravel_client

## Giới thiệu dự án

ChatbotTravel_client là ứng dụng di động hỗ trợ du lịch thông minh, tích hợp AI chatbot, bản đồ tương tác và lập lịch trình cá nhân hóa cho người dùng tại Việt Nam. Ứng dụng giúp người dùng tìm kiếm, lên kế hoạch, khám phá các địa điểm du lịch, ẩm thực, giải trí một cách thuận tiện và hiện đại.

## Mục tiêu & Ý nghĩa

- Hỗ trợ người dùng lên lịch trình du lịch tối ưu, tiết kiệm thời gian và chi phí.
- Cung cấp thông tin địa điểm, gợi ý hành trình, bản đồ tương tác và trò chuyện AI.
- Thúc đẩy chuyển đổi số trong lĩnh vực du lịch, nâng cao trải nghiệm cá nhân hóa.

## Đối tượng sử dụng

- Khách du lịch trong và ngoài nước muốn khám phá Việt Nam.
- Người trẻ yêu thích công nghệ, trải nghiệm mới.
- Các gia đình, nhóm bạn, cá nhân cần lập kế hoạch du lịch tiện lợi.

## Công nghệ sử dụng

- **Flutter**: Xây dựng ứng dụng đa nền tảng (Android, iOS, Web, Desktop)
- **Mapbox, flutter_map**: Bản đồ tương tác, chỉ đường
- **Provider**: Quản lý trạng thái
- **AI Chatbot**: Tư vấn, trả lời tự động, gợi ý lịch trình
- **Shared Preferences**: Lưu trữ dữ liệu cục bộ
- **Table Calendar, Timeline Tile**: Quản lý lịch trình trực quan
- **Geolocator, Permission Handler**: Định vị, xin quyền truy cập vị trí
- **Các package khác**: http, audioplayers, url_launcher, pdf, printing, google_fonts...

## Tính năng chính

- Đăng ký, đăng nhập, quên mật khẩu, xác thực OTP
- Chatbot AI hỗ trợ hỏi đáp, gợi ý lịch trình, địa điểm
- Tìm kiếm, xem chi tiết các điểm du lịch, ẩm thực, giải trí
- Lập và lưu lịch trình cá nhân hóa, xuất PDF
- Bản đồ tương tác, chỉ đường, tìm kiếm địa điểm trên bản đồ
- Quản lý tài khoản, cá nhân hóa trải nghiệm
- Đa ngôn ngữ (Tiếng Việt, English, ...)
- Bảo mật thông tin người dùng

## Hướng dẫn cài đặt

### Yêu cầu hệ thống

- Flutter SDK >= 3.7.2
- Dart SDK >= 3.7.2
- Android Studio/Xcode hoặc thiết bị thật/giả lập

### Các bước cài đặt

1. **Clone dự án:**
   ```bash
   git clone https://github.com/phamvangjang/ChatbotTravel_client
   cd ChatbotTravel_client
   ```
2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

   1. **Cấu hình biến môi trường:**
      - Tạo file `.env` ở thư mục gốc, thêm token Mapbox:
        ```
        MAPBOX_ACCESS_TOKEN=your_mapbox_token
        ```
3. **Chạy ứng dụng:**
   - Android:
     ```bash
     flutter run -d android
     ```
   - iOS:
     ```bash
     flutter run -d ios
     ```
   - Web:
     ```bash
     flutter run -d chrome
     ```
4. **Kiểm tra các tính năng:**
   - Đăng ký, đăng nhập, chat với AI, tạo lịch trình, xem bản đồ...

## Đóng góp

Chào mừng mọi đóng góp! Vui lòng xem hướng dẫn chi tiết tại [CONTRIBUTING.md](CONTRIBUTING.md)

## License

Dự án sử dụng giấy phép MIT. Xem chi tiết tại [LICENSE.md](LICENSE.md)

## Quy tắc ứng xử

Vui lòng tuân thủ [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) khi tham gia đóng góp.

## Bảo mật

Nếu phát hiện lỗ hổng bảo mật, vui lòng xem hướng dẫn tại [SECURITY.md](SECURITY.md)
