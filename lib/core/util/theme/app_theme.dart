import 'package:flutter/material.dart';
 import 'package:google_fonts/google_fonts.dart';

 ThemeData appTheme() {
//   // FIX #6: Single accent color — no more blue vs purple conflict.
   const Color accent = Color.fromARGB(255, 82, 169, 240);
   return ThemeData(
     primaryColor: accent,
     fontFamily: GoogleFonts.poppins().fontFamily,
     textTheme: GoogleFonts.poppinsTextTheme(),
         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: accent,
           unselectedItemColor: Colors.grey,
         ),
       );
     }