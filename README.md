# 🌤️ Lab 8B - Weather Companion App (Ứng dụng Trợ lý Thời tiết)

## 1. Thông tin chung
- **Học phần:** PRM393 - Lập trình Di động Flutter
- **Bài tập:** Lab 8B – Practical REST API Integration
- **Họ và tên sinh viên:** Phạm Khương Duy
- **Mã số sinh viên:** HE186849

---

## 2. Mô tả ứng dụng & Vấn đề giải quyết
- **Kịch bản lựa chọn (Scenario):** Scenario A – Weather Companion App.
- **Vấn đề giải quyết:** Ứng dụng giúp người dùng theo dõi thời tiết thời gian thực tại 3 thành phố lớn của Việt Nam (Hà Nội, Đà Nẵng, TP. Hồ Chí Minh) bằng cách kết nối trực tiếp tới API công cộng **Open-Meteo**.
- **Tính năng hướng tới người dùng (Purpose-driven):** Không chỉ hiển thị các thông số thô (nhiệt độ, tốc độ gió), ứng dụng tích hợp bộ lọc logic thông minh để tự động phân tích và đưa ra khuyến nghị thực tế cho người dùng ngay trong ngày:
    - Dự báo trời mưa ➡️ Nhắc nhở đem theo ô (dù).
    - Trời quá nóng (>32°C) ➡️ Khuyên hạn chế hoạt động thể thao ngoài trời để bảo vệ sức khỏe.
    - Thời tiết mát mẻ (20°C - 28°C) ➡️ Gợi ý đi dạo, thư giãn.

---

## 3. Kiến trúc mã nguồn (Service Layer Pattern)
Dự án được tổ chức tách biệt rõ ràng theo đúng yêu cầu kỹ thuật:
- `lib/lab_8B/models/weather_model.dart`: Xử lý cấu trúc dữ liệu Model và chuyển đổi JSON thành Dart Object (`fromJson`).
- `lib/lab_8B/services/weather_service.dart`: Lớp dịch vụ chịu trách nhiệm kết nối mạng HTTP, gọi API và bắt lỗi hệ thống.
- `lib/lab_8B/screens/weather_screen.dart`: Giao diện người dùng xử lý 3 trạng thái bằng `FutureBuilder`: *Loading* (Đang tải), *Error* (Xử lý lỗi mạng kèm nút Thử lại), và *Data* (Hiển thị kết quả).

---

## 4. Hướng dẫn chạy dự án
Chạy lệnh sau trong Terminal để chỉ định chạy riêng bài Lab 8B trên trình duyệt Chrome:
```bash
flutter run -d chrome -t lib/lab_8B/main_lab8B.dart