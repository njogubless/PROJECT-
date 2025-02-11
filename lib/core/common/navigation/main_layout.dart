import 'package:devotion/core/providers/Audio_screen.dart.dart';
import 'package:devotion/features/Q&A/presentation/screens/question_page.dart';
import 'package:devotion/features/articles/presentation/screens/article_screen.dart';
import 'package:devotion/features/audio/presentation/screens/audio_list_page.dart';
<<<<<<< HEAD
import 'package:devotion/features/audio/presentation/screens/audio_record_page.dart';
=======
>>>>>>> d8dc86b ( making changes on the audio platform and book screen)
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:devotion/features/books/presentation/screen/book_screen.dart';
import 'package:devotion/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(),
    AudioScreen(),
    const DevotionPage(),
    ArticlePage(),
    BookScreen(),
    const QuestionPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animations = List.generate(
      6,
      (index) => Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index + 1) * 0.1,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          _selectedIndex == 0
              ? "Welcome Home"
              : _screens[_selectedIndex].runtimeType.toString(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Builder(
          builder: (context) {
            try {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[_selectedIndex],
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            } catch (e) {
              return const Center(
                child: Text('Error loading page'),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: List.generate(
              6,
              (index) => _buildNavItem(index),
            ),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index) {
    final List<IconData> icons = [
      Icons.home_rounded,
      Icons.audiotrack_rounded,
      Icons.mic_rounded,
      Icons.article_rounded,
      Icons.book_rounded,
      Icons.question_answer_rounded,
    ];

    final List<String> labels = [
      'Home',
      'Audio',
      'Devotion',
      'Articles',
      'Books',
      'Q&A',
    ];

    return BottomNavigationBarItem(
      icon: ScaleTransition(
        scale: _animations[index],
        child: Stack(
          children: [
            Icon(icons[index]),
            if (index == 3) // Articles tab with notification badge
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      label: labels[index],
    );
  }
}

// Add these theme configurations to your main.dart
ThemeData appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF6366F1), // Indigo
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: GoogleFonts.poppinsTextTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF6366F1),
      unselectedItemColor: Colors.grey,
    ),
  );
}