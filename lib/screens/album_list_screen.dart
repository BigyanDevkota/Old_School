import 'package:flutter/material.dart';
import 'package:photo_album_app/screens/cover_page_screen.dart';
import 'package:photo_album_app/screens/orientation_screen.dart';

class Album {
  final String name;
  final int photoCount;
  final String? coverImagePath;

  Album({required this.name, this.photoCount = 0, this.coverImagePath});
}

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({super.key});

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  final List<Album> _albums = [];

  void _createAlbum() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text("New Album"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter album name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newAlbum = Album(name: controller.text);

                  setState(() {
                    _albums.add(newAlbum);
                  });

                  Navigator.pop(ctx); // close dialog

                  // 🚀 Immediately go to ChooseOrientationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChooseOrientationScreen(albumName: newAlbum.name),
                    ),
                  );
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Albums"), centerTitle: true),
      body: _albums.isEmpty
          ? const Center(child: Text("No albums yet. Tap + to add one."))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _albums.length,
              itemBuilder: (context, index) {
                final album = _albums[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Existing albums also go to orientation chooser
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChooseOrientationScreen(albumName: album.name),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_album,
                          size: 60,
                          color: Colors.blueGrey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          album.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${album.photoCount} photos"),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAlbum,
        child: const Icon(Icons.add),
      ),
    );
  }
}