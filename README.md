# ChatbotMedical_client

## Giới thiệu dự án

ChatbotMedical_client là ứng dụng di động hỗ trợ y tế thông minh, tích hợp AI chatbot để tư vấn sức khỏe ban đầu cho người dùng. Ứng dụng giúp người dùng tra cứu thông tin y tế, nhận lời khuyên sức khỏe và theo dõi tình trạng cá nhân một cách thuận tiện và nhanh chóng.

## Mục tiêu & Ý nghĩa

-   Hỗ trợ người dùng giải đáp thắc mắc y tế nhanh chóng 24/7.
-   Cung cấp thông tin chính xác về các vấn đề sức khỏe phổ biến.
-   Giảm tải cho nhân viên y tế ở các bước tư vấn ban đầu.
-   Nâng cao ý thức chăm sóc sức khỏe của cộng đồng.

## Đối tượng sử dụng

-   Người cần tư vấn sức khỏe nhanh chóng.
-   Bệnh nhân muốn tra cứu thông tin thuốc hoặc bệnh lý.
-   Người quan tâm đến việc theo dõi và chăm sóc sức khỏe cá nhân.

## Công nghệ sử dụng

-   **Flutter**: Xây dựng ứng dụng đa nền tảng (Android, iOS, Web).
-   **Provider**: Quản lý trạng thái.
-   **AI Chatbot**: Tư vấn, trả lời tự động các câu hỏi y tế (Sử dụng PhoBERT/LLM).
-   **Shared Preferences**: Lưu trữ dữ liệu cục bộ.
-   **Các package khác**: http, google_fonts, ...

## Tính năng chính

-   Đăng ký, đăng nhập, bảo mật thông tin người dùng.
-   **Chatbot AI Y tế**: Hỏi đáp về triệu chứng, thuốc, bệnh lý và nhận lời khuyên sức khỏe.
-   Tra cứu lịch sử trò chuyện y tế.
-   Giao diện thân thiện, dễ sử dụng.

## Hướng dẫn cài đặt

### Yêu cầu hệ thống

-   Flutter SDK >= 3.7.2
-   Dart SDK >= 3.7.2
-   Android Studio/Xcode hoặc thiết bị thật/giả lập

### Các bước cài đặt

1.  **Clone dự án:**
    ```bash
    git clone 
    cd ChatbotMedical_client
    ```
2.  **Cài đặt dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Cấu hình biến môi trường (nếu có):**
    -   Tạo file `.env` ở thư mục gốc nếu cần cấu hình API URL.

4.  **Chạy ứng dụng:**
    -   Android:
        ```bash
        flutter run -d android
        ```
    -   iOS:
        ```bash
        flutter run -d ios
        ```
    -   Web:
        ```bash
        flutter run -d chrome
        ```

## Đóng góp

Chào mừng mọi đóng góp! Vui lòng xem hướng dẫn chi tiết tại [CONTRIBUTING.md](CONTRIBUTING.md)

## License

Dự án sử dụng giấy phép MIT. Xem chi tiết tại [LICENSE.md](LICENSE.md)

## Quy tắc ứng xử

Vui lòng tuân thủ [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) khi tham gia đóng góp.

## Bảo mật

Nếu phát hiện lỗ hổng bảo mật, vui lòng xem hướng dẫn tại [SECURITY.md](SECURITY.md)
