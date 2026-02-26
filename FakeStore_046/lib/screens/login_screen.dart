import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatelessWidget {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            TextField(
              controller: userCtrl,
              decoration: const InputDecoration(labelText: 'ชื่อผู้ใช้'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if ((userCtrl.text == 'admin' || userCtrl.text == 'user') &&
                      passCtrl.text == '1234') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListScreen(
                          isAdmin: userCtrl.text == 'admin',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เข้าสู่ระบบไม่สำเร็จ!')),
                    );
                  }
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
