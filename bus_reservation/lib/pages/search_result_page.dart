import 'package:bus_reservation/models/but_route.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final BusRoute route = argList[0];
    final String departureDate = argList[1];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Result",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Search Result",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
