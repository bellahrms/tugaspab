class WisataModel {
  final String id;
  String nama;
  String deskripsi;
  String alamat;
  final String imageUrl;
  final bool isFavorite; 

  WisataModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory WisataModel.fromFirestore(String docId, Map<String, dynamic> data) {
    dynamic dbFavorite = data['isFavorite'] ?? data['isFavorite ']; 
    bool favoriteValue = false;
    
    if (dbFavorite is bool) {
      favoriteValue = dbFavorite;
    } else if (dbFavorite is String) {
      favoriteValue = dbFavorite.toLowerCase().trim() == 'true';
    }

    return WisataModel(
      id: docId,
      nama: data['nama'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      alamat: data['alamat'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: favoriteValue,
    );
  }
}