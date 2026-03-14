import 'package:flutter/material.dart';
import '../models/waste_point.dart'; // ตรวจสอบว่ามีบรรทัดนี้
import '../services/database_helper.dart';

class WasteProvider with ChangeNotifier {
  List<WastePoint> _items = [];
  List<WastePoint> get items => [..._items];

  Future<void> fetchAndSetPoints() async {
    _items = await DatabaseHelper.instance.readAllPoints();
    notifyListeners();
  }

  Future<void> addWastePoint(
    String title,
    String type,
    String location,
    String note,
  ) async {
    final newPoint = WastePoint(
      title: title,
      type: type,
      location: location,
      note: note,
    );
    await DatabaseHelper.instance.create(newPoint);
    await fetchAndSetPoints();
  }
}
