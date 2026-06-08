import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _prosesRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konfirmasi password tidak cocok!'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() { _isLoading = true; });

      try {
        String username = _usernameController.text.trim().toLowerCase();

        // Kunci Otomatisasi Role
        String ditentukanRole = 'user'; 
        if (username == 'sandy') {
          ditentukanRole = 'admin'; 
        }

        final cekUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .get();

        if (cekUser.exists) {
          setState(() { _isLoading = false; });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username sudah terdaftar!'), backgroundColor: Colors.orange),
          );
          return;
        }

        await FirebaseFirestore.instance.collection('users').doc(username).set({
          'username': username,
          'password': _passwordController.text.trim(),
          'role': ditentukanRole, 
        });

        setState(() { _isLoading = false; });
        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil!'),
            content: Text('Akun "$username" otomatis terdaftar sebagai ($ditentukanRole).'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal tersambung ke Firebase: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Baru'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              width: 400,
              child: _isLoading 
                ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()))
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Pendaftaran Akun\n(Nama "sandy" otomatis Admin, nama lain otomatis User)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_add)),
                          validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline)),
                          validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Konfirmasi Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_clock)),
                          validator: (value) => value!.isEmpty ? 'Konfirmasi password wajib' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                          onPressed: _prosesRegister,
                          child: const Text('Daftar Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}