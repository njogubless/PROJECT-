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

class MainLayoutState extends State<MainLayout> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AudioScreen(),
    const DevotionPage(),
   ArticleScreen(),
    BookScreen(),
    const QuestionPage(),
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.article),
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
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
