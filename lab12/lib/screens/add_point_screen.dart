import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waste_provider.dart';

class AddPointScreen extends StatefulWidget {
  const AddPointScreen({super.key});

  @override
  State<AddPointScreen> createState() => _AddPointScreenState();
}

class _AddPointScreenState extends State<AddPointScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedType = 'ขยะรีไซเคิล';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มจุดทิ้งขยะ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'ชื่อสถานที่'),
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: ['ขยะรีไซเคิล', 'ขยะทั่วไป', 'ขยะอันตราย'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'ตำแหน่ง/พิกัด'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'หมายเหตุ'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<WasteProvider>(
                  context,
                  listen: false,
                ).addWastePoint(
                  _titleController.text,
                  _selectedType,
                  _locationController.text,
                  _noteController.text,
                );
                Navigator.pop(context); // บันทึกเสร็จแล้วกลับหน้าหลัก
              },
              child: const Text('บันทึกข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
