import 'package:flutter/material.dart';
import 'login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  final String role;
  final String username;

  const ProfileScreen({super.key, required this.role, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.shade900, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'LOGIN SEBAGAI: ${username.toUpperCase()}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: role == 'admin' ? Colors.red.shade900 : Colors.green.shade700,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    role == 'admin' ? 'ROLE: ADMIN' : 'ROLE: USER BIASA',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                const Text(
                  'sandy bela',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'NPM: 222640153',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistem Informasi',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.red),
                          title: Text('Email'),
                          subtitle: Text('emailanda@domain.com'),
                        ),
                        ListTile(
                          leading: Icon(Icons.school, color: Colors.red),
                          title: Text('Institusi'),
                          subtitle: Text('Universitas MDP'),
                        ),
                        ListTile(
                          leading: Icon(Icons.code, color: Colors.red),
                          title: Text('Aplikasi'),
                          subtitle: Text('Wisata Sejarah Palembang v1.0'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar dari Akun (Logout)', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false, 
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}