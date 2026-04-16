// Mở file lib/main.dart, thay đổi phần import và phần MaterialApp:

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/news_viewmodel.dart';
import 'views/splash_screen.dart'; // Import file mới tạo

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NewsViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái Dark Mode
    final isDark = context.watch<NewsViewModel>().isDarkMode;

    return MaterialApp(
      title: 'App Tin Tức Điểm A+',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light, // Chuyển chế độ
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}