import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/user_api_service.dart';

class ProductListScreen extends StatelessWidget {
  final bool isAdmin; // รับค่าสิทธิ์มาจากหน้า Login

  const ProductListScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการสินค้า'),
        actions: [
          // ถ้าเป็น Admin (id=1) ให้โชว์ปุ่มจัดการ User (ไอคอนสีแดง)
          if (isAdmin)
            const Icon(Icons.admin_panel_settings, color: Colors.red),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: UserApiService().fetchProducts(), // เรียก API สินค้า
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              return Card(
                child: ListTile(
                  leading: Image.network(item.image, width: 50),
                  title: Text(item.title),
                  subtitle: Text('\$${item.price}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
