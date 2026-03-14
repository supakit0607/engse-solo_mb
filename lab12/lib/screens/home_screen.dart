import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waste_provider.dart';
import 'add_point_screen.dart'; // อย่าลืม import หน้าเพิ่มข้อมูล

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // สั่งให้ดึงข้อมูลจาก Database ทันทีที่หน้าจอถูกสร้าง
    // ใช้ listen: false เพราะเราเรียกใน build โดยตรง
    Provider.of<WasteProvider>(context, listen: false).fetchAndSetPoints();

    return Scaffold(
      appBar: AppBar(
        title: const Text('จุดทิ้งขยะในชุมชน'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<WasteProvider>(
        builder: (context, provider, child) {
          // ถ้ายังไม่มีข้อมูลในลิสต์
          if (provider.items.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีข้อมูลจุดทิ้งขยะ\nกดปุ่ม + เพื่อเพิ่มข้อมูล',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // ถ้ามีข้อมูล ให้แสดงผลเป็น ListView
          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
                title: Text(
                  provider.items[i].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'ประเภท: ${provider.items[i].type}\nพิกัด: ${provider.items[i].location}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // เปิดไปยังหน้าฟอร์มสำหรับเพิ่มข้อมูล
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPointScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
