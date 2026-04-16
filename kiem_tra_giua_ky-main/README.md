📰 Tin Tức 24h - Flutter News App
Ứng dụng đọc tin tức đa nền tảng được phát triển bằng Flutter, tuân thủ nghiêm ngặt mô hình Clean Architecture (MVVM) và áp dụng quản lý trạng thái hiện đại.
✨ Tính năng nổi bật
- Kiến trúc MVVM: Tách biệt hoàn toàn giao diện (UI) và logic xử lý (Business Logic).
- Quản lý trạng thái tập trung: Sử dụng thư viện `provider` để tối ưu hóa việc cập nhật dữ liệu trên toàn hệ thống.
- Giao tiếp API (HTTP): Tích hợp dữ liệu thời gian thực từ [NewsAPI.org](https://newsapi.org/).
- Cuộn vô hạn (Infinite Scrolling): Tự động phân trang và tải thêm tin tức khi cuộn xuống cuối danh sách, tối ưu hóa bộ nhớ.
- Trí nhớ vĩnh cửu (Local Storage): Lưu trữ cấu hình Dark Mode và danh sách bài viết "Yêu thích" bằng `shared_preferences`.
- In-App Browser: Đọc bài báo gốc ngay trong ứng dụng với bộ khung Chrome Custom Tabs thông qua `url_launcher`.
- Hoạt ảnh (Animation): Tích hợp hiệu ứng chuyển cảnh Splash Screen mượt mà và Hero Animation liên kết hình ảnh giữa các màn hình.
- Lọc danh mục động: Chuyển đổi và tải tin tức theo các chủ đề (Công nghệ, Thể thao, Giải trí, Kinh doanh,...) với hiệu ứng mượt mà.

📂 Cấu trúc thư mục (Project Structure)
Dự án được tổ chức theo chuẩn Clean Architecture giúp mã nguồn dễ đọc, dễ bảo trì và dễ dàng mở rộng trong tương lai:

```text
lib/
│
├── models/               # 📦 Các khuôn mẫu dữ liệu (Data Models)
│   └── article.dart      # Định nghĩa đối tượng Bài báo và hàm mã hóa/giải mã JSON
│
├── services/             # 🌐 Lớp giao tiếp với hệ thống bên ngoài
│   └── api_service.dart  # Chứa logic gọi HTTP requests tới NewsAPI
│
├── viewmodels/           # 🧠 Bộ não xử lý logic (Controllers / ViewModels)
│   └── news_viewmodel.dart # Quản lý State, phân trang, lọc danh mục, lưu trữ Local
│
├── views/                # 📱 Tầng giao diện người dùng (UI)
│   ├── widgets/          # Các component nhỏ có thể tái sử dụng
│   │   └── article_card.dart # Thẻ hiển thị tóm tắt bài báo (có ảnh Cache)
│   │
│   ├── detail_screen.dart    # Màn hình chi tiết (SliverAppBar, Hero Animation)
│   ├── favorite_screen.dart  # Màn hình danh sách tin đã lưu trữ
│   ├── home_screen.dart      # Màn hình chính (Drawer Menu, Danh mục, Cuộn vô hạn)
│   ├── settings_screen.dart  # Màn hình cài đặt (Dark Mode, Thông tin app)
│   └── splash_screen.dart    # Màn hình khởi động ứng dụng
│
└── main.dart             # 🚀 Điểm khởi chạy app, cấu hình MultiProvider & Theme