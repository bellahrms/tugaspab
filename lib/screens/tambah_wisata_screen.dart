import 'package:flutter/material.dart';
import '../models/wisata_model.dart';
import '../services/wisata_service.dart';

import 'dart:ui_web' as ui;
import 'dart:html' as html;

class TambahWisataScreen extends StatefulWidget {
  const TambahWisataScreen({super.key});

  @override
  State<TambahWisataScreen> createState() => _TambahWisataScreenState();
}

class _TambahWisataScreenState extends State<TambahWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  final WisataService _wisataService = WisataService();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isLoading = false;
  String _mapQuery = 'Palembang'; 
  String _base64Image = ''; 
  int _fileSizeInBytes = 0;

  @override
  void initState() {
    super.initState();
    _daftarIframePeta(_mapQuery);
  }

  void _daftarIframePeta(String query) {
    ui.platformViewRegistry.registerViewFactory(
      'live-peta-wisata-$query',
      (int viewId) => html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = 'https://maps.google.com/maps?q=$query&output=embed',
    );
  }

  void _updateMapPreview() {
    if (_alamatController.text.trim().isNotEmpty) {
      final query = _alamatController.text.trim();
      final encodedQuery = Uri.encodeComponent(query);
      
      setState(() {
        _mapQuery = encodedQuery;
        _daftarIframePeta(encodedQuery); 
      });
    }
  }

  void _pilihFotoDariLaptop() {
    final uploadInput = html.InputElement(type: 'file')..accept = 'image/*';
    uploadInput.click(); 

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        _fileSizeInBytes = file.size ?? 0; 

        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _base64Image = reader.result as String; 
          });
        });
      }
    });
  }

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String finalImageUrl = _base64Image;
      if (_fileSizeInBytes > 600000 || _base64Image.isEmpty) {
        finalImageUrl = 'https://images.unsplash.com/photo-1596436889106-be35e843f974?w=600';
      }

      final wisataBaru = WisataModel(
        id: '',
        nama: _namaController.text,
        deskripsi: _deskripsiController.text,
        alamat: _alamatController.text,
        imageUrl: finalImageUrl,
        isFavorite: false, 
      );

      try {
        await _wisataService.tambahWisata(wisataBaru);
        
        if (!mounted) return;
        setState(() {
          _isLoading = false; 
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text('Berhasil Disimpan!'),
              ],
            ),
            content: Text('Wisata sejarah "${_namaController.text}" telah sukses ditambahkan ke aplikasi.'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pop(context); 
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );

      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Wisata Sejarah'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sedang Menyimpan Data...'),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _namaController, 
                    decoration: const InputDecoration(labelText: 'Nama Tempat Wisata', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Nama tempat tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _deskripsiController, 
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Deskripsi Sejarah', border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _alamatController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat Lengkap Map',
                            hintText: 'Contoh: Jembatan Ampera, Palembang',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on, color: Colors.red),
                          ),
                          validator: (value) => value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        ),
                        onPressed: _updateMapPreview,
                        icon: const Icon(Icons.search),
                        label: const Text('Cari Titik'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text('Preview Titik Peta:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      key: ValueKey(_mapQuery), 
                      child: HtmlElementView(viewType: 'live-peta-wisata-$_mapQuery'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Foto Lokasi Wisata:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pilihFotoDariLaptop,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.red.shade900, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _base64Image.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.red.shade900),
                                const SizedBox(height: 8),
                                Text(
                                  'Klik untuk Upload Foto dari Laptop', 
                                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(_base64Image, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _simpanData,
                    child: const Text('Simpan Ke Firebase', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    super.dispose();
  }
}