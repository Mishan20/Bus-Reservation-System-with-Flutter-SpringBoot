import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/colors.dart';
import 'package:bus_reservation/utils/constants.dart';
import 'package:bus_reservation/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/seat_plan_view.dart';
import '../models/bus_schedule.dart';

class SeatPlanPage extends StatefulWidget {
  const SeatPlanPage({Key? key}) : super(key: key);

  @override
  State<SeatPlanPage> createState() => _SeatPlanPageState();
}

class _SeatPlanPageState extends State<SeatPlanPage> {
  late BusSchedule schedule;
  late String departureDate;
  int totalSeatBooked = 0;
  String bookedSeatNumbers = '';
  List<String> selectedSeats = [];
  bool isFirst = true;
  bool isDataLoading = true;
  ValueNotifier<String> selectedSeatStringNotifier = ValueNotifier('');

  @override
  void didChangeDependencies() {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    schedule = argList[0];
    departureDate = argList[1];
    _getData();
    super.didChangeDependencies();
  }

  _getData() async {
    try {
      final resList = await Provider.of<AppDataProvider>(context, listen: false)
          .getReservationsByScheduleAndDepartureDate(
              schedule.scheduleId!, departureDate);
      setState(() {
        isDataLoading = false;
      });
      List<String> seats = [];
      for (final res in resList) {
        totalSeatBooked += res.totalSeatBooked;
        seats.add(res.seatNumbers);
      }
      bookedSeatNumbers = seats.join(',');
    } catch (error) {
      setState(() {
        isDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seat Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            _buildLegendSection(),
            ValueListenableBuilder(
              valueListenable: selectedSeatStringNotifier,
              builder: (context, value, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Selected: $value',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            if (!isDataLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SeatPlanView(
                          onSeatSelected: (isSelected, seat) {
                            setState(() {
                              if (isSelected) {
                                selectedSeats.add(seat);
                              } else {
                                selectedSeats.remove(seat);
                              }
                              selectedSeatStringNotifier.value =
                                  selectedSeats.join(',');
                            });
                          },
                          totalSeatBooked: totalSeatBooked,
                          bookedSeatNumbers: bookedSeatNumbers,
                          totalSeat: schedule.bus.totalSeat,
                          isBusinessClass:
                              schedule.bus.busType == busTypeACBusiness,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (selectedSeats.isEmpty) {
                    showMsg(context, 'Please select your seat first');
                    return;
                  }
                  Navigator.pushNamed(context, routeNameBookingConfirmationPage,
                      arguments: [
                        departureDate,
                        schedule,
                        selectedSeatStringNotifier.value,
                        selectedSeats.length
                      ]);
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(
            color: seatBookedColor,
            label: 'Booked',
          ),
          const SizedBox(width: 20),
          _buildLegendItem(
            color: seatAvailableColor,
            label: 'Available',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black45),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _onNextButtonPressed() {
    if (selectedSeats.isEmpty) {
      showMsg(context, 'Please select your seat first');
      return;
    }
    Navigator.pushNamed(
      context,
      routeNameBookingConfirmationPage,
      arguments: [
        departureDate,
        schedule,
        selectedSeatStringNotifier.value,
        selectedSeats.length,
      ],
    );
  }
}
