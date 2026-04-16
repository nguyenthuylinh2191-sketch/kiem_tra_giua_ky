// File: lib/models/article.dart

class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final DateTime publishedDate;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
  });

  // Chuyển JSON từ API thành Object Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Dùng URL làm ID luôn vì NewsAPI không có ID cố định
      id: json['url'] ?? DateTime.now().toString(), 
      title: json['title'] ?? 'Không có tiêu đề',
      description: json['description'] ?? 'Không có mô tả',
      content: json['content'] ?? '',
      // Nếu bài báo không có ảnh, lấy một ảnh mặc định
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/800x600.png?text=No+Image',
      publishedDate: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : DateTime.now(),
    );
  }
  // Chuyển Object thành Map để lưu vào máy (Encode)
  Map<String, dynamic> toMap() {
    return {
      'url': id,
      'title': title,
      'description': description,
      'content': content,
      'urlToImage': imageUrl,
      'publishedAt': publishedDate.toIso8601String(),
    };
  }

  // Chuyển Map từ máy thành Object (Decode)
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article.fromJson(map);
  }
}