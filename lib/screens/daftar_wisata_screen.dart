import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wisata_model.dart';

import 'dart:ui_web' as ui;
import 'dart:html' as html;

class DaftarWisataScreen extends StatefulWidget {
  final WisataModel wisata;
  final String role; 

  const DaftarWisataScreen({super.key, required this.wisata, required this.role});

  @override
  State<DaftarWisataScreen> createState() => _DaftarWisataScreenState();
}

class _DaftarWisataScreenState extends State<DaftarWisataScreen> {
  late String _currentNama;
  late String _currentDeskripsi;
  late String _currentAlamat;
  late String _encodedAlamat;

  @override
  void initState() {
    super.initState();
    _currentNama = widget.wisata.nama;
    _currentDeskripsi = widget.wisata.deskripsi;
    _currentAlamat = widget.wisata.alamat;

    _encodedAlamat = Uri.encodeComponent(widget.wisata.alamat.trim().isNotEmpty 
        ? widget.wisata.alamat 
        : widget.wisata.nama);

    ui.platformViewRegistry.registerViewFactory(
      'detail-peta-${widget.wisata.id}',
      (int viewId) => html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = 'https://maps.google.com/maps?q=$_encodedAlamat&t=&z=13&ie=UTF8&iwloc=&output=embed',
    );
  }

  void _hapusWisata() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Apakah kamu yakin ingin menghapus tempat wisata sejarah ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseFirestore.instance.collection('wisata').doc(widget.wisata.id).delete();
                if (!mounted) return;
                Navigator.pop(context); 
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editWisata() {
    final namaController = TextEditingController(text: _currentNama);
    final deskripsiController = TextEditingController(text: _currentDeskripsi);
    final alamatController = TextEditingController(text: _currentAlamat);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Wisata Sejarah'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Tempat')),
              const SizedBox(height: 12),
              TextFormField(controller: deskripsiController, maxLines: 3, decoration: const InputDecoration(labelText: 'Deskripsi')),
              const SizedBox(height: 12),
              TextFormField(controller: alamatController, decoration: const InputDecoration(labelText: 'Alamat')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseFirestore.instance.collection('wisata').doc(widget.wisata.id).update({
                  'nama': namaController.text,
                  'deskripsi': deskripsiController.text,
                  'alamat': alamatController.text,
                });

                setState(() {
                  _currentNama = namaController.text;
                  _currentDeskripsi = deskripsiController.text;
                  _currentAlamat = alamatController.text;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentNama),
        backgroundColor: widget.role == 'admin' ? Colors.red.shade900 : Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.edit), tooltip: 'Edit Wisata', onPressed: _editWisata),
          IconButton(icon: const Icon(Icons.delete), tooltip: 'Hapus Wisata', onPressed: _hapusWisata),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.wisata.imageUrl.isNotEmpty
                ? Image.network(widget.wisata.imageUrl, width: double.infinity, height: 250, fit: BoxFit.cover)
                : Container(height: 250, color: Colors.grey.shade300, child: const Icon(Icons.image, size: 100)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentNama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_currentAlamat, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text('Tentang Sejarah:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_currentDeskripsi, style: const TextStyle(fontSize: 16, height: 1.5), textAlign: TextAlign.justify),
                  const SizedBox(height: 24),
                  const Divider(),
                  const Text('Lokasi Peta Wisata:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200, border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: HtmlElementView(viewType: 'detail-peta-${widget.wisata.id}'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}