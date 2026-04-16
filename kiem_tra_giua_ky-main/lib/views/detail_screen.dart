// File: lib/views/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Thêm thư viện mở web
import '../models/article.dart';
import '../viewmodels/news_viewmodel.dart';

class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  // Hàm gọi trình duyệt mở link bài viết gốc
  Future<void> _openRealArticle(BuildContext context) async {
    // Nhớ lại hôm trước, ta đã dùng chính link URL để làm article.id
    final Uri url = Uri.parse(article.id); 
    try {
      // mode: LaunchMode.inAppWebView giúp mở web ngay trong app mà không bị văng ra Chrome/Safari ngoài
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể mở đường dẫn này!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đường dẫn bài báo bị lỗi!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Thanh AppBar chứa ảnh
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: article.id,
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(color: Colors.grey),
                ),
              ),
            ),
            actions: [
              Consumer<NewsViewModel>(
                builder: (context, viewModel, child) {
                  final isFav = viewModel.isFavorite(article);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    color: isFav ? Colors.red : Colors.white,
                    onPressed: () => viewModel.toggleFavorite(article),
                  );
                },
              ),
            ],
          ),

          // Nội dung chi tiết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat("'Ngày' dd 'tháng' MM, yyyy").format(article.publishedDate),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 40),
                  
                  // HIỂN THỊ ĐOẠN TÓM TẮT (in nghiêng, chữ xám)
                  Text(
                    article.description,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[800], height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // HIỂN THỊ NỘI DUNG MÀ API TRẢ VỀ
                  Text(
                    article.content,
                    style: const TextStyle(fontSize: 18, height: 1.6),
                  ),
                  
                  const SizedBox(height: 40),

                  // NÚT ĐỌC BÀI VIẾT GỐC CHUYÊN NGHIỆP
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () => _openRealArticle(context),
                      icon: const Icon(Icons.public, color: Colors.white),
                      label: const Text('Đọc bài viết gốc', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Nút Floating Action Button quay lại
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}