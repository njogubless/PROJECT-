import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'name': 'Guest', 'email': 'guest@example.com', 'avatarUrl': ''};
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return {
      'name': userDoc['name'] ?? 'User',
      'email': userDoc['email'] ?? user.email,
      'avatarUrl': userDoc['avatarUrl'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        return CustomScrollView(
          slivers: [
            _buildUserHeader(snapshot.data),
            _buildFeaturedContent(),
            _buildLatestAudioSection(),
            _buildLatestArticlesSection(),
            _buildLatestQuestionsSection(),
          ],
        );
      },
    );
  }

  Widget _buildUserHeader(Map<String, dynamic>? userData) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // CircleAvatar(
                  //   radius: 30,
                  //   backgroundImage: CachedNetworkImageProvider(
                  //     userData?['avatarUrl'] ?? 'https://via.placeholder.com/60',
                  //   ),
                  // ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          userData?['name'] ?? 'Loading...',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 200,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Daily Devotion',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Start your day with inspiration',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Start Reading',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestAudioSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Latest Audio',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: _sampleAudioItems().length,
              itemBuilder: (context, index) {
                return _buildAudioCard(_sampleAudioItems()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard(String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.all(5),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.audiotrack_rounded,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Listen Now',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestArticlesSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Latest Articles',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: _sampleArticleItems().length,
              itemBuilder: (context, index) {
                return _buildArticleCard(_sampleArticleItems()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title) {
    return Container(
      width: 160,
      margin: const EdgeInsets.all(5),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_rounded,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Read More',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestQuestionsSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Latest Questions',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final questions = _sampleQuestionItems();
          final questionIndex = index - 1;
          if (questionIndex >= questions.length) return null;
          
          return _buildQuestionCard(questions[questionIndex]);
        },
        childCount: _sampleQuestionItems().length + 1,
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.question_answer_rounded,
            color: Colors.green,
          ),
        ),
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'View Answer',
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.green,
        ),
      ),
    );
  }

  List<String> _sampleAudioItems() {
    return ["Motivation Talk", "Morning Devotion", "Peaceful Meditation"];
  }

  List<String> _sampleArticleItems() {
    return ["Faith and Courage", "Steps to Overcome Fear", "Walking by Faith"];
  }

  List<String> _sampleQuestionItems() {
    return ["What is faith?", "How to handle challenges?", "Tips on prayer life"];
  }
}