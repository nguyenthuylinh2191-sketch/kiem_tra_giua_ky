// File: lib/views/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NewsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // PHẦN 1: CÀI ĐẶT HỆ THỐNG
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Hệ thống', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Chế độ tối (Dark Mode)'),
            subtitle: const Text('Bật để bảo vệ mắt khi đọc báo ban đêm'),
            value: viewModel.isDarkMode,
            onChanged: (value) => viewModel.toggleTheme(value),
          ),
          const Divider(),

          // PHẦN 2: THÔNG TIN ỨNG DỤNG
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Về ứng dụng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Phiên bản'),
            trailing: const Text('1.0.0+1'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Nhà phát triển'),
            subtitle: const Text('Nguyễn Thùy Linh - 20222268'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Giới thiệu'),
            onTap: () {
              // Hiện hộp thoại giới thiệu chuyên nghiệp
              showAboutDialog(
                context: context,
                applicationName: 'TIN TỨC 24H',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.article, size: 50, color: Colors.deepPurple),
                children: [
                  const Text('Ứng dụng đọc tin tức hiện đại được xây dựng trên nền tảng Flutter với kiến trúc Clean Architecture.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}