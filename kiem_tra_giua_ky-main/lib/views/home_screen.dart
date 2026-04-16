// File: lib/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';
import 'widgets/article_card.dart';
import 'favorite_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  
  // 1. Thêm cảm biến cuộn để làm chức năng Cuộn vô hạn
  final ScrollController _scrollController = ScrollController();

  // Danh sách các danh mục (Categories) chuẩn của NewsAPI
  final List<Map<String, String>> categories = [
    {'name': 'Tất cả', 'slug': 'general'},
    {'name': 'Công nghệ', 'slug': 'technology'},
    {'name': 'Kinh doanh', 'slug': 'business'},
    {'name': 'Giải trí', 'slug': 'entertainment'},
    {'name': 'Sức khỏe', 'slug': 'health'},
    {'name': 'Thể thao', 'slug': 'sports'},
  ];

  @override
  void initState() {
    super.initState();
    // Vừa vào màn hình là gọi API lấy tin tức ngay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().fetchNews();
    });

    // Lắng nghe sự kiện cuộn màn hình
    _scrollController.addListener(() {
      // Nếu cuộn đến sát mép dưới cùng (cách 200 pixel) thì tự động tải trang tiếp theo
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<NewsViewModel>().fetchNews(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Nhớ hủy controller để tránh nặng máy
    _searchController.dispose();
    super.dispose();
  }

  // 2. Widget tách riêng: Thanh cuộn ngang chọn Danh mục
  Widget _buildCategoryBar(NewsViewModel viewModel) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          // Kiểm tra xem danh mục này có đang được chọn không
          bool isSelected = viewModel.currentCategory == category['slug'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChoiceChip(
              label: Text(category['name']!),
              selected: isSelected,
              selectedColor: Colors.deepPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (viewModel.isDarkMode ? Colors.white : Colors.black),
              ),
              onSelected: (selected) {
                if (selected) {
                  // Bấm vào thì báo ViewModel đổi danh mục và tải lại
                  viewModel.setCategory(category['slug']!);
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Đọc trạng thái DarkMode để set màu nền cho chuẩn
    final isDark = context.watch<NewsViewModel>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      
      // MENU ẨN (DRAWER)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Xin chào, Lập trình viên!', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.deepPurple),
              title: const Text('Trang chủ'),
              onTap: () => Navigator.pop(context), 
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Tin Yêu Thích'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),

      // THANH APPBAR (Có Search)
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm tin tức...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<NewsViewModel>().searchNews(value);
                },
              )
            : const Text('Tin tức mới nhất', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<NewsViewModel>().searchNews(''); 
                }
              });
            },
          )
        ],
      ),

      // PHẦN BODY: Gồm Category Bar ở trên và Danh sách tin ở dưới
      body: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          
          // Lỗi mạng
          if (viewModel.errorMessage.isNotEmpty && !viewModel.isFetchingMore) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchNews(isLoadMore: false),
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          return Column(
            children: [
              // 1. THANH CHỌN DANH MỤC
              _buildCategoryBar(viewModel),

              // 2. DANH SÁCH TIN TỨC (Chiếm phần diện tích còn lại)
              Expanded(
                child: viewModel.isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                  : viewModel.articles.isEmpty
                      ? const Center(child: Text('Không tìm thấy bài viết nào.'))
                      : RefreshIndicator(
                          onRefresh: () async {
                            await viewModel.fetchNews(isLoadMore: false);
                          },
                          // 3. GẮN CẢM BIẾN CUỘN VÀO LISTVIEW
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            // Thêm 1 item ở cuối để làm chỗ chứa vòng xoay "Đang tải thêm"
                            itemCount: viewModel.articles.length + (viewModel.isFetchingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Nếu cuộn đến cuối cùng thì hiện Loading
                              if (index == viewModel.articles.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
                                );
                              }
                              
                              final article = viewModel.articles[index];
                              return ArticleCard(article: article); 
                            },
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}