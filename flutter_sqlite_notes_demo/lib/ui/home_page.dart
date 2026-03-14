import 'package:flutter/material.dart';
import 'package:flutter_sqlite_notes_demo/ui/note_form_page.dart';
import 'package:flutter_sqlite_notes_demo/ui/state/note_store.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // โหลดครังแรกหลัง build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteStore>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NoteStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes (${store.notes.length})'),
        actions: [
          IconButton(
            tooltip: 'ล้างทังหมด',
            onPressed: store.loading
                ? null
                : () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('ยืนยัน'),
                        content: const Text('ต้องการลบโน้ตทังหมดใช่ไหม?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('ยกเลิก'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('ลบ'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      await context.read<NoteStore>().clearAll();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ลบโน้ตทั้งหมดแล้ว')),
                      );
                    }
                  },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: store.loading
            ? null
            : () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NoteFormPage()),
                );
              },
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มโน้ต'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (store.error != null)
              MaterialBanner(
                content: Text(store.error!),
                actions: [
                  TextButton(
                    onPressed: () => context.read<NoteStore>().loadNotes(),
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            Expanded(
              child: store.loading
                  ? const Center(child: CircularProgressIndicator())
                  : store.notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.note_outlined,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ยังไม่มีโน้ต',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'แตะปุ่ม "+" เพื่อเริ่มเขียน',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: store.notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final n = store.notes[i];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              child: Text(
                                n.title.isNotEmpty
                                    ? n.title[0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(
                              n.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'แก้ไข: ${DateFormat.yMMMd().add_jm().format(n.updatedAt)}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                await context.read<NoteStore>().removeNote(
                                  n.id!,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ลบโน้ตเรียบร้อย'),
                                    ),
                                  );
                                }
                              },
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoteFormPage(
                                    noteId: n.id,
                                    initialTitle: n.title,
                                    initialContent: n.content,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
