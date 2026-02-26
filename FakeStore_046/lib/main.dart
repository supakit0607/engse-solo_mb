import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart'; // ต้อง import ไฟล์นี้เพิ่ม
import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ MultiProvider หุ้ม MaterialApp เพียงชั้นเดียว
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ), // เพิ่ม CartProvider ตรงนี้
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lab 10 API CRUD',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        // ตั้งหน้าแรกเป็น LoginScreen
        home: LoginScreen(),
      ),
    );
  }
}
