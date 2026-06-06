import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/wisata_service.dart';
import '../models/wisata_model.dart';
import 'daftar_wisata_screen.dart';
import 'tambah_wisata_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WisataService _wisataService = WisataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Sejarah Palembang'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite), 
            tooltip: 'Lihat Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<WisataModel>>(
        stream: _wisataService.getWisataList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Terjadi kesalahan memuat data'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataWisata = snapshot.data ?? [];
          if (dataWisata.isEmpty) return const Center(child: Text('Belum ada data wisata.'));

          return ListView.builder(
            itemCount: dataWisata.length,
            itemBuilder: (context, index) {
              final wisata = dataWisata[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: wisata.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(wisata.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        )
                      : Icon(Icons.account_balance, size: 40, color: Colors.red.shade900),
                  title: Text(wisata.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(wisata.alamat, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(
                      wisata.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: wisata.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      try {
                        bool statusBaru = !wisata.isFavorite;
                        
                        // Memperbarui dokumen ke Firebase menggunakan tipe data Boolean murni agar sinkron
                        await FirebaseFirestore.instance
                            .collection('wisata')
                            .doc(wisata.id)
                            .update({
                              'isFavorite': statusBaru,
                              'isFavorite ': FieldValue.delete() // Otomatis menghapus field spasimu yang eror!
                            });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal mengubah favorit: $e')),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaftarWisataScreen(wisata: wisata)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahWisataScreen()),
          );
        },
      ),
    );
  }
}