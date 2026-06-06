import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wisata_model.dart';

class WisataService {
  final CollectionReference _wisataCollection =
      FirebaseFirestore.instance.collection('wisata');

  Stream<List<WisataModel>> getWisataList() {
    return _wisataCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WisataModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> tambahWisata(WisataModel wisata) async {
    await _wisataCollection.add({
      'nama': wisata.nama,
      'deskripsi': wisata.deskripsi,
      'alamat': wisata.alamat,
      'imageUrl': wisata.imageUrl,
      'isFavorite': wisata.isFavorite,
    });
  }
}