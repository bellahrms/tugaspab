import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _prosesLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      
      String inputUser = _usernameController.text.trim().toLowerCase();
      String inputPass = _passwordController.text.trim();

      if ((inputUser == 'bela' && inputPass == 'bela 123') || (inputUser == 'sandy' && inputPass == 'sandy 123')) {
        String roleBawaan = (inputUser == 'sandy') ? 'admin' : 'user';
        setState(() { _isLoading = false; });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationScreen(role: roleBawaan, username: inputUser)),
        );
        return;
      }

      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(inputUser)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> dataUser = userDoc.data() as Map<String, dynamic>;
          String dbPassword = dataUser['password'] ?? '';
          String dbRole = dataUser['role'] ?? 'user';

          if (inputPass == dbPassword) {
            setState(() { _isLoading = false; });
            if (!mounted) return;
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainNavigationScreen(role: dbRole, username: inputUser),
              ),
            );
            return;
          }
        }

        setState(() { _isLoading = false; });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau Password Salah!'), backgroundColor: Colors.red),
        );
      } catch (e) {
        setState(() { _isLoading = false; });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Koneksi Database: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Icon(Icons.account_balance, size: 60, color: Colors.red.shade900),
                        const SizedBox(height: 12),
                        const Text('Wisata Sejarah Palembang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                          validator: (value) => value!.isEmpty ? 'Username wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () { setState(() { _obscureText = !_obscureText; }); },
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? 'Password wajib diisi' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          onPressed: _prosesLogin,
                          child: const Text('Masuk Aplikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                              },
                              child: Text('Daftar Disini', style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)),
                            ),
                          ],
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