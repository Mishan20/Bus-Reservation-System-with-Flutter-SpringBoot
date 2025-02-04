// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:bus_reservation/customwidgets/reservation_item_body_view.dart';
import 'package:bus_reservation/customwidgets/reservation_item_header_view.dart';
import 'package:bus_reservation/customwidgets/search_box.dart';
import 'package:bus_reservation/providers/app_data_provider.dart';
import 'package:bus_reservation/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reservation_expansion_item.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isFirst = true;
  List<ReservationExpansionItem> items = [];

  @override
  void didChangeDependencies() {
    if (isFirst) {
      _getData();
    }
    super.didChangeDependencies();
  }

  _getData() async {
    final reservations =
        await Provider.of<AppDataProvider>(context, listen: false)
            .getAllReservations();
    items = Provider.of<AppDataProvider>(context, listen: false)
        .getExpansionItems(reservations);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation List',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Style the AppBar
        elevation: 4, // Add elevation for a shadow effect
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: Colors.grey[100], // Background color for the entire page
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchBox(
                onSubmit: (value) {
                  _search(value);
                },
                // Add a hint to the SearchBox
              ),
              const SizedBox(height: 20), // Space between search box and list
              ExpansionPanelList(
                elevation: 1, // Slight elevation for the panel list
                dividerColor: Colors.grey, // Divider color between panels
                animationDuration: const Duration(
                    milliseconds: 500), // Smooth expansion animation
                expandedHeaderPadding: const EdgeInsets.symmetric(
                    vertical: 5), // Padding when expanded
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    items[index].isExpanded = !isExpanded;
                  });
                },
                children: items
                    .map((item) => ExpansionPanel(
                          canTapOnHeader:
                              true, // Allow tapping the header to expand/collapse
                          backgroundColor:
                              Colors.white, // Background color for the panel
                          isExpanded: item.isExpanded,
                          headerBuilder: (context, isExpanded) => Container(
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? Colors.blueGrey[
                                      50] // Change color when expanded
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child:
                                ReservationItemHeaderView(header: item.header),
                          ),
                          body: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: ReservationItemBodyView(body: item.body),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search(String value) async {
    final data = await Provider.of<AppDataProvider>(context, listen: false)
        .getReservationsByMobile(value);
    if (data.isEmpty) {
      showMsg(context, 'No record found');
      return;
    }
    setState(() {
      items = Provider.of<AppDataProvider>(context, listen: false)
          .getExpansionItems(data);
    });
  }
}
