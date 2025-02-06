import 'package:devotion/core/providers/providers.dart';
import 'package:devotion/features/Q&A/presentation/screens/question_page.dart';
import 'package:devotion/features/articles/presentation/screens/article_screen.dart';
import 'package:devotion/features/audio/presentation/screens/devotion.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:devotion/features/books/presentation/screen/book_screen.dart';
import 'package:devotion/widget/app_drawer.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(),
    AudioScreen(),
    const DevotionPage(),
    ArticlePage(),
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
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
          ? "Home"
          :_screens[_selectedIndex].runtimeType.toString()),),
      body: Builder(builder: (context) {
        try {
          return _screens[_selectedIndex];
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error loading page'),
            ),
          );
          return const Center(
            child: Text('Error loading page'),
          );
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
                    padding: const EdgeInsets.all(1),
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
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
