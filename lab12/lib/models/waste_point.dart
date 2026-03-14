class WastePoint {
  final int? id;
  final String title;
  final String type;
  final String location;
  final String note;

  WastePoint({
    this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'location': location,
      'note': note,
    };
  }
}
