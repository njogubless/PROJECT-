
import 'package:devotion/services/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> screens;
  final int selectedIndex;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.screens,
    required this.selectedIndex,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: searchState.isSearching
          ? TextField(
              autofocus: true,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search articles, audio, books...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () => searchNotifier.stopSearch(),
                ),
              ),
              onChanged: (query) => searchNotifier.performSearch(query),
            )
          : Text(
              selectedIndex == 0
                  ? title
                  : screens[selectedIndex].runtimeType.toString(),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            searchState.isSearching ? Icons.search_off : Icons.search,
          ),
          onPressed: () {
            if (searchState.isSearching) {
              searchNotifier.stopSearch();
            } else {
              searchNotifier.startSearch();
            }
          },
        ),
     
      ],
    );
  }
}
