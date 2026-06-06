import 'package:flutter/material.dart';
import '../models/wisata_model.dart';

import 'dart:ui_web' as ui;
import 'dart:html' as html;

class DaftarWisataScreen extends StatefulWidget {
  final WisataModel wisata;

  const DaftarWisataScreen({super.key, required this.wisata});

  @override
  State<DaftarWisataScreen> createState() => _DaftarWisataScreenState();
}

class _DaftarWisataScreenState extends State<DaftarWisataScreen> {
  late String _encodedAlamat;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wisata.nama),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.wisata.imageUrl.isNotEmpty
                ? Image.network(
                    widget.wisata.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image, size: 100, color: Colors.grey.shade600),
                  ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wisata.nama,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.wisata.alamat,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  const Text(
                    'Tentang Sejarah:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.wisata.deskripsi,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  const Text(
                    'Lokasi Peta Wisata:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
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