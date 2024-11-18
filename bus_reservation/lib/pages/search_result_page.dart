import 'package:bus_reservation/models/but_route.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final BusRoute route = argList[0];
    final String departureDate = argList[1];
    final provider = Provider.of<AppDataProvider>(context);
    provider.getSchedulesByRouteName(route.routeName);
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
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Text(
                "Showing results for ${route.cityFrom} to ${route.cityTo} on $departureDate"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: provider.scheduleList
                  .map((schedule) => ListTile(
                        title: Text("Bus: ${schedule.bus.busName}"),
                        subtitle: Text("Type: ${schedule.bus.busType}"),
                        trailing:
                            Text("Departure Time: ${schedule.departureTime}"),
                      ))
                  .toList(),
            )
          ],
        ));
  }
}
