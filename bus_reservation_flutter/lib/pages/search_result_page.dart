import 'package:bus_reservation/models/bus_route.dart';
import 'package:bus_reservation/models/bus_schedule.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/constants.dart';
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
        backgroundColor: Colors.teal,
        elevation: 4.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.teal[50],
              margin: const EdgeInsets.only(bottom: 12.0),
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Showing results for ${route.cityFrom} to ${route.cityTo} on $departureDate",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<AppDataProvider>(
                builder: (context, provider, child) =>
                    FutureBuilder<List<BusSchedule>>(
                  future: provider.getSchedulesByRouteName(route.routeName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final scheduleList = snapshot.data!;
                      return ListView.builder(
                        itemCount: scheduleList.length,
                        itemBuilder: (context, index) {
                          return ScheduleItemView(
                            schedule: scheduleList[index],
                            date: departureDate,
                          );
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;

  const ScheduleItemView({super.key, required this.schedule, required this.date});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        routeNameSeatPlanPage,
        arguments: [schedule, date],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  schedule.bus.busName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  schedule.bus.busType,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                trailing: Text(
                  '$currency${schedule.ticketPrice}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From: ${schedule.busRoute.cityFrom}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      'To: ${schedule.busRoute.cityTo}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Departure Time: ${schedule.departureTime}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Total Seat: ${schedule.bus.totalSeat}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
