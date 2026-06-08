import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wisata_model.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Favorit Anda'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('wisata').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          
          final List<WisataModel> listFavorit = [];
          for (var doc in docs) {
            final wisata = WisataModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
            if (wisata.isFavorite) {
              listFavorit.add(wisata);
            }
          }

          if (listFavorit.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada wisata sejarah yang disukai.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listFavorit.length,
            itemBuilder: (context, index) {
              final wisata = listFavorit[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: wisata.imageUrl.isNotEmpty
                        ? Image.network(wisata.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 60),
                  ),
                  title: Text(wisata.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(wisata.alamat, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('wisata')
                            .doc(wisata.id)
                            .update({
                              'isFavorite': false,
                              'isFavorite ': FieldValue.delete()
                            });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menghapus favorit: $e')),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}