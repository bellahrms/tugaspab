import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/wisata_service.dart';
import '../models/wisata_model.dart';
import 'daftar_wisata_screen.dart';
import 'tambah_wisata_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role; 

  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WisataService _wisataService = WisataService();

  @override
  Widget build(BuildContext context) {
    final Color themeColor = widget.role == 'admin' ? Colors.red.shade900 : Colors.blueGrey.shade900;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wisata Sejarah Palembang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              widget.role == 'admin' ? 'Mode Kelola: Administrator (Sandy)' : 'Mode Penjelajah: Pengunjung (Bela)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: themeColor,
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: widget.role == 'admin' ? Colors.amber.shade100 : Colors.blue.shade50,
            child: Row(
              children: [
                Icon(
                  widget.role == 'admin' ? Icons.security : Icons.info_outline,
                  color: widget.role == 'admin' ? Colors.amber.shade900 : Colors.blue.shade900,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.role == 'admin'
                        ? 'Halo Sandy! Anda masuk sebagai Admin. Hak akses modifikasi data aktif.'
                        : 'Halo Bela! Hak akses penuh aktif, Anda juga bisa menambah atau mengelola data.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: widget.role == 'admin' ? Colors.amber.shade900 : Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<WisataModel>>(
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
                            : Icon(Icons.account_balance, size: 40, color: themeColor),
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
                              await FirebaseFirestore.instance
                                  .collection('wisata')
                                  .doc(wisata.id)
                                  .update({
                                    'isFavorite': statusBaru,
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
                            MaterialPageRoute(
                              builder: (context) => DaftarWisataScreen(wisata: wisata, role: widget.role),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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