import 'package:bus_reservation/utils/colors.dart';
import 'package:flutter/material.dart';

class SeatPlanView extends StatelessWidget {
  final int totalSeat;
  final String bookedSeatNumbers;
  final int totalSeatBooked;
  final bool isBusinessClass;
  final Function(bool, String) onSeatSelected;

  const SeatPlanView({
    super.key,
    required this.totalSeat,
    required this.bookedSeatNumbers,
    required this.totalSeatBooked, 
    required this.isBusinessClass,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Define seat labels for rows (A, B, C, etc.)
    const seatLabelList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    final noOfRows = (isBusinessClass ? totalSeat / 3 : totalSeat / 4).ceil();
    final noOfColumns = isBusinessClass ? 3 : 4;

    // Generate seat arrangement based on total seats
    List<List<String>> seatArrangement = [];
    for (int i = 0; i < noOfRows; i++) {
      List<String> columns = [];
      for (int j = 0; j < noOfColumns; j++) {
        if (i < seatLabelList.length) {
          columns.add('${seatLabelList[i]}${j + 1}');
        }
      }
      seatArrangement.add(columns);
    }

    final List<String> bookedSeatList =
        bookedSeatNumbers.isEmpty ? [] : bookedSeatNumbers.split(',');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'FRONT',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Divider(
            height: 20,
            color: Colors.black,
            thickness: 1.5,
          ),
          Column(
            children: [
              for (int i = 0; i < seatArrangement.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int j = 0; j < seatArrangement[i].length; j++)
                      Row(
                        children: [
                          Seat(
                            isBooked:
                                bookedSeatList.contains(seatArrangement[i][j]),
                            label: seatArrangement[i][j],
                            onSelect: (value) {
                              onSeatSelected(value, seatArrangement[i][j]);
                            },
                          ),
                          if (isBusinessClass && j == 0)
                            const SizedBox(width: 24),
                          if (!isBusinessClass && j == 1)
                            const SizedBox(width: 24),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Seat extends StatefulWidget {
  final String label;
  final bool isBooked;
  final Function(bool) onSelect;

  const Seat({
    super.key,
    required this.label,
    required this.isBooked,
    required this.onSelect,
  });

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isBooked
          ? null
          : () {
              setState(() {
                selected = !selected;
              });
              widget.onSelect(selected);
            },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isBooked
              ? seatBookedColor
              : selected
                  ? seatSelectedColor
                  : seatAvailableColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: widget.isBooked
              ? null
              : [
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(4, 4),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}