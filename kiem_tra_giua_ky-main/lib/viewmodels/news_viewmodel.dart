// File: lib/viewmodels/news_viewmodel.dart

import 'dart:convert'; // Thêm thư viện này để mã hóa JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện lưu trữ
import '../models/article.dart';
import '../services/api_service.dart';

class NewsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Quản lý Danh mục (Mặc định là tin chung - general)
  String _currentCategory = 'general';
  String get currentCategory => _currentCategory;

  // Các danh sách dữ liệu
  List<Article> _articles = [];
  List<Article> _filteredArticles = []; // Dành cho hiển thị & tìm kiếm
  
  // LƯU Ý: Đã bỏ chữ 'final' ở đây để có thể load lại dữ liệu từ đĩa
  List<Article> _favoriteArticles = []; 

  // Quản lý trạng thái
  bool _isLoading = false;          // Trạng thái load lần đầu hoặc refresh
  bool _isFetchingMore = false;     // Trạng thái load trang tiếp theo
  int _currentPage = 1;             // Trang hiện tại
  String _errorMessage = '';
  bool _isDarkMode = false;         // Trạng thái Dark Mode

  // Getters
  List<Article> get articles => _filteredArticles; 
  List<Article> get favoriteArticles => _favoriteArticles;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String get errorMessage => _errorMessage;
  bool get isDarkMode => _isDarkMode;

  // HÀM KHỞI TẠO: Tự động load dữ liệu đã lưu khi vừa mở App
  NewsViewModel() {
    _loadFromDisk();
  }

  // --- CÁC HÀM XỬ LÝ LƯU TRỮ VĨNH CỬU ---

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lưu trạng thái Dark Mode
    await prefs.setBool('isDarkMode', _isDarkMode);
    
    // Lưu Danh sách yêu thích (Ép Object thành chuỗi JSON)
    List<String> favListJson = _favoriteArticles.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList('favoriteArticles', favListJson);
  }

  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Đọc trạng thái Dark Mode
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    
    // Đọc Danh sách yêu thích (Giải mã chuỗi JSON thành Object)
    List<String>? favListJson = prefs.getStringList('favoriteArticles');
    if (favListJson != null) {
      _favoriteArticles = favListJson.map((item) => Article.fromMap(jsonDecode(item))).toList();
    }
    notifyListeners(); // Báo cho UI cập nhật giao diện ngay
  }

  // --- CÁC HÀM NGHIỆP VỤ (LOGIC) ---

  // Chọn danh mục mới
  Future<void> setCategory(String category) async {
    if (_currentCategory == category) return; // Nếu chọn trùng thì không làm gì cả
    _currentCategory = category;
    await fetchNews(isLoadMore: false); // Gọi API lấy tin theo danh mục mới
  }

  // 1. Hàm gọi API lấy dữ liệu
  Future<void> fetchNews({bool isLoadMore = false}) async {
    if (_isLoading || _isFetchingMore) return;

    if (isLoadMore) {
      _isFetchingMore = true;
      _currentPage++;
    } else {
      _isLoading = true;
      _currentPage = 1;
      _articles.clear();
      _errorMessage = '';
    }
    
    notifyListeners(); 

    try {
      // Truyền thêm tham số category vào hàm fetchNews của ApiService
      final List<Article> newArticles = await _apiService.fetchNews(
        page: _currentPage, 
        category: _currentCategory,
      );
      
      if (isLoadMore) {
        _articles.addAll(newArticles);
      } else {
        _articles = newArticles;
      }
      
      _filteredArticles = _articles; 
    } catch (e) {
      _errorMessage = 'Không thể tải tin tức. Vui lòng thử lại!';
      if (isLoadMore) _currentPage--; 
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners(); 
    }
  }

  // 2. Hàm tìm kiếm bài viết
  void searchNews(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles
          .where((article) => article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); 
  }

  // 3. Hàm thả tim / Hủy thả tim (Đã tích hợp lưu tự động)
  void toggleFavorite(Article article) {
    // Dùng .any để kiểm tra ID thay vì kiểm tra nguyên Object (an toàn hơn khi load từ disk)
    if (_favoriteArticles.any((a) => a.id == article.id)) {
      _favoriteArticles.removeWhere((a) => a.id == article.id);
    } else {
      _favoriteArticles.add(article);
    }
    _saveToDisk(); // <--- GHI XUỐNG Ổ CỨNG NGAY LẬP TỨC
    notifyListeners(); 
  }

  // 4. Kiểm tra trạng thái yêu thích
  bool isFavorite(Article article) {
    return _favoriteArticles.any((a) => a.id == article.id);
  }

  // 5. Nút gạt Dark Mode (Đã tích hợp lưu tự động)
  void toggleTheme(bool value) {
    _isDarkMode = value;
    _saveToDisk(); // <--- GHI XUỐNG Ổ CỨNG NGAY LẬP TỨC
    notifyListeners(); 
  }
}