import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveler/screen/pages/favorite_screen.dart';
import 'package:traveler/screen/pages/home_screen.dart';
import 'package:traveler/screen/pages/my_trip_screen.dart';
import 'package:traveler/screen/pages/profile_screen.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _currentIndex = 0;

  // Get Email from SharedPreferences
  String _email = '';
  Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    setState(() {
      _email = email ?? '';
      print(_email);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    MyTripPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        shadowColor: Colors.grey, // Set the shadow color
        elevation: 18,
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButtonWithText(
              icon: Icons.home_outlined,
              text: 'Home',
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              isActive: _currentIndex == 0,
            ),
            IconButtonWithText(
              icon: Icons.favorite_border,
              text: 'Favorite',
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              isActive: _currentIndex == 1,
            ),
            IconButtonWithText(
              icon: Icons.map_outlined,
              text: 'My Trip',
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              isActive: _currentIndex == 2,
            ),
            IconButtonWithText(
              icon: Icons.person_outline,
              text: 'Profile',
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              isActive: _currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool isActive;

  const IconButtonWithText({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.blue : null;

    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
