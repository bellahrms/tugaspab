import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart'; 

class MainNavigationScreen extends StatefulWidget {
  final String role; 
  final String username; 

  const MainNavigationScreen({super.key, required this.role, required this.username});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late List<Widget> _halaman;

  @override
  void initState() {
    super.initState();
    _halaman = [
      HomeScreen(role: widget.role), 
      const FavoriteScreen(), 
      ProfileScreen(role: widget.role, username: widget.username), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() { 
            _currentIndex = index; 
          });
        },
        selectedItemColor: widget.role == 'admin' ? Colors.red.shade900 : Colors.blueGrey.shade900,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ), 
    );
  }
}