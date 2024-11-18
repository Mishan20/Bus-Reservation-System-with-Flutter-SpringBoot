import 'package:bus_reservation/pages/search_page.dart';
import 'package:bus_reservation/pages/search_result_page.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppDataProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Reservation System',
      theme: ThemeData(
        primaryColor: Colors.teal,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.tealAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.teal),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.tealAccent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal,
          ),
        ),
      ),
      home: const SearchPage(),
      routes: {
        routeNameHome: (context) => const SearchPage(),
        routeNameSearchResultPage: (context) => const SearchResultPage(),
      },
    );
  }
}
