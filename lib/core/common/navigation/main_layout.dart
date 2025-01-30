import 'package:flutter/material.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:devotion/features/Q&A/presentation/screens/question_page.dart';
import 'package:devotion/features/articles/presentation/screens/article_screen.dart';
import 'package:devotion/features/audio/presentation/screens/audio_screen.dart';
import 'package:devotion/features/audio/presentation/screens/devotion.dart';
import 'package:devotion/features/books/presentation/screen/book_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AudioScreen(),
    const DevotionPage(),
    ArticleScreen(),
    BookScreen(),
    const QuestionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: 'Audio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Devotion',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.article),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Articles',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Q&A',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}